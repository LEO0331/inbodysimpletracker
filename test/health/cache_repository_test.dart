import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:inbodysimpletracker/data/models/health_observation.dart';
import 'package:inbodysimpletracker/data/models/health_summary_window.dart';
import 'package:inbodysimpletracker/data/services/health_store_mobile.dart';

class MockDatabase extends Mock implements Database {}

class MockTransaction extends Mock implements Transaction {}

void main() {
  late MockDatabase db;
  late MockTransaction txn;
  late EncryptedHealthRepository repository;
  late Map<String, Map<String, Object?>> cache;
  late List<Map<String, Object?>> observations;
  late int rawReads;
  setUp(() {
    db = MockDatabase();
    txn = MockTransaction();
    repository = EncryptedHealthRepository.forTesting(db);
    cache = {};
    observations = [];
    rawReads = 0;
    when(() => txn.delete('health_source_cache')).thenAnswer((_) async => 0);
    when(() => db.transaction<HealthSummaryWindow>(any())).thenAnswer(
      (call) =>
          (call.positionalArguments.single
              as Future<HealthSummaryWindow> Function(Transaction))(txn),
    );
    when(
      () => txn.query('health_cache_state', where: any(named: 'where')),
    ).thenAnswer(
      (_) async => [
        {'generation': 0},
      ],
    );
    when(
      () => txn.query(
        'health_daily_cache',
        where: any(named: 'where'),
        whereArgs: any(named: 'whereArgs'),
        limit: 1,
      ),
    ).thenAnswer((call) async {
      final key = (call.namedArguments[#whereArgs] as List).first;
      return cache.containsKey(key) ? [cache[key]!] : [];
    });
    when(() => txn.rawQuery(any(), any())).thenAnswer((call) async {
      rawReads++;
      final args = call.positionalArguments[1] as List;
      final offset = args.last as int;
      final end = (offset + 1000).clamp(0, observations.length);
      return observations.sublist(offset.clamp(0, observations.length), end);
    });
    when(
      () => txn.insert(
        'health_daily_cache',
        any(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      ),
    ).thenAnswer((call) async {
      final row = Map<String, Object?>.of(
        call.positionalArguments[1] as Map<String, Object?>,
      );
      cache[row['cache_key'] as String] = row;
      return 1;
    });
    when(
      () => txn.delete(
        'health_daily_cache',
        where: any(named: 'where'),
        whereArgs: any(named: 'whereArgs'),
      ),
    ).thenAnswer((call) async {
      cache.remove((call.namedArguments[#whereArgs] as List).single);
      return 1;
    });
  });
  Future<HealthSummaryWindow> query({
    String? source,
    int? offset,
    HealthMetric metric = HealthMetric.weight,
  }) => repository.queryDailySummaries(
    from: DateTime.utc(2025),
    to: DateTime.utc(2025, 1, 2),
    metric: metric,
    source: source,
    offsetMinutes: offset,
  );
  Map<String, Object?> sample(
    String id,
    DateTime end, {
    HealthMetric metric = HealthMetric.weight,
  }) => HealthObservation(
    id: id,
    logicalId: id,
    metric: metric,
    source: 'Synthetic watch',
    rawValue: '75',
    originalUnit: 'kg',
    canonicalUnit: 'kg',
    value: 75,
    start: end,
    end: end,
    offsetMinutes: 0,
    syncVersion: 0,
  ).toMap();

  test('cold summary and warm result agree with zero warm raw reads', () async {
    observations = [sample('one', DateTime.utc(2025, 1, 1, 10))];
    expect((await query()).summaries.single.value, 75);
    expect(rawReads, 1);
    final warm = await query();
    expect(warm.summaries.single.sampleCount, 1);
    expect(warm.cacheHitDays, 1);
    expect(rawReads, 1);
  });
  test(
    'empty days are cached and null source/original offset have distinct keys',
    () async {
      expect((await query()).summaries, isEmpty);
      expect((await query()).cacheHitDays, 1);
      await query(source: 'null');
      await query(offset: 0);
      expect(cache.length, 3);
      expect(rawReads, 3);
    },
  );
  test('malformed derived payload is removed and recomputed', () async {
    await query();
    cache.values.single['payload'] = jsonEncode({
      'limited': false,
      'incomplete': false,
      'summaries': [
        {'value': 'bad'},
      ],
    });
    expect((await query()).cacheHitDays, 0);
    expect(rawReads, 2);
  });
  test(
    'cached unit, count and negative values cannot replace canonical results',
    () async {
      observations = [sample('one', DateTime.utc(2025, 1, 1, 10))];
      await query();
      for (final invalid in <Map<String, Object?>>[
        {'unit': 'g'},
        {'count': 5001},
        {'value': -1},
      ]) {
        final payload =
            jsonDecode(cache.values.single['payload'] as String) as Map;
        (payload['summaries'] as List).single.addAll(invalid);
        cache.values.single['payload'] = jsonEncode(payload);
        final refreshed = await query();
        expect(refreshed.cacheHitDays, 0);
        expect(refreshed.summaries.single.unit, 'kg');
        expect(refreshed.summaries.single.value, 75);
      }
    },
  );
  test('daily cap reports a cached gap instead of fabricated totals', () async {
    observations = List.generate(
      5001,
      (i) => sample('$i', DateTime.utc(2025, 1, 1, 10)),
    );
    final cold = await query();
    expect(cold.summaries, isEmpty);
    expect(cold.limitedDays, [DateTime.utc(2025)]);
    final reads = rawReads;
    expect((await query()).limitedDays, cold.limitedDays);
    expect(rawReads, reads);
  });
  test('other days do not consume the per-day cap', () async {
    observations = List.generate(
      6000,
      (i) => sample('$i', DateTime.utc(2024, 12, 31, 10)),
    )..add(sample('today', DateTime.utc(2025, 1, 1, 10)));
    final result = await query();
    expect(result.limitedDays, isEmpty);
    expect(result.summaries.single.sampleCount, 1);
  });
  test('sleep boundary gap is cached without partial sleep totals', () async {
    observations = [
      sample(
        'boundary',
        DateTime.utc(2025).subtract(const Duration(hours: 62)),
        metric: HealthMetric.sleep,
      ),
    ];
    final result = await query(metric: HealthMetric.sleep);
    expect(result.incompleteDays, [DateTime.utc(2025)]);
    expect(result.summaries, isEmpty);
    expect((await query(metric: HealthMetric.sleep)).cacheHitDays, 1);
  });
  test('invalid date/offset bounds never enter SQL', () async {
    for (final offset in [-721, 841]) {
      await expectLater(query(offset: offset), throwsArgumentError);
    }
    await expectLater(
      repository.queryDailySummaries(
        from: DateTime.utc(2025, 1, 1, 1),
        to: DateTime.utc(2025, 1, 2),
        metric: HealthMetric.weight,
      ),
      throwsArgumentError,
    );
    verifyNever(() => db.transaction<HealthSummaryWindow>(any()));
  });

  test(
    'source inventory is encrypted-derived and warm reads avoid raw scans',
    () async {
      Map<String, Object?>? sourceCache;
      when(() => db.transaction<List<String>>(any())).thenAnswer(
        (call) =>
            (call.positionalArguments.single
                as Future<List<String>> Function(Transaction))(txn),
      );
      when(
        () => txn.query(
          'health_source_cache',
          where: any(named: 'where'),
          whereArgs: any(named: 'whereArgs'),
          limit: 1,
        ),
      ).thenAnswer((_) async => sourceCache == null ? [] : [sourceCache!]);
      when(() => txn.rawQuery(any(), [HealthMetric.weight.name])).thenAnswer((
        _,
      ) async {
        rawReads++;
        return [
          {'source': 'Synthetic watch'},
        ];
      });
      when(
        () => txn.insert(
          'health_source_cache',
          any(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        ),
      ).thenAnswer((call) async {
        sourceCache = call.positionalArguments[1] as Map<String, Object?>;
        return 1;
      });
      expect(await repository.listSources(HealthMetric.weight), [
        'Synthetic watch',
      ]);
      expect(await repository.listSources(HealthMetric.weight), [
        'Synthetic watch',
      ]);
      expect(rawReads, 1);
    },
  );

  test('publishing ready data atomically invalidates derived cache', () async {
    when(() => db.transaction<void>(any())).thenAnswer(
      (call) =>
          (call.positionalArguments.single
              as Future<void> Function(Transaction))(txn),
    );
    when(
      () => txn.query(
        'batches',
        columns: ['id'],
        where: any(named: 'where'),
        whereArgs: any(named: 'whereArgs'),
        limit: 1,
      ),
    ).thenAnswer(
      (_) async => [
        {'id': 'synthetic'},
      ],
    );
    when(
      () => txn.rawQuery(
        'SELECT COUNT(*) FROM memberships WHERE batch_id = ?',
        ['synthetic'],
      ),
    ).thenAnswer(
      (_) async => [
        {'count': 1},
      ],
    );
    when(
      () => txn.update(
        'batches',
        any(),
        where: any(named: 'where'),
        whereArgs: any(named: 'whereArgs'),
      ),
    ).thenAnswer((_) async => 1);
    when(() => txn.execute(any())).thenAnswer((_) async {});
    when(() => txn.delete('health_daily_cache')).thenAnswer((_) async => 1);
    await repository.finishImport('synthetic', skippedCount: 0);
    verifyInOrder([
      () => txn.update(
        'batches',
        {'status': 'ready', 'record_count': 1, 'skipped_count': 0},
        where: 'id = ?',
        whereArgs: ['synthetic'],
      ),
      () => txn.execute(
        'UPDATE health_cache_state SET generation = generation + 1 WHERE id = 1',
      ),
      () => txn.delete('health_daily_cache'),
      () => txn.delete('health_source_cache'),
    ]);
    verifyNever(() => db.execute(any()));
  });

  test('only deleting a ready import invalidates summaries', () async {
    when(() => db.transaction<void>(any())).thenAnswer(
      (call) =>
          (call.positionalArguments.single
              as Future<void> Function(Transaction))(txn),
    );
    when(
      () => txn.query(
        'batches',
        columns: ['id'],
        where: any(named: 'where'),
        whereArgs: any(named: 'whereArgs'),
        limit: 1,
      ),
    ).thenAnswer(
      (_) async => [
        {'id': 'ready'},
      ],
    );
    when(
      () => txn.delete(
        'batches',
        where: any(named: 'where'),
        whereArgs: any(named: 'whereArgs'),
      ),
    ).thenAnswer((_) async => 1);
    when(() => txn.execute(any())).thenAnswer((_) async {});
    when(() => txn.delete('health_daily_cache')).thenAnswer((_) async => 1);
    await repository.abortImport('staged');
    verifyNever(() => txn.delete('health_daily_cache'));
    verifyNever(() => txn.delete('health_source_cache'));
    await repository.deleteImport('ready');
    verify(() => txn.delete('health_daily_cache')).called(1);
    verify(() => txn.delete('health_source_cache')).called(1);
  });
}
