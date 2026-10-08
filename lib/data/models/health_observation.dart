enum HealthMetric {
  weight,
  sleep,
  steps,
  distance,
  activeEnergy,
  basalEnergy,
  exerciseMinutes,
  restingHeartRate,
  hrvSdnn,
  vo2Max,
}

class HealthObservation {
  const HealthObservation({
    required this.id,
    required this.logicalId,
    required this.metric,
    required this.source,
    required this.rawValue,
    required this.originalUnit,
    required this.canonicalUnit,
    required this.start,
    required this.end,
    required this.offsetMinutes,
    this.value,
    this.category,
    this.timeZone,
    this.syncVersion = 0,
  });
  final String id;
  final String logicalId;
  final HealthMetric metric;
  final String source;
  final String rawValue;
  final String originalUnit;
  final String canonicalUnit;
  final double? value;
  final String? category;
  final DateTime start;
  final DateTime end;
  final int offsetMinutes;
  final String? timeZone;
  final int syncVersion;

  Map<String, Object?> toMap() => {
    'id': id,
    'logical_id': logicalId,
    'metric': metric.name,
    'source': source,
    'raw_value': rawValue,
    'original_unit': originalUnit,
    'canonical_unit': canonicalUnit,
    'value': value,
    'category': category,
    'start_ms': start.toUtc().millisecondsSinceEpoch,
    'end_ms': end.toUtc().millisecondsSinceEpoch,
    'offset_minutes': offsetMinutes,
    'time_zone': timeZone,
    'sync_version': syncVersion,
  };
  factory HealthObservation.fromMap(Map<String, Object?> map) =>
      HealthObservation(
        id: map['id'] as String,
        logicalId: map['logical_id'] as String,
        metric: HealthMetric.values.byName(map['metric'] as String),
        source: map['source'] as String,
        rawValue: map['raw_value'] as String,
        originalUnit: map['original_unit'] as String,
        canonicalUnit: map['canonical_unit'] as String,
        value: (map['value'] as num?)?.toDouble(),
        category: map['category'] as String?,
        start: DateTime.fromMillisecondsSinceEpoch(
          map['start_ms'] as int,
          isUtc: true,
        ),
        end: DateTime.fromMillisecondsSinceEpoch(
          map['end_ms'] as int,
          isUtc: true,
        ),
        offsetMinutes: map['offset_minutes'] as int,
        timeZone: map['time_zone'] as String?,
        syncVersion: map['sync_version'] as int? ?? 0,
      );
}

class HealthImportBatch {
  const HealthImportBatch({
    required this.id,
    required this.createdAt,
    required this.status,
    required this.recordCount,
    required this.skippedCount,
  });
  final String id;
  final DateTime createdAt;
  final String status;
  final int recordCount;
  final int skippedCount;
}

class HealthNote {
  const HealthNote({required this.id, required this.date, required this.text});
  final String id;
  final DateTime date;
  final String text;
}
