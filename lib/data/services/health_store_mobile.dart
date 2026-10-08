import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../models/health_observation.dart';
import '../models/health_summary_window.dart';
import '../../core/utils/health_aggregation.dart';
import 'health_daily_cache.dart';
import 'health_summary_cache.dart';
export 'health_daily_cache.dart' show healthCacheSchema;
import 'health_repository.dart';
import 'health_store_web.dart';

HealthRepository createHealthRepository() =>
    Platform.isIOS || Platform.isAndroid
    ? EncryptedHealthRepository()
    : UnsupportedHealthRepository();

/// One independent, device-local profile. No cloud identifiers or network clients.
class EncryptedHealthRepository
    implements HealthRepository, HealthSummaryCache {
  EncryptedHealthRepository();

  /// Injected test database; production always opens and verifies SQLCipher.
  @visibleForTesting
  EncryptedHealthRepository.forTesting(Database database)
    : _database = database;

  @visibleForTesting
  static Future<EncryptedHealthRepository> initializeForTesting(
    Database database,
  ) async {
    await _recoverInterruptedImports(database);
    return EncryptedHealthRepository.forTesting(database);
  }

  static const _keyName = 'private_health_v1';
  static const _privacy = MethodChannel('inbodysimpletracker/private_health');
  static const _secureStorage = FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.unlocked_this_device,
      synchronizable: false,
    ),
  );
  Database? _database;
  Future<void>? _opening;
  Database get _db =>
      _database ?? (throw StateError('Private Health is closed.'));

  static String _randomId() => base64UrlEncode(
    List<int>.generate(32, (_) => Random.secure().nextInt(256)),
  );

  @override
  Future<void> open() =>
      _opening ??= _open().whenComplete(() => _opening = null);

  Future<void> _open() async {
    if (_database != null) return;
    if (!Platform.isIOS && !Platform.isAndroid) {
      throw UnsupportedError('Private Health requires iOS or Android.');
    }
    Database? opened;
    try {
      final support = await getApplicationSupportDirectory();
      final directory = Directory('${support.path}/private_health_data');
      await directory.create(recursive: true);
      // Fail closed: native backup exclusion/file protection is mandatory.
      final protected = await _privacy.invokeMethod<bool>('protectDirectory', {
        'path': directory.path,
      });
      if (protected != true) throw StateError('Private storage unavailable.');
      final path = '${directory.path}/health.sqlite';
      var key = await _secureStorage.read(key: _keyName);
      if (key == null) {
        if (await File(path).exists()) {
          throw StateError('Private vault key unavailable.');
        }
        key = _randomId();
        await _secureStorage.write(key: _keyName, value: key);
      }
      // An empty/malformed stored value must never open an unencrypted database.
      if (base64Url.decode(key).length != 32) {
        throw StateError('Private vault key unavailable.');
      }
      opened = await openDatabase(
        path,
        password: key,
        version: 2,
        singleInstance: false,
        onConfigure: (db) async {
          final cipher = await db.rawQuery('PRAGMA cipher_version');
          if (cipher.isEmpty ||
              cipher.first.values.isEmpty ||
              cipher.first.values.first is! String ||
              (cipher.first.values.first as String).trim().isEmpty) {
            throw StateError('Encrypted storage unavailable.');
          }
          await db.execute('PRAGMA foreign_keys = ON');
          await db.execute('PRAGMA secure_delete = ON');
        },
        onCreate: (db, version) async {
          for (final statement in [...healthSchema, ...healthCacheSchema]) {
            await db.execute(statement);
          }
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            for (final statement in healthCacheSchema) {
              await db.execute(statement);
            }
          }
        },
      );
      await _recoverInterruptedImports(opened);
      if (await _privacy.invokeMethod<bool>('protectDirectory', {
            'path': directory.path,
          }) !=
          true) {
        throw StateError('Private storage unavailable.');
      }
      _database = opened;
    } catch (_) {
      await opened?.close();
      // Plugin errors may contain a filename or SQL parameters; do not propagate.
      throw StateError(
        'Cannot unlock protected Health storage on this device.',
      );
    }
  }

  @override
  Future<void> close() async {
    await _opening;
    final db = _database;
    _database = null;
    await db?.close();
  }

  @override
  Future<String> beginImport() async {
    final id = _randomId();
    await _db.insert('batches', {
      'id': id,
      'created_ms': DateTime.now().toUtc().millisecondsSinceEpoch,
      'status': 'importing',
      'record_count': 0,
      'skipped_count': 0,
    });
    return id;
  }

  Future<void> _requireImport(DatabaseExecutor db, String id) async {
    final rows = await db.query(
      'batches',
      columns: ['id'],
      where: 'id = ? AND status = ?',
      whereArgs: [id, 'importing'],
      limit: 1,
    );
    if (rows.isEmpty) throw StateError('Import is no longer active.');
  }

  @override
  Future<int> appendObservations(
    String batchId,
    List<HealthObservation> observations,
  ) async {
    if (observations.length > 2000) {
      throw ArgumentError('Import batch exceeds 2000 rows.');
    }
    return _db.transaction<int>((txn) async {
      await _requireImport(txn, batchId);
      final before = Sqflite.firstIntValue(
        await txn.rawQuery('SELECT total_changes()'),
      )!;
      final batch = txn.batch();
      final memberships = txn.batch();
      for (final observation in observations) {
        final row = observation.toMap();
        validateHealthRow('observations', row);
        batch.insert(
          'observations',
          row,
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
        memberships.insert('memberships', {
          'batch_id': batchId,
          'observation_id': observation.id,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
      await batch.commit(noResult: true);
      final after = Sqflite.firstIntValue(
        await txn.rawQuery('SELECT total_changes()'),
      )!;
      await memberships.commit(noResult: true);
      return after - before;
    });
  }

  @override
  Future<void> finishImport(String batchId, {required int skippedCount}) async {
    if (skippedCount < 0) throw ArgumentError('Invalid skipped count.');
    await _db.transaction<void>((txn) async {
      await _requireImport(txn, batchId);
      final count = Sqflite.firstIntValue(
        await txn.rawQuery(
          'SELECT COUNT(*) FROM memberships WHERE batch_id = ?',
          [batchId],
        ),
      )!;
      await txn.update(
        'batches',
        {
          'status': 'ready',
          'record_count': count,
          'skipped_count': skippedCount,
        },
        where: 'id = ?',
        whereArgs: [batchId],
      );
      await _invalidateSummaries(txn);
    });
  }

  static Future<void> _removeOrphans(DatabaseExecutor db) => db.execute(
    'DELETE FROM observations WHERE NOT EXISTS '
    '(SELECT 1 FROM memberships WHERE observation_id = observations.id)',
  );

  static Future<void> _recoverInterruptedImports(Database db) =>
      db.transaction<void>((txn) async {
        await txn.delete('batches', where: 'status != ?', whereArgs: ['ready']);
        await _removeOrphans(txn);
      });

  @override
  Future<void> abortImport(String batchId) =>
      _deleteBatch(batchId, importingOnly: true);
  @override
  Future<void> deleteImport(String batchId) => _deleteBatch(batchId);
  Future<void> _deleteBatch(String id, {bool importingOnly = false}) =>
      _db.transaction<void>((txn) async {
        final ready = importingOnly
            ? <Map<String, Object?>>[]
            : await txn.query(
                'batches',
                columns: ['id'],
                where: 'id = ? AND status = ?',
                whereArgs: [id, 'ready'],
                limit: 1,
              );
        await txn.delete(
          'batches',
          where: importingOnly ? 'id = ? AND status = ?' : 'id = ?',
          whereArgs: importingOnly ? [id, 'importing'] : [id],
        );
        await _removeOrphans(txn);
        if (ready.isNotEmpty) await _invalidateSummaries(txn);
      });

  @override
  Future<List<HealthImportBatch>> listImports() async =>
      (await _db.query(
            'batches',
            where: 'status = ?',
            whereArgs: ['ready'],
            orderBy: 'created_ms DESC',
          ))
          .map(
            (row) => HealthImportBatch(
              id: row['id'] as String,
              createdAt: DateTime.fromMillisecondsSinceEpoch(
                row['created_ms'] as int,
                isUtc: true,
              ),
              status: row['status'] as String,
              recordCount: row['record_count'] as int,
              skippedCount: row['skipped_count'] as int,
            ),
          )
          .toList();

  static const _visible = '''EXISTS (SELECT 1 FROM memberships m
    JOIN batches b ON b.id = m.batch_id
    WHERE m.observation_id = o.id AND b.status = 'ready')
    AND NOT EXISTS (SELECT 1 FROM observations newer
      JOIN memberships nm ON nm.observation_id = newer.id
      JOIN batches nb ON nb.id = nm.batch_id AND nb.status = 'ready'
      WHERE newer.logical_id = o.logical_id AND
      (newer.sync_version > o.sync_version OR
        (newer.sync_version = o.sync_version AND newer.id > o.id)))''';

  static Future<void> _invalidateSummaries(DatabaseExecutor executor) async {
    await executor.execute(
      'UPDATE health_cache_state SET generation = generation + 1 WHERE id = 1',
    );
    await executor.delete('health_daily_cache');
    await executor.delete('health_source_cache');
  }

  @override
  Future<HealthSummaryWindow> queryDailySummaries({
    required DateTime from,
    required DateTime to,
    required HealthMetric metric,
    String? source,
    int? offsetMinutes,
  }) async {
    bool midnight(DateTime date) =>
        date.isUtc &&
        date.hour == 0 &&
        date.minute == 0 &&
        date.second == 0 &&
        date.millisecond == 0 &&
        date.microsecond == 0;
    if (!midnight(from) ||
        !midnight(to) ||
        !from.isBefore(to) ||
        to.difference(from).inDays > 366 ||
        (offsetMinutes != null &&
            (offsetMinutes < -720 || offsetMinutes > 840))) {
      throw ArgumentError('Invalid daily summary bounds.');
    }
    return _db.transaction<HealthSummaryWindow>((txn) async {
      final generation =
          (await txn.query(
                'health_cache_state',
                where: 'id = 1',
              )).single['generation']
              as int;
      final summaries = <HealthDailySummary>[];
      final limitedDays = <DateTime>[];
      final incompleteDays = <DateTime>[];
      var hits = 0;
      for (
        var day = from;
        day.isBefore(to);
        day = day.add(const Duration(days: 1))
      ) {
        final key = jsonEncode([
          metric.name,
          source,
          day.millisecondsSinceEpoch,
          offsetMinutes,
          healthCachePolicyVersion,
        ]);
        final rows = await txn.query(
          'health_daily_cache',
          where: 'cache_key = ? AND generation = ?',
          whereArgs: [key, generation],
          limit: 1,
        );
        CachedHealthDay? cached;
        if (rows.isNotEmpty) {
          try {
            cached = CachedHealthDay.decode(
              rows.single['payload'] as String,
              day,
              metric,
              source,
            );
            hits++;
          } catch (_) {
            await txn.delete(
              'health_daily_cache',
              where: 'cache_key = ?',
              whereArgs: [key],
            );
          }
        }
        if (cached == null) {
          final sleep = metric == HealthMetric.sleep;
          // Original record offsets may differ. Sleep needs nearby complete episodes.
          final lower = day.subtract(Duration(hours: sleep ? 62 : 24));
          final upper = day.add(Duration(hours: sleep ? 38 : 48));
          final records = <HealthObservation>[];
          var cursor = 0;
          var limited = false;
          var incomplete = false;
          while (true) {
            final args = <Object?>[
              lower.millisecondsSinceEpoch,
              upper.millisecondsSinceEpoch,
              metric.name,
            ];
            final sourceSql = source == null ? '' : ' AND o.source = ?';
            if (source != null) args.add(source);
            args.addAll([1000, cursor]);
            final page = await txn.rawQuery(
              'SELECT o.* FROM observations o WHERE $_visible AND o.end_ms >= ? '
              "AND (CASE WHEN o.metric = 'sleep' THEN o.start_ms ELSE o.end_ms END) < ? "
              'AND o.metric = ?$sourceSql ORDER BY o.end_ms, o.id LIMIT ? OFFSET ?',
              args,
            );
            for (final row in page) {
              final record = HealthObservation.fromMap(row);
              if (!sleep) {
                final local = record.end.toUtc().add(
                  Duration(minutes: offsetMinutes ?? record.offsetMinutes),
                );
                if (DateTime.utc(local.year, local.month, local.day) != day) {
                  continue;
                }
              }
              records.add(record);
              if (sleep &&
                  (!record.start.isAfter(lower) ||
                      !record.end.isBefore(upper))) {
                incomplete = true;
              }
              if (records.length > 5000) {
                limited = true;
                break;
              }
            }
            if (limited || page.length < 1000) break;
            cursor += page.length;
          }
          cached = await aggregateCachedHealthDay(
            records,
            day,
            offsetMinutes,
            limited: limited,
            incomplete: incomplete,
          );
          await txn.insert('health_daily_cache', {
            'cache_key': key,
            'generation': generation,
            'payload': cached.encode(),
          }, conflictAlgorithm: ConflictAlgorithm.replace);
        }
        summaries.addAll(cached.summaries);
        if (cached.limited) limitedDays.add(day);
        if (cached.incomplete) incompleteDays.add(day);
      }
      return HealthSummaryWindow(
        summaries: summaries,
        limitedDays: limitedDays,
        incompleteDays: incompleteDays,
        cacheHitDays: hits,
      );
    });
  }

  @override
  Future<List<String>> listSources(
    HealthMetric metric,
  ) => _db.transaction<List<String>>((txn) async {
    final generation =
        (await txn.query(
              'health_cache_state',
              where: 'id = 1',
            )).single['generation']
            as int;
    final cached = await txn.query(
      'health_source_cache',
      where: 'metric = ? AND generation = ?',
      whereArgs: [metric.name, generation],
      limit: 1,
    );
    if (cached.isNotEmpty) {
      try {
        final payload = jsonDecode(cached.single['payload'] as String);
        if (payload is! List ||
            payload.any((item) => item is! String || item.isEmpty)) {
          throw const FormatException('Invalid cached sources.');
        }
        final sources = payload.cast<String>();
        if (sources.toSet().length != sources.length) {
          throw const FormatException('Invalid cached sources.');
        }
        return sources..sort();
      } catch (_) {
        await txn.delete(
          'health_source_cache',
          where: 'metric = ?',
          whereArgs: [metric.name],
        );
      }
    }
    final sources = (await txn.rawQuery(
      'SELECT DISTINCT o.source FROM observations o WHERE $_visible AND o.metric = ? ORDER BY o.source',
      [metric.name],
    )).map((row) => row['source'] as String).toList();
    await txn.insert('health_source_cache', {
      'metric': metric.name,
      'generation': generation,
      'payload': jsonEncode(sources),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    return sources;
  });

  @override
  Future<List<HealthObservation>> queryObservations({
    required DateTime from,
    required DateTime to,
    HealthMetric? metric,
    String? source,
    int limit = 1000,
    int offset = 0,
  }) async {
    if (limit < 1 || limit > 10000 || offset < 0 || !from.isBefore(to)) {
      throw ArgumentError('Invalid Health query bounds.');
    }
    final args = <Object?>[
      from.toUtc().millisecondsSinceEpoch,
      to.toUtc().millisecondsSinceEpoch,
    ];
    var conditions =
        "(o.end_ms >= ? AND (CASE WHEN o.metric = 'sleep' THEN o.start_ms ELSE o.end_ms END) < ?)";
    if (metric != null) {
      conditions += ' AND o.metric = ?';
      args.add(metric.name);
    }
    if (source != null) {
      conditions += ' AND o.source = ?';
      args.add(source);
    }
    args.addAll([limit, offset]);
    return (await _db.rawQuery(
      'SELECT o.* FROM observations o WHERE $_visible AND $conditions '
      'ORDER BY o.end_ms, o.id LIMIT ? OFFSET ?',
      args,
    )).map(HealthObservation.fromMap).toList();
  }

  @override
  Future<List<HealthNote>> listNotes(DateTime from, DateTime to) async =>
      (await _db.query(
            'notes',
            where: 'date_ms >= ? AND date_ms < ?',
            whereArgs: [
              from.toUtc().millisecondsSinceEpoch,
              to.toUtc().millisecondsSinceEpoch,
            ],
            orderBy: 'date_ms, id',
          ))
          .map(
            (row) => HealthNote(
              id: row['id'] as String,
              date: DateTime.fromMillisecondsSinceEpoch(
                row['date_ms'] as int,
                isUtc: true,
              ),
              text: row['text'] as String,
            ),
          )
          .toList();

  @override
  Future<void> saveNote(HealthNote note) async {
    final row = <String, Object?>{
      'id': note.id,
      'date_ms': note.date.toUtc().millisecondsSinceEpoch,
      'text': note.text,
    };
    validateHealthRow('notes', row);
    await _db.insert(
      'notes',
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteNote(String id) async {
    await _db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Stream<List<Map<String, Object?>>> exportChunks({
    int chunkSize = 500,
  }) async* {
    if (chunkSize < 1 || chunkSize > 2000) {
      throw ArgumentError('Invalid export chunk size.');
    }
    // Transaction gives a consistent snapshot even if the UI edits notes concurrently.
    final controller = StreamController<List<Map<String, Object?>>>();
    Completer<void>? consumed;
    var canceled = false;
    Future<void> produce() async {
      try {
        await _db.transaction<void>((txn) async {
          for (final table in [
            'batches',
            'observations',
            'memberships',
            'notes',
          ]) {
            var lastRowId = 0;
            final visibility = switch (table) {
              'batches' => " WHERE status = 'ready'",
              'observations' =>
                " WHERE EXISTS (SELECT 1 FROM memberships m JOIN batches b ON b.id = m.batch_id WHERE m.observation_id = observations.id AND b.status = 'ready')",
              'memberships' =>
                " WHERE EXISTS (SELECT 1 FROM batches b WHERE b.id = memberships.batch_id AND b.status = 'ready')",
              _ => '',
            };
            while (!canceled) {
              final conjunction = visibility.isEmpty
                  ? ' WHERE '
                  : '$visibility AND ';
              final rows = await txn.rawQuery(
                'SELECT rowid AS cursor_id, * FROM $table${conjunction}rowid > ? ORDER BY rowid LIMIT ?',
                [lastRowId, chunkSize],
              );
              if (rows.isEmpty) break;
              lastRowId = rows.last['cursor_id'] as int;
              consumed = Completer<void>();
              controller.add(
                rows
                    .map(
                      (row) =>
                          <String, Object?>{'table': table, ...row}
                            ..remove('cursor_id'),
                    )
                    .toList(),
              );
              await consumed!.future;
            }
            if (canceled) break;
          }
        });
        controller.close();
      } catch (_) {
        controller.addError(StateError('Private backup could not be read.'));
        controller.close();
      }
    }

    unawaited(produce());
    try {
      await for (final chunk in controller.stream) {
        yield chunk;
        consumed?.complete();
      }
    } finally {
      canceled = true;
      if (consumed != null && !consumed!.isCompleted) consumed!.complete();
    }
  }

  @override
  Future<void> restoreChunks(Stream<List<Map<String, Object?>>> chunks) async {
    await _db.transaction<void>((txn) async {
      await txn.delete('memberships');
      await txn.delete('observations');
      await txn.delete('batches');
      await txn.delete('notes');
      await for (final chunk in chunks) {
        if (chunk.length > 2000) {
          throw const FormatException('Invalid backup chunk.');
        }
        final batch = txn.batch();
        for (final envelope in chunk) {
          final table = envelope['table'];
          if (table is! String) {
            throw const FormatException('Invalid backup row.');
          }
          final row = Map<String, Object?>.of(envelope)..remove('table');
          validateHealthRow(table, row);
          batch.insert(table, row);
        }
        await batch.commit(noResult: true);
      }
      final mismatch = await txn.rawQuery(
        '''SELECT 1 FROM batches b WHERE
        b.record_count != (SELECT COUNT(*) FROM memberships m WHERE m.batch_id = b.id) LIMIT 1''',
      );
      final orphan = await txn.rawQuery(
        '''SELECT 1 FROM observations o WHERE NOT EXISTS
        (SELECT 1 FROM memberships m WHERE m.observation_id = o.id) LIMIT 1''',
      );
      if (mismatch.isNotEmpty || orphan.isNotEmpty) {
        throw const FormatException('Invalid backup lineage.');
      }
      await _invalidateSummaries(txn);
    });
  }
}

const healthSchema = <String>[
  "CREATE TABLE batches (id TEXT PRIMARY KEY, created_ms INTEGER NOT NULL, status TEXT NOT NULL CHECK(status IN ('importing','ready')), record_count INTEGER NOT NULL CHECK(record_count >= 0), skipped_count INTEGER NOT NULL CHECK(skipped_count >= 0))",
  'CREATE TABLE observations (id TEXT PRIMARY KEY, logical_id TEXT NOT NULL, metric TEXT NOT NULL, source TEXT NOT NULL, raw_value TEXT NOT NULL, original_unit TEXT NOT NULL, canonical_unit TEXT NOT NULL, value REAL, category TEXT, start_ms INTEGER NOT NULL, end_ms INTEGER NOT NULL CHECK(end_ms >= start_ms), offset_minutes INTEGER NOT NULL, time_zone TEXT, sync_version INTEGER NOT NULL CHECK(sync_version >= 0))',
  'CREATE TABLE memberships (batch_id TEXT NOT NULL REFERENCES batches(id) ON DELETE CASCADE, observation_id TEXT NOT NULL REFERENCES observations(id), PRIMARY KEY(batch_id, observation_id))',
  'CREATE INDEX observations_time ON observations(metric, end_ms, source)',
  'CREATE INDEX observations_revision ON observations(logical_id, sync_version, id)',
  'CREATE INDEX memberships_observation ON memberships(observation_id)',
  'CREATE TABLE notes (id TEXT PRIMARY KEY, date_ms INTEGER NOT NULL, text TEXT NOT NULL)',
  'CREATE INDEX notes_date ON notes(date_ms)',
];

/// Strict envelope validation before restored data crosses the live-vault boundary.
void validateHealthRow(String table, Map<String, Object?> row) {
  final required = switch (table) {
    'batches' => {
      'id',
      'created_ms',
      'status',
      'record_count',
      'skipped_count',
    },
    'observations' => {
      'id',
      'logical_id',
      'metric',
      'source',
      'raw_value',
      'original_unit',
      'canonical_unit',
      'value',
      'category',
      'start_ms',
      'end_ms',
      'offset_minutes',
      'time_zone',
      'sync_version',
    },
    'memberships' => {'batch_id', 'observation_id'},
    'notes' => {'id', 'date_ms', 'text'},
    _ => throw const FormatException('Unknown backup table.'),
  };
  if (row.length != required.length || !required.every(row.containsKey)) {
    throw const FormatException('Invalid backup fields.');
  }
  for (final entry in row.entries) {
    final nullable = {'value', 'category', 'time_zone'}.contains(entry.key);
    if (entry.value == null && !nullable) {
      throw const FormatException('Missing backup field.');
    }
    if (entry.value is String && (entry.value as String).length > 20000) {
      throw const FormatException('Oversized backup field.');
    }
  }
  if (table == 'observations') {
    final observation = HealthObservation.fromMap(row);
    if (observation.id.isEmpty ||
        observation.logicalId.isEmpty ||
        observation.source.isEmpty ||
        observation.end.isBefore(observation.start) ||
        observation.syncVersion < 0 ||
        observation.offsetMinutes.abs() > 1440 ||
        (observation.value != null && !observation.value!.isFinite)) {
      throw const FormatException('Invalid observation.');
    }
  } else if (table == 'batches') {
    if (row['id'] is! String ||
        (row['id'] as String).isEmpty ||
        row['created_ms'] is! int ||
        row['status'] != 'ready' ||
        row['record_count'] is! int ||
        (row['record_count'] as int) < 0 ||
        row['skipped_count'] is! int ||
        (row['skipped_count'] as int) < 0) {
      throw const FormatException('Invalid import.');
    }
  } else if (table == 'notes') {
    if (row['id'] is! String ||
        (row['id'] as String).isEmpty ||
        row['date_ms'] is! int ||
        row['text'] is! String) {
      throw const FormatException('Invalid note.');
    }
  } else {
    if (row.values.any((value) => value is! String || value.isEmpty)) {
      throw const FormatException('Invalid membership.');
    }
  }
}
