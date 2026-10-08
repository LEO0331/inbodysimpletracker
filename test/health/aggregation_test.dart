import 'package:flutter_test/flutter_test.dart';
import 'package:inbodysimpletracker/core/utils/health_aggregation.dart';
import 'package:inbodysimpletracker/data/models/health_observation.dart';

HealthObservation _sample(
  String id,
  DateTime start,
  DateTime end, {
  HealthMetric metric = HealthMetric.sleep,
  String source = 'Synthetic',
  String? category,
  double? value,
  int offset = 0,
}) => HealthObservation(
  id: id,
  logicalId: id,
  metric: metric,
  source: source,
  rawValue: 'synthetic',
  originalUnit: 'min',
  canonicalUnit: 'min',
  start: start,
  end: end,
  offsetMinutes: offset,
  category: category,
  value: value,
);
void main() {
  test('contiguous stages crossing midnight belong to the episode end day', () {
    final before = DateTime.utc(2025, 1, 1, 22);
    final summary = computeDailyHealthSummaries([
      _sample(
        'deep',
        before,
        before.add(const Duration(hours: 1)),
        category: 'deep',
      ),
      _sample(
        'core',
        before.add(const Duration(hours: 1)),
        before.add(const Duration(hours: 6)),
        category: 'core',
      ),
    ]).single;
    expect(summary.date, DateTime.utc(2025, 1, 2));
    expect(summary.value, 360);
    expect(summary.stages, {'deep': 60, 'core': 300});
  });
  test(
    'sleep stage conflicts become unclassified, in-bed never inflates duration',
    () {
      final start = DateTime.utc(2025, 1, 2);
      final summary = computeDailyHealthSummaries([
        _sample(
          'bed',
          start,
          start.add(const Duration(hours: 9)),
          category: 'inBed',
        ),
        _sample(
          'generic',
          start,
          start.add(const Duration(hours: 8)),
          category: 'asleep',
        ),
        _sample(
          'core',
          start,
          start.add(const Duration(hours: 4)),
          category: 'core',
        ),
        _sample(
          'deep',
          start.add(const Duration(hours: 3)),
          start.add(const Duration(hours: 5)),
          category: 'deep',
        ),
        _sample(
          'nap',
          start.add(const Duration(hours: 12)),
          start.add(const Duration(hours: 13)),
          category: 'asleep',
        ),
      ]).single;
      expect(summary.value, 540);
      expect(summary.hasConflict, true);
      expect(summary.stages, {'core': 180, 'deep': 60, 'unclassified': 300});
      expect(summary.stages.values.reduce((a, b) => a + b), summary.value);
    },
  );
  test('end-day attribution, fixed offset and source isolation', () {
    final start = DateTime.utc(2025, 1, 1, 20);
    final rows = [
      _sample(
        'a',
        start,
        start.add(const Duration(hours: 2)),
        metric: HealthMetric.steps,
        value: 50,
        offset: 480,
      ),
      _sample(
        'b',
        start,
        start.add(const Duration(hours: 2)),
        metric: HealthMetric.steps,
        value: 70,
        source: 'Other',
        offset: 480,
      ),
    ];
    final summaries = computeDailyHealthSummaries(rows);
    expect(summaries.length, 2);
    expect(summaries.first.date, DateTime.utc(2025, 1, 2));
    expect(summaries.map((s) => s.value), [50, 70]);
    expect(
      computeDailyHealthSummaries(rows, offsetMinutes: 0).first.date,
      DateTime.utc(2025, 1, 1),
    );
  });
  test('same-source activity overlap withholds total', () {
    final start = DateTime.utc(2025, 1, 1);
    final summary = computeDailyHealthSummaries([
      _sample(
        'a',
        start,
        start.add(const Duration(hours: 2)),
        metric: HealthMetric.steps,
        value: 20,
      ),
      _sample(
        'b',
        start.add(const Duration(hours: 1)),
        start.add(const Duration(hours: 3)),
        metric: HealthMetric.steps,
        value: 30,
      ),
    ]).single;
    expect(summary.hasConflict, true);
    expect(summary.value, isNull);
  });
  test(
    'UTC duration handles daylight offset changes without inventing sleep',
    () {
      final sample = _sample(
        'dst',
        DateTime.parse('2025-03-09T01:00:00-05:00'),
        DateTime.parse('2025-03-09T04:00:00-04:00'),
        category: 'core',
        offset: -240,
      );
      final summary = computeDailyHealthSummaries([sample]).single;
      expect(summary.value, 120);
      expect(summary.date, DateTime.utc(2025, 3, 9));
    },
  );
  test('latest measurement and explicit missing category', () {
    final date = DateTime.utc(2025, 1, 1);
    expect(
      computeDailyHealthSummaries([
        _sample('a', date, date, metric: HealthMetric.weight, value: 60),
        _sample(
          'b',
          date.add(const Duration(hours: 1)),
          date.add(const Duration(hours: 1)),
          metric: HealthMetric.weight,
          value: 61,
        ),
      ]).single.value,
      61,
    );
    expect(
      computeDailyHealthSummaries([
        _sample(
          'unknown',
          date,
          date.add(const Duration(hours: 1)),
          category: 'unknown',
        ),
      ]).single.value,
      isNull,
    );
  });
}
