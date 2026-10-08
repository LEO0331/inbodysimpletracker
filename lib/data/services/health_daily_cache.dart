import 'dart:convert';
import 'dart:isolate';

import '../../core/utils/health_aggregation.dart';
import '../models/health_observation.dart';

const healthCachePolicyVersion = 1;
const healthCacheSchema = <String>[
  'CREATE TABLE health_cache_state (id INTEGER PRIMARY KEY CHECK(id = 1), generation INTEGER NOT NULL)',
  'INSERT INTO health_cache_state (id, generation) VALUES (1, 0)',
  'CREATE TABLE health_daily_cache (cache_key TEXT PRIMARY KEY, generation INTEGER NOT NULL, payload TEXT NOT NULL)',
  'CREATE TABLE health_source_cache (metric TEXT PRIMARY KEY, generation INTEGER NOT NULL, payload TEXT NOT NULL)',
];

class CachedHealthDay {
  const CachedHealthDay(
    this.summaries, {
    this.limited = false,
    this.incomplete = false,
  });
  final List<HealthDailySummary> summaries;
  final bool limited;
  final bool incomplete;

  String encode() => jsonEncode({
    'limited': limited,
    'incomplete': incomplete,
    'summaries': summaries
        .map(
          (s) => {
            'date': s.date.millisecondsSinceEpoch,
            'metric': s.metric.name,
            'source': s.source,
            'value': s.value,
            'unit': s.unit,
            'count': s.sampleCount,
            'conflict': s.hasConflict,
            'stages': s.stages,
          },
        )
        .toList(),
  });

  static CachedHealthDay decode(
    String payload,
    DateTime day,
    HealthMetric metric,
    String? source,
  ) {
    final map = jsonDecode(payload);
    if (map is! Map ||
        map['limited'] is! bool ||
        map['incomplete'] is! bool ||
        map['summaries'] is! List) {
      throw const FormatException('Invalid derived summary.');
    }
    final summaries = <HealthDailySummary>[];
    final canonicalUnit = switch (metric) {
      HealthMetric.weight => 'kg',
      HealthMetric.sleep || HealthMetric.exerciseMinutes => 'min',
      HealthMetric.steps => 'count',
      HealthMetric.distance => 'km',
      HealthMetric.activeEnergy || HealthMetric.basalEnergy => 'kcal',
      HealthMetric.restingHeartRate => 'count/min',
      HealthMetric.hrvSdnn => 'ms',
      HealthMetric.vo2Max => 'mL/min·kg',
    };
    final seenSources = <String>{};
    for (final row in map['summaries'] as List) {
      if (row is! Map ||
          row['date'] is! int ||
          row['date'] != day.millisecondsSinceEpoch ||
          row['metric'] != metric.name ||
          row['source'] is! String ||
          (row['source'] as String).isEmpty ||
          (source != null && row['source'] != source) ||
          row['unit'] is! String ||
          row['unit'] != canonicalUnit ||
          row['count'] is! int ||
          (row['count'] as int) < 1 ||
          (row['count'] as int) > 5000 ||
          row['conflict'] is! bool ||
          row['stages'] is! Map ||
          (row['value'] != null &&
              (row['value'] is! num ||
                  !(row['value'] as num).isFinite ||
                  (row['value'] as num) < 0))) {
        throw const FormatException('Invalid derived summary.');
      }
      if (!seenSources.add(row['source'] as String)) {
        throw const FormatException('Duplicate derived source.');
      }
      final stages = <String, double>{};
      for (final entry in (row['stages'] as Map).entries) {
        if (entry.key is! String ||
            !const {
              'core',
              'deep',
              'rem',
              'unclassified',
            }.contains(entry.key) ||
            entry.value is! num ||
            !(entry.value as num).isFinite ||
            entry.value < 0) {
          throw const FormatException('Invalid derived stages.');
        }
        stages[entry.key as String] = (entry.value as num).toDouble();
      }
      if (metric != HealthMetric.sleep && stages.isNotEmpty) {
        throw const FormatException('Invalid derived stages.');
      }
      summaries.add(
        HealthDailySummary(
          date: day,
          metric: metric,
          source: row['source'] as String,
          value: (row['value'] as num?)?.toDouble(),
          unit: row['unit'] as String,
          sampleCount: row['count'] as int,
          hasConflict: row['conflict'] as bool,
          stages: stages,
        ),
      );
    }
    if ((map['limited'] == true || map['incomplete'] == true) &&
        summaries.isNotEmpty) {
      throw const FormatException('Unsafe derived summary.');
    }
    return CachedHealthDay(
      summaries,
      limited: map['limited'] as bool,
      incomplete: map['incomplete'] as bool,
    );
  }
}

Future<CachedHealthDay> aggregateCachedHealthDay(
  List<HealthObservation> records,
  DateTime day,
  int? offsetMinutes, {
  required bool limited,
  required bool incomplete,
}) async {
  if (limited || incomplete) {
    return CachedHealthDay(const [], limited: limited, incomplete: incomplete);
  }
  return Isolate.run(
    () => CachedHealthDay(
      computeDailyHealthSummaries(
        records,
        offsetMinutes: offsetMinutes,
      ).where((summary) => summary.date == day).toList(),
    ),
  );
}
