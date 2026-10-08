import '../../data/models/health_observation.dart';

class HealthDailySummary {
  const HealthDailySummary({
    required this.date,
    required this.metric,
    required this.source,
    required this.value,
    required this.unit,
    required this.sampleCount,
    required this.hasConflict,
    this.stages = const {},
  });
  final DateTime date;
  final HealthMetric metric;
  final String source;
  final double? value;
  final String unit;
  final int sampleCount;
  final bool hasConflict;
  final Map<String, double> stages;
}

/// Original offsets (or the explicitly selected fixed offset) define days.
/// Interval quantities belong wholly to their end day; no prorating is invented.
List<HealthDailySummary> computeDailyHealthSummaries(
  List<HealthObservation> observations, {
  int? offsetMinutes,
}) {
  final groups = <(DateTime, HealthMetric, String), List<HealthObservation>>{};
  DateTime dayFor(HealthObservation sample) {
    final local = sample.end.toUtc().add(
      Duration(minutes: offsetMinutes ?? sample.offsetMinutes),
    );
    return DateTime.utc(local.year, local.month, local.day);
  }

  final sleepDays = <String, DateTime>{};
  final sleepersBySource = <String, List<HealthObservation>>{};
  for (final sample in observations) {
    if (sample.metric == HealthMetric.sleep &&
        const {
          'asleep',
          'core',
          'deep',
          'rem',
          'unclassified',
        }.contains(sample.category)) {
      sleepersBySource.putIfAbsent(sample.source, () => []).add(sample);
    }
  }
  // Keep contiguous/overlapping stages in the same night, even when an early
  // stage ends before midnight. Disjoint naps keep their own end-day policy.
  for (final sleepers in sleepersBySource.values) {
    sleepers.sort((a, b) => a.start.compareTo(b.start));
    var episode = <HealthObservation>[];
    HealthObservation? last;
    void finishEpisode() {
      if (last == null) return;
      final day = dayFor(last);
      for (final sample in episode) {
        sleepDays[sample.id] = day;
      }
      episode = [];
    }

    for (final sample in sleepers) {
      if (last != null && sample.start.isAfter(last.end)) {
        finishEpisode();
        last = null;
      }
      episode.add(sample);
      if (last == null || sample.end.isAfter(last.end)) last = sample;
    }
    finishEpisode();
  }
  for (final sample in observations) {
    final day = sleepDays[sample.id] ?? dayFor(sample);
    groups
        .putIfAbsent((day, sample.metric, sample.source), () => [])
        .add(sample);
  }
  final result = <HealthDailySummary>[];
  for (final entry in groups.entries) {
    final samples = entry.value..sort((a, b) => a.start.compareTo(b.start));
    final metric = entry.key.$2;
    var conflict = false;
    double? value;
    final stages = <String, double>{};
    if (metric == HealthMetric.sleep) {
      final asleep = samples
          .where(
            (s) => const {
              'asleep',
              'core',
              'deep',
              'rem',
              'unclassified',
            }.contains(s.category),
          )
          .toList();
      final points = asleep.expand((s) => [s.start, s.end]).toSet().toList()
        ..sort();
      value = 0;
      for (var i = 1; i < points.length; i++) {
        final covering = asleep
            .where(
              (s) =>
                  s.start.isBefore(points[i]) && s.end.isAfter(points[i - 1]),
            )
            .toList();
        if (covering.isEmpty) continue;
        final minutes =
            points[i].difference(points[i - 1]).inMilliseconds / 60000;
        value = value! + minutes;
        final categories = covering
            .map((s) => s.category!)
            .where((c) => c != 'asleep' && c != 'unclassified')
            .toSet();
        final stage = categories.length == 1
            ? categories.single
            : 'unclassified';
        if (categories.length > 1) conflict = true;
        stages[stage] = (stages[stage] ?? 0) + minutes;
      }
      if (asleep.isEmpty) value = null;
    } else if (const {
      HealthMetric.steps,
      HealthMetric.distance,
      HealthMetric.activeEnergy,
      HealthMetric.basalEnergy,
      HealthMetric.exerciseMinutes,
    }.contains(metric)) {
      DateTime? latestEnd;
      value = 0;
      for (final sample in samples) {
        if (latestEnd != null &&
            sample.start.isBefore(latestEnd) &&
            sample.end.isAfter(sample.start)) {
          conflict = true;
        }
        if (latestEnd == null || sample.end.isAfter(latestEnd)) {
          latestEnd = sample.end;
        }
        if (sample.value == null) conflict = true;
        value = value! + (sample.value ?? 0);
      }
      if (conflict) value = null;
    } else {
      // Latest observation is descriptive; no clinical average or recovery score.
      samples.sort((a, b) => a.end.compareTo(b.end));
      value = samples.last.value;
    }
    result.add(
      HealthDailySummary(
        date: entry.key.$1,
        metric: metric,
        source: entry.key.$3,
        value: value,
        unit: metric == HealthMetric.sleep
            ? 'min'
            : samples.first.canonicalUnit,
        sampleCount: samples.length,
        hasConflict: conflict,
        stages: Map.unmodifiable(stages),
      ),
    );
  }
  return result..sort((a, b) => a.date.compareTo(b.date));
}
