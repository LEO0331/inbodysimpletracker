import 'package:flutter_test/flutter_test.dart';
import 'package:inbodysimpletracker/data/models/health_observation.dart';
import 'package:inbodysimpletracker/data/services/health_store.dart';
import 'package:inbodysimpletracker/data/services/health_store_mobile.dart'
    show validateHealthRow;

Map<String, Object?> sample() => HealthObservation(
  id: 'synthetic-observation',
  logicalId: 'synthetic-identity',
  metric: HealthMetric.weight,
  source: 'Synthetic scale',
  rawValue: '75',
  originalUnit: 'kg',
  canonicalUnit: 'kg',
  value: 75,
  start: DateTime.utc(2025, 1, 1),
  end: DateTime.utc(2025, 1, 1),
  offsetMinutes: 0,
).toMap();

void main() {
  test(
    'factory rejects desktop rather than substituting plaintext storage',
    () async {
      final repository = createHealthRepository();
      await expectLater(repository.open(), throwsUnsupportedError);
    },
  );

  test('synthetic observation preserves units, raw value, and identity', () {
    final row = sample();
    expect(() => validateHealthRow('observations', row), returnsNormally);
    final restored = HealthObservation.fromMap(row);
    expect(restored.originalUnit, 'kg');
    expect(restored.rawValue, '75');
    expect(restored.logicalId, 'synthetic-identity');
  });

  for (final field in ['id', 'logical_id', 'source']) {
    test('rejects an empty $field', () {
      expect(
        () => validateHealthRow('observations', sample()..[field] = ''),
        throwsFormatException,
      );
    });
  }
  test('rejects reversed intervals and invalid revisions', () {
    expect(
      () => validateHealthRow('observations', sample()..['end_ms'] = 0),
      throwsFormatException,
    );
    expect(
      () => validateHealthRow('observations', sample()..['sync_version'] = -1),
      throwsFormatException,
    );
  });
  test('rejects nonfinite values, unknown metrics and excessive offsets', () {
    expect(
      () => validateHealthRow('observations', sample()..['value'] = double.nan),
      throwsFormatException,
    );
    expect(
      () =>
          validateHealthRow('observations', sample()..['metric'] = 'diagnosis'),
      throwsArgumentError,
    );
    expect(
      () => validateHealthRow(
        'observations',
        sample()..['offset_minutes'] = 2000,
      ),
      throwsFormatException,
    );
  });
  test('rejects incomplete or extra envelope fields', () {
    expect(
      () => validateHealthRow('observations', sample()..remove('category')),
      throwsFormatException,
    );
    expect(
      () => validateHealthRow('observations', sample()..['extra'] = 'private'),
      throwsFormatException,
    );
    expect(() => validateHealthRow('credentials', {}), throwsFormatException);
  });
  test('only ready imports enter portable backups', () {
    final row = <String, Object?>{
      'id': 'synthetic-batch',
      'created_ms': 0,
      'status': 'ready',
      'record_count': 0,
      'skipped_count': 1,
    };
    expect(() => validateHealthRow('batches', row), returnsNormally);
    expect(
      () => validateHealthRow('batches', row..['status'] = 'importing'),
      throwsFormatException,
    );
  });
  test('notes and membership have strict bounded shape', () {
    expect(
      () => validateHealthRow('notes', {
        'id': 'n',
        'date_ms': 0,
        'text': 'Synthetic context',
      }),
      returnsNormally,
    );
    expect(
      () => validateHealthRow('notes', {
        'id': 'n',
        'date_ms': 0,
        'text': 'x' * 20001,
      }),
      throwsFormatException,
    );
    expect(
      () => validateHealthRow('memberships', {
        'batch_id': 'b',
        'observation_id': '',
      }),
      throwsFormatException,
    );
  });
}
