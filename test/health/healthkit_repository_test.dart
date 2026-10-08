import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:inbodysimpletracker/data/models/health_observation.dart';
import 'package:inbodysimpletracker/data/services/health_store_mobile.dart';
import 'package:inbodysimpletracker/data/services/healthkit_store_schema.dart';

class MockDatabase extends Mock implements Database {}

class MockTransaction extends Mock implements Transaction {}

const id = 'hk:weight:00000000-0000-0000-0000-000000000001';
HealthObservation sample({
  String sampleId = id,
  HealthMetric metric = HealthMetric.weight,
}) => HealthObservation(
  id: sampleId,
  logicalId: sampleId,
  metric: metric,
  source: 'HealthKit · Synthetic watch',
  rawValue: '75',
  originalUnit: 'kg',
  canonicalUnit: 'kg',
  value: 75,
  start: DateTime.utc(2025),
  end: DateTime.utc(2025),
  offsetMinutes: 0,
);

void main() {
  late MockDatabase db;
  late MockTransaction txn;
  late EncryptedHealthRepository repository;
  String? anchor;
  setUp(() {
    db = MockDatabase();
    txn = MockTransaction();
    repository = EncryptedHealthRepository.forTesting(db);
    anchor = null;
    when(() => db.transaction<void>(any())).thenAnswer((call) async {
      await (call.positionalArguments.single
          as Future<void> Function(Transaction))(txn);
    });
    when(
      () => txn.query(
        'healthkit_cursors',
        columns: ['anchor'],
        where: 'metric = ?',
        whereArgs: any(named: 'whereArgs'),
        limit: 1,
      ),
    ).thenAnswer(
      (_) async => anchor == null
          ? []
          : [
              {'anchor': anchor},
            ],
    );
    when(
      () =>
          txn.insert(any(), any(), conflictAlgorithm: ConflictAlgorithm.ignore),
    ).thenAnswer((_) async => 1);
    when(
      () => txn.insert(
        'healthkit_cursors',
        any(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      ),
    ).thenAnswer((call) async {
      anchor = (call.positionalArguments[1] as Map)['anchor'] as String;
      return 1;
    });
    when(
      () => txn.update(
        'observations',
        any(),
        where: 'id = ?',
        whereArgs: any(named: 'whereArgs'),
      ),
    ).thenAnswer((_) async => 1);
    when(() => txn.execute(any(), any())).thenAnswer((_) async {});
    when(() => txn.execute(any())).thenAnswer((_) async {});
    when(() => txn.delete(any())).thenAnswer((_) async => 1);
    when(
      () => txn.delete(
        any(),
        where: any(named: 'where'),
        whereArgs: any(named: 'whereArgs'),
      ),
    ).thenAnswer((_) async => 1);
  });
  Future<void> apply({
    String? expected,
    String next = 'AQ==',
    List<HealthObservation> samples = const [],
    List<String> deleted = const [],
    bool hasMore = false,
  }) => repository.applyHealthKitPage(
    metric: HealthMetric.weight,
    expectedAnchor: expected,
    nextAnchor: next,
    samples: samples,
    deletedIds: deleted,
    hasMore: hasMore,
  );

  test(
    'updates preserve memberships and invalidate both caches before commit',
    () async {
      await apply(samples: [sample()]);
      expect(anchor, 'AQ==');
      verify(
        () => txn.update(
          'observations',
          sample().toMap(),
          where: 'id = ?',
          whereArgs: [id],
        ),
      ).called(1);
      verifyNever(
        () => txn.insert(
          'observations',
          any(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        ),
      );
      verify(() => txn.delete('health_daily_cache')).called(1);
      verify(() => txn.delete('health_source_cache')).called(1);
    },
  );

  test('stale refresh cannot delete samples or overwrite cursor', () async {
    anchor = 'AQ==';
    await expectLater(apply(deleted: [id], next: 'Ag=='), throwsStateError);
    expect(anchor, 'AQ==');
    verifyNever(
      () =>
          txn.insert(any(), any(), conflictAlgorithm: ConflictAlgorithm.ignore),
    );
    verifyNever(
      () => txn.delete(
        any(),
        where: any(named: 'where'),
        whereArgs: any(named: 'whereArgs'),
      ),
    );
  });

  test('database failure prevents cursor advancement', () async {
    when(
      () => txn.update(
        'observations',
        any(),
        where: 'id = ?',
        whereArgs: any(named: 'whereArgs'),
      ),
    ).thenThrow(StateError('synthetic write failure'));
    await expectLater(apply(samples: [sample()]), throwsStateError);
    expect(anchor, isNull);
    verifyNever(
      () => txn.insert(
        'healthkit_cursors',
        any(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      ),
    );
  });

  test(
    'cross metric, XML IDs and oversized pages fail before a transaction',
    () async {
      for (final deleted in [
        'xml-observation',
        'hk:steps:00000000-0000-0000-0000-000000000001',
      ]) {
        await expectLater(apply(deleted: [deleted]), throwsFormatException);
      }
      await expectLater(
        apply(samples: [sample(metric: HealthMetric.steps)]),
        throwsFormatException,
      );
      await expectLater(
        apply(samples: List.filled(1001, sample())),
        throwsFormatException,
      );
      verifyNever(() => db.transaction<void>(any()));
    },
  );

  test(
    'deletions are scoped to live batch and refresh invalidates caches',
    () async {
      await apply(deleted: [id]);
      verify(
        () => txn.delete(
          'memberships',
          where: 'batch_id = ? AND observation_id = ?',
          whereArgs: ['healthkit_live:weight', id],
        ),
      ).called(1);
      verify(
        () => txn.execute(
          'DELETE FROM observations WHERE id = ? AND NOT EXISTS '
          '(SELECT 1 FROM memberships WHERE observation_id = observations.id)',
          [id],
        ),
      ).called(1);
      verify(() => txn.delete('health_daily_cache')).called(1);
    },
  );

  test(
    'empty final page advances anchor and invalidates visibility caches',
    () async {
      anchor = 'AQ==';
      await apply(expected: 'AQ==', next: 'Ag==');
      expect(anchor, 'Ag==');
      verify(() => txn.delete('health_daily_cache')).called(1);
    },
  );

  test('more pages stage batch while final empty page publishes it', () async {
    await apply(samples: [sample()], hasMore: true);
    verify(
      () => txn.execute(
        'UPDATE batches SET status = ?, record_count = '
        '(SELECT COUNT(*) FROM memberships WHERE batch_id = ?) WHERE id = ?',
        ['importing', 'healthkit_live:weight', 'healthkit_live:weight'],
      ),
    ).called(1);
    await apply(expected: 'AQ==');
    verify(
      () => txn.execute(
        'UPDATE batches SET status = ?, record_count = '
        '(SELECT COUNT(*) FROM memberships WHERE batch_id = ?) WHERE id = ?',
        ['ready', 'healthkit_live:weight', 'healthkit_live:weight'],
      ),
    ).called(1);
  });

  test(
    'fresh store query replaces only live metric history and invalidates cache',
    () async {
      await apply();
      verify(
        () => txn.delete(
          'batches',
          where: 'id = ?',
          whereArgs: ['healthkit_live:weight'],
        ),
      ).called(1);
      verify(() => txn.delete('health_daily_cache')).called(1);
      expect(anchor, 'AQ==');
    },
  );

  test(
    'remove HealthKit deletes fixed live batches, never arbitrary XML imports',
    () async {
      await repository.deleteHealthKitData();
      final calls = verify(
        () => txn.delete(
          'batches',
          where: 'id = ?',
          whereArgs: captureAny(named: 'whereArgs'),
        ),
      ).captured;
      expect(
        calls,
        HealthMetric.values
            .map((metric) => [healthKitBatchId(metric)])
            .toList(),
      );
    },
  );

  test(
    'cursor backup validation rejects unknown fields and foreign lineage',
    () {
      final row = <String, Object?>{
        'metric': 'weight',
        'anchor': 'AQ==',
        'batch_id': 'healthkit_live:weight',
        'updated_ms': 1,
      };
      validateHealthRow('healthkit_cursors', row);
      expect(
        () => validateHealthRow('healthkit_cursors', {
          ...row,
          'batch_id': 'xml-import',
        }),
        throwsFormatException,
      );
      expect(
        () => validateHealthRow('healthkit_cursors', {...row, 'anchor': ''}),
        throwsFormatException,
      );
      expect(
        () => validateHealthRow('healthkit_cursors', {...row, 'other': 1}),
        throwsFormatException,
      );
      expect(healthKitSchema.join(), contains('ON DELETE CASCADE'));
    },
  );

  test(
    'restore lineage rejects XML membership claiming a HealthKit ID',
    () async {
      when(() => txn.rawQuery(any(), any())).thenAnswer(
        (_) async => [
          {...sample().toMap(), 'batch_id': 'xml-import'},
        ],
      );
      await expectLater(validateHealthKitLineage(txn), throwsFormatException);
    },
  );
}
