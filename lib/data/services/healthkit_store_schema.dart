import 'dart:convert';

import 'package:sqflite_sqlcipher/sqflite.dart';

import '../models/health_observation.dart';

const healthKitSchema = <String>[
  'CREATE TABLE healthkit_cursors (metric TEXT PRIMARY KEY, anchor TEXT NOT NULL, batch_id TEXT NOT NULL REFERENCES batches(id) ON DELETE CASCADE, updated_ms INTEGER NOT NULL)',
];

String healthKitBatchId(HealthMetric metric) => 'healthkit_live:${metric.name}';

void validateHealthKitAnchor(String anchor) {
  if (anchor.isEmpty ||
      anchor.length > 65536 ||
      !RegExp(r'^[A-Za-z0-9+/]+={0,2}$').hasMatch(anchor)) {
    throw const FormatException('Invalid HealthKit anchor.');
  }
  try {
    if (base64Encode(base64Decode(anchor)) != anchor) {
      throw const FormatException('Invalid HealthKit anchor.');
    }
  } on FormatException {
    throw const FormatException('Invalid HealthKit anchor.');
  }
}

void validateHealthKitId(String id, HealthMetric metric) {
  final prefix = 'hk:${metric.name}:';
  if (!id.startsWith(prefix) ||
      !RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      ).hasMatch(id.substring(prefix.length))) {
    throw const FormatException('Invalid HealthKit sample ID.');
  }
}

void validateHealthKitObservation(
  HealthObservation sample,
  HealthMetric metric,
) {
  validateHealthKitId(sample.id, metric);
  if (sample.logicalId != sample.id ||
      sample.metric != metric ||
      !sample.source.startsWith('HealthKit · ') ||
      sample.source.substring('HealthKit · '.length).trim().isEmpty) {
    throw const FormatException('Invalid HealthKit sample.');
  }
}

void validateHealthKitCursor(Map<String, Object?> row) {
  const fields = {'metric', 'anchor', 'batch_id', 'updated_ms'};
  if (row.length != fields.length ||
      !fields.every(row.containsKey) ||
      row['metric'] is! String ||
      row['anchor'] is! String ||
      row['updated_ms'] is! int ||
      (row['updated_ms'] as int) < 0 ||
      !HealthMetric.values.any((metric) => metric.name == row['metric'])) {
    throw const FormatException('Invalid HealthKit cursor.');
  }
  final metric = HealthMetric.values.byName(row['metric'] as String);
  if (row['batch_id'] != healthKitBatchId(metric)) {
    throw const FormatException('Invalid HealthKit cursor lineage.');
  }
  validateHealthKitAnchor(row['anchor'] as String);
}

Future<void> validateHealthKitLineage(DatabaseExecutor db) async {
  var cursor = 0;
  while (true) {
    final rows = await db.rawQuery(
      'SELECT o.*, m.batch_id, m.rowid AS cursor_id FROM observations o '
      'JOIN memberships m ON m.observation_id = o.id '
      "WHERE m.rowid > ? AND (o.id LIKE 'hk:%' OR m.batch_id GLOB 'healthkit_live:*') "
      'ORDER BY m.rowid LIMIT 1000',
      [cursor],
    );
    for (final row in rows) {
      final sample = HealthObservation.fromMap(row);
      validateHealthKitObservation(sample, sample.metric);
      if (row['batch_id'] != healthKitBatchId(sample.metric)) {
        throw const FormatException('Invalid HealthKit sample lineage.');
      }
    }
    if (rows.length < 1000) break;
    cursor = rows.last['cursor_id'] as int;
  }
}
