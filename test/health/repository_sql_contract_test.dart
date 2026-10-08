import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:inbodysimpletracker/data/models/health_observation.dart';
import 'package:inbodysimpletracker/data/services/health_store_mobile.dart';

class MockDatabase extends Mock implements Database {}

class MockTransaction extends Mock implements Transaction {}

void main() {
  late MockDatabase database;
  late MockTransaction transaction;
  late EncryptedHealthRepository repository;
  setUp(() {
    database = MockDatabase();
    transaction = MockTransaction();
    repository = EncryptedHealthRepository.forTesting(database);
  });

  test('observation query is bounded, ready-only and revision-aware', () async {
    when(() => database.rawQuery(any(), any())).thenAnswer((_) async => []);
    await repository.queryObservations(
      from: DateTime.utc(2025),
      to: DateTime.utc(2025, 1, 8),
      metric: HealthMetric.sleep,
      source: 'Synthetic watch',
      limit: 50,
      offset: 100,
    );
    final call = verify(
      () => database.rawQuery(captureAny(), captureAny()),
    ).captured;
    final sql = call[0] as String;
    expect(sql, contains("b.status = 'ready'"));
    expect(sql, contains('newer.sync_version > o.sync_version'));
    expect(sql, contains("WHEN o.metric = 'sleep' THEN o.start_ms"));
    expect(sql, contains('o.metric = ? AND o.source = ?'));
    expect(sql, contains('LIMIT ? OFFSET ?'));
    expect((call[1] as List).skip(2), ['sleep', 'Synthetic watch', 50, 100]);
  });

  test('bad query bounds fail before issuing SQL', () async {
    for (final limit in [0, -1, 10001]) {
      await expectLater(
        repository.queryObservations(
          from: DateTime.utc(2025),
          to: DateTime.utc(2026),
          limit: limit,
        ),
        throwsArgumentError,
      );
    }
    verifyNever(() => database.rawQuery(any(), any()));
  });

  test(
    'export obeys consumer backpressure and releases transaction on cancel',
    () async {
      when(() => database.transaction<void>(any())).thenAnswer((call) async {
        await (call.positionalArguments.single
            as Future<void> Function(Transaction))(transaction);
      });
      var queries = 0;
      when(() => transaction.rawQuery(any(), any())).thenAnswer((call) async {
        queries++;
        return [
          <String, Object?>{
            'cursor_id': queries,
            'id': 'batch-$queries',
            'created_ms': 0,
            'status': 'ready',
            'record_count': 0,
            'skipped_count': 0,
          },
        ];
      });
      final iterator = StreamIterator(repository.exportChunks(chunkSize: 1));
      expect(await iterator.moveNext(), isTrue);
      expect(iterator.current.single['table'], 'batches');
      expect(iterator.current.single.containsKey('cursor_id'), isFalse);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(
        queries,
        1,
        reason: 'Producer must await consumption, not buffer all rows.',
      );
      expect(await iterator.moveNext(), isTrue);
      expect(queries, 2);
      await iterator.cancel();
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(queries, 2);
    },
  );

  test('schema enforces membership foreign keys and orphan-safe deletion', () {
    expect(
      healthSchema.join('\n'),
      contains('REFERENCES batches(id) ON DELETE CASCADE'),
    );
    expect(healthSchema.join('\n'), contains('REFERENCES observations(id)'));
    expect(
      healthSchema.join('\n'),
      contains('PRIMARY KEY(batch_id, observation_id)'),
    );
    expect(
      healthSchema.join('\n'),
      contains('observations(logical_id, sync_version, id)'),
    );
  });

  test(
    'startup recovery removes only interrupted batches before orphan cleanup',
    () async {
      when(() => database.transaction<void>(any())).thenAnswer((call) async {
        await (call.positionalArguments.single
            as Future<void> Function(Transaction))(transaction);
      });
      when(
        () => transaction.delete(
          'batches',
          where: any(named: 'where'),
          whereArgs: any(named: 'whereArgs'),
        ),
      ).thenAnswer((_) async => 1);
      when(() => transaction.execute(any())).thenAnswer((_) async {});
      await EncryptedHealthRepository.initializeForTesting(database);
      verifyInOrder([
        () => transaction.delete(
          'batches',
          where: 'status != ?',
          whereArgs: ['ready'],
        ),
        () => transaction.execute(
          'DELETE FROM observations WHERE NOT EXISTS '
          '(SELECT 1 FROM memberships WHERE observation_id = observations.id)',
        ),
      ]);
    },
  );
}
