import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:inbodysimpletracker/data/models/health_observation.dart';
import 'package:inbodysimpletracker/data/models/health_summary_window.dart';
import 'package:inbodysimpletracker/data/services/health_store_mobile.dart';

/// Run on an iOS/Android simulator/device with synthetic data only:
/// `flutter test integration_test/health_vault_native_test.dart -d <device>`
/// This never opens the production health.sqlite or reads a personal export.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('real SQLCipher vault: encryption, staged import, undo and restore', (
    tester,
  ) async {
    expect(Platform.isIOS || Platform.isAndroid, isTrue);
    final support = await getApplicationSupportDirectory();
    final root = Directory('${support.path}/private_health_data');
    await root.create(recursive: true);
    const privacy = MethodChannel('inbodysimpletracker/private_health');
    final cache = await getTemporaryDirectory();
    final syntheticSource = File('${cache.path}/synthetic-protection-test.xml');
    await syntheticSource.writeAsString('<HealthData></HealthData>');
    try {
      expect(
        await privacy.invokeMethod<bool>('protectImportFile', {
          'path': syntheticSource.path,
        }),
        isTrue,
      );
    } finally {
      await syntheticSource.delete();
    }
    expect(
      await privacy.invokeMethod<bool>('protectDirectory', {'path': root.path}),
      isTrue,
    );
    final directory = await Directory(
      '${root.path}/synthetic-native-test',
    ).create();
    final path = '${directory.path}/synthetic.sqlite';
    const key = 'SyntheticNativeOnly-Key-NotUsedByProduction-2025';
    const marker = 'SYNTHETIC_PRIVATE_HEALTH_MARKER_701621';
    Database? db;
    try {
      db = await openDatabase(
        path,
        password: key,
        version: 1,
        singleInstance: false,
        onConfigure: (db) async {
          expect(await db.rawQuery('PRAGMA cipher_version'), isNotEmpty);
          await db.execute('PRAGMA foreign_keys = ON');
          await db.rawQuery('PRAGMA journal_mode = WAL');
        },
        onCreate: (db, version) async {
          for (final statement in healthSchema) {
            await db.execute(statement);
          }
        },
      );
      var repository = await EncryptedHealthRepository.initializeForTesting(db);
      HealthObservation observation(String id, int version) =>
          HealthObservation(
            id: id,
            logicalId: 'same-logical-observation',
            metric: HealthMetric.weight,
            source: marker,
            rawValue: '75',
            originalUnit: 'kg',
            canonicalUnit: 'kg',
            value: 75,
            start: DateTime.utc(2025, 1, 1),
            end: DateTime.utc(2025, 1, 1),
            offsetMinutes: 0,
            syncVersion: version,
          );
      Future<List<HealthObservation>> query() => repository.queryObservations(
        from: DateTime.utc(2024),
        to: DateTime.utc(2026),
      );

      final first = await repository.beginImport();
      expect(
        await repository.appendObservations(first, [
          observation('original', 0),
        ]),
        1,
      );
      expect(
        await query(),
        isEmpty,
        reason: 'Staged records cannot enter public queries.',
      );
      // Seed the historical v1 state without calling v2 cache invalidation.
      await db.update(
        'batches',
        {'status': 'ready', 'record_count': 1, 'skipped_count': 1},
        where: 'id = ?',
        whereArgs: [first],
      );
      expect((await query()).single.id, 'original');
      // Upgrade the populated synthetic v1 vault; canonical tables stay intact.
      await repository.close();
      db = await openDatabase(
        path,
        password: key,
        version: 2,
        singleInstance: false,
        onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
        onUpgrade: (db, oldVersion, newVersion) async {
          expect(oldVersion, 1);
          for (final statement in healthCacheSchema) {
            await db.execute(statement);
          }
        },
      );
      repository = await EncryptedHealthRepository.initializeForTesting(db);
      expect((await query()).single.id, 'original');
      Future<HealthSummaryWindow> daily() => repository.queryDailySummaries(
        from: DateTime.utc(2025),
        to: DateTime.utc(2025, 1, 2),
        metric: HealthMetric.weight,
      );
      expect((await daily()).cacheHitDays, 0);
      expect((await daily()).cacheHitDays, 1);
      expect(await repository.listSources(HealthMetric.weight), [marker]);
      expect(await repository.listSources(HealthMetric.weight), [marker]);
      expect((await db.query('health_source_cache')).length, 1);
      final repeated = await repository.beginImport();
      expect(
        await repository.appendObservations(repeated, [
          observation('original', 0),
        ]),
        0,
      );
      await repository.finishImport(repeated, skippedCount: 0);
      expect(await db.query('health_source_cache'), isEmpty);
      expect((await daily()).cacheHitDays, 0);
      await repository.deleteImport(first);
      expect((await daily()).cacheHitDays, 0);
      expect(
        (await query()).single.id,
        'original',
        reason: 'Second import retains shared rows.',
      );
      final revision = await repository.beginImport();
      await repository.appendObservations(revision, [
        observation('new-revision', 2),
      ]);
      await repository.finishImport(revision, skippedCount: 0);
      expect((await query()).single.id, 'new-revision');
      await repository.deleteImport(revision);
      expect(
        (await query()).single.id,
        'original',
        reason: 'Undo restores prior ready revision.',
      );
      final incomplete = await repository.beginImport();
      await repository.appendObservations(incomplete, [
        observation('incomplete', 3),
      ]);
      final beforeAbort = (await daily()).cacheHitDays;
      expect(beforeAbort, 0);
      final disposable = await repository.beginImport();
      await repository.abortImport(disposable);
      expect((await daily()).cacheHitDays, 1);
      expect((await query()).single.id, 'original');
      await repository.close();
      db = null;
      db = await openDatabase(
        path,
        password: key,
        singleInstance: false,
        onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      );
      repository = await EncryptedHealthRepository.initializeForTesting(db);
      expect(
        (await query()).single.id,
        'original',
        reason: 'Reopen preserves ready history.',
      );
      expect(
        await db.query(
          'observations',
          where: 'id = ?',
          whereArgs: ['incomplete'],
        ),
        isEmpty,
        reason: 'Interrupted import rows are removed on startup.',
      );

      await repository.saveNote(
        HealthNote(
          id: 'synthetic-note',
          date: DateTime.utc(2025, 1, 1),
          text: marker,
        ),
      );
      await daily();
      await repository.saveNote(
        HealthNote(
          id: 'another-note',
          date: DateTime.utc(2025),
          text: 'synthetic',
        ),
      );
      expect((await daily()).cacheHitDays, 1);
      await repository.deleteNote('another-note');
      final backup = await repository.exportChunks(chunkSize: 1).toList();
      expect(
        backup
            .expand((chunk) => chunk)
            .any((row) => row['table'] == 'health_daily_cache'),
        isFalse,
      );
      final bad = <Map<String, Object?>>[
        {'table': 'notes', 'id': 'bad', 'date_ms': 0, 'text': marker},
        {'table': 'secrets'},
      ];
      await expectLater(
        repository.restoreChunks(Stream.value(bad)),
        throwsFormatException,
      );
      expect(
        (await query()).single.id,
        'original',
        reason: 'Corruption rolls back the entire replacement.',
      );
      expect(
        (await repository.listNotes(
          DateTime.utc(2024),
          DateTime.utc(2026),
        )).single.text,
        marker,
      );
      await repository.deleteImport(repeated);
      expect(await query(), isEmpty);
      await repository.restoreChunks(Stream.fromIterable(backup));
      expect((await query()).single.id, 'original');
      expect((await daily()).cacheHitDays, 0);

      expect(
        await privacy.invokeMethod<bool>('protectDirectory', {
          'path': root.path,
        }),
        isTrue,
      );
      for (final entity in directory.listSync()) {
        if (entity is File) {
          final bytes = await entity.readAsBytes();
          expect(
            latin1.decode(bytes),
            isNot(contains(marker)),
            reason: 'No plaintext marker in database/WAL/journal.',
          );
        }
      }
      await repository.close();
      db = null;
      Database? wrong;
      try {
        wrong = await openDatabase(
          path,
          password: 'wrong-synthetic-key',
          singleInstance: false,
        );
        await expectLater(
          wrong.rawQuery('SELECT * FROM notes'),
          throwsA(isA<DatabaseException>()),
        );
      } on DatabaseException {
        // Opening may itself read the encrypted schema and reject the wrong key.
      } finally {
        await wrong?.close();
      }
      db = await openDatabase(path, password: key, singleInstance: false);
      expect(
        (await db.query('notes')).single['text'],
        marker,
        reason: 'Correct-key reopen retains synthetic history.',
      );
    } finally {
      await db?.close();
      // Only this fixed synthetic test subdirectory is removed.
      await directory.delete(recursive: true);
    }
  });
}
