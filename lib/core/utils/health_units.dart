import '../../data/models/health_observation.dart';

/// Only explicitly recognised Apple Health units are converted.
({double value, String unit})? normalizeHealthUnit(
  HealthMetric metric,
  String unit,
  String raw,
) {
  final value = double.tryParse(raw);
  if (value == null || !value.isFinite || value < 0) return null;
  final factor = switch (metric) {
    HealthMetric.weight => switch (unit) {
      'kg' => 1.0,
      'g' => .001,
      'lb' => .45359237,
      _ => null,
    },
    HealthMetric.distance => switch (unit) {
      'km' => 1.0,
      'm' => .001,
      'mi' => 1.609344,
      _ => null,
    },
    HealthMetric.activeEnergy || HealthMetric.basalEnergy => switch (unit) {
      'kcal' || 'Cal' => 1.0,
      'kJ' => 1 / 4.184,
      _ => null,
    },
    HealthMetric.steps => unit == 'count' ? 1.0 : null,
    HealthMetric.exerciseMinutes => unit == 'min' ? 1.0 : null,
    HealthMetric.restingHeartRate => unit == 'count/min' ? 1.0 : null,
    HealthMetric.hrvSdnn =>
      unit == 'ms'
          ? 1.0
          : unit == 's'
          ? 1000.0
          : null,
    HealthMetric.vo2Max =>
      unit == 'mL/min·kg' || unit == 'ml/kg*min' ? 1.0 : null,
    HealthMetric.sleep => null,
  };
  if (factor == null) return null;
  final normalized = value * factor;
  if (!normalized.isFinite) return null;
  return (
    value: normalized,
    unit: switch (metric) {
      HealthMetric.weight => 'kg',
      HealthMetric.distance => 'km',
      HealthMetric.activeEnergy || HealthMetric.basalEnergy => 'kcal',
      HealthMetric.steps => 'count',
      HealthMetric.exerciseMinutes => 'min',
      HealthMetric.restingHeartRate => 'count/min',
      HealthMetric.hrvSdnn => 'ms',
      HealthMetric.vo2Max => 'mL/min·kg',
      HealthMetric.sleep => 'min',
    },
  );
}
