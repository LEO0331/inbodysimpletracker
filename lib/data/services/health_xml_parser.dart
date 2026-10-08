import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:xml/xml_events.dart';
import '../../core/utils/health_units.dart';
import '../models/health_observation.dart';

const healthImportMaxBytes = 2 * 1024 * 1024 * 1024;

/// Emits bounded, serializable batches; callers provide persistence backpressure.
Stream<Map<String, Object>> parseHealthXml(Stream<List<int>> bytes) async* {
  var byteCount = 0;
  var pendingToken = 0;
  var inMarkup = false;
  var quote = 0;
  var brackets = 0;
  var markupPrefix = '';
  var markupTail = '';
  var scanTail = '';
  Stream<String> guarded() async* {
    await for (final text
        in bytes
            .map((chunk) {
              byteCount += chunk.length;
              if (byteCount > healthImportMaxBytes) {
                throw const FormatException();
              }
              return chunk;
            })
            .transform(utf8.decoder)) {
      final scan = scanTail + text;
      if (scan.contains('<!ENTITY') ||
          scan.contains(' SYSTEM ') ||
          scan.contains(' PUBLIC ')) {
        throw const FormatException();
      }
      scanTail = scan.substring(scan.length > 32 ? scan.length - 32 : 0);
      for (final code in text.codeUnits) {
        pendingToken++;
        if (pendingToken > 1024 * 1024) throw const FormatException();
        if (!inMarkup && code == 60) {
          inMarkup = true;
          markupPrefix = '<';
          markupTail = '<';
          quote = 0;
          brackets = 0;
        } else if (inMarkup) {
          if (markupPrefix.length < 10) {
            markupPrefix += String.fromCharCode(code);
          }
          markupTail = (markupTail + String.fromCharCode(code));
          if (markupTail.length > 3) {
            markupTail = markupTail.substring(markupTail.length - 3);
          }
          var closes = false;
          if (markupPrefix.startsWith('<!--')) {
            closes = markupTail == '-->';
          } else if (markupPrefix.startsWith('<![CDATA[')) {
            closes = markupTail == ']]>';
          } else if (markupPrefix.startsWith('<?')) {
            closes = markupTail.endsWith('?>');
          } else {
            if (quote == 0 && (code == 34 || code == 39)) {
              quote = code;
            } else if (quote == code) {
              quote = 0;
            } else if (quote == 0) {
              if (code == 91) brackets++;
              if (code == 93) brackets--;
              closes = code == 62 && brackets == 0;
            }
          }
          if (closes) {
            inMarkup = false;
            pendingToken = 0;
          }
        }
      }
      yield text;
    }
  }

  var depth = 0;
  var sawRoot = false;
  var processed = 0;
  var skipped = 0;
  var sinceBatch = 0;
  var eventsSinceBatch = 0;
  Map<String, String>? record;
  final metadata = <String, String>{};
  var rows = <Map<String, Object?>>[];
  await for (final events in guarded().toXmlEvents(
    validateNesting: true,
    validateDocument: true,
  )) {
    for (final event in events) {
      eventsSinceBatch++;
      if (event is XmlDoctypeEvent) {
        if (event.name != 'HealthData' ||
            event.externalId != null ||
            (event.internalSubset?.contains('<!ENTITY') ?? false)) {
          throw const FormatException();
        }
      } else if (event is XmlStartElementEvent) {
        if (!sawRoot) {
          if (event.name != 'HealthData') throw const FormatException();
          sawRoot = true;
        }
        if (event.attributes.length > 64 ||
            event.attributes.any((a) => a.value.length > 16384)) {
          throw const FormatException();
        }
        if (!event.isSelfClosing && ++depth > 32) throw const FormatException();
        final attributes = {for (final a in event.attributes) a.name: a.value};
        if (event.name == 'Record') {
          if (record != null) throw const FormatException();
          record = attributes;
          metadata.clear();
        } else if (event.name == 'MetadataEntry' && record != null) {
          if (metadata.length >= 64) throw const FormatException();
          metadata[attributes['key'] ?? ''] = attributes['value'] ?? '';
        }
        if (event.name == 'Record' && event.isSelfClosing) {
          final sample = _observation(record!, metadata);
          processed++;
          sinceBatch++;
          if (sample == null) {
            skipped++;
          } else {
            rows.add(sample.toMap());
          }
          record = null;
        }
      } else if (event is XmlEndElementEvent) {
        depth--;
        if (event.name == 'Record' && record != null) {
          final sample = _observation(record, metadata);
          processed++;
          sinceBatch++;
          if (sample == null) {
            skipped++;
          } else {
            rows.add(sample.toMap());
          }
          record = null;
        }
      }
      if (sinceBatch >= 500 || eventsSinceBatch >= 500) {
        yield {'rows': rows, 'processed': processed, 'skipped': skipped};
        rows = [];
        sinceBatch = 0;
        eventsSinceBatch = 0;
      }
    }
  }
  if (!sawRoot || depth != 0) throw const FormatException();
  yield {'rows': rows, 'processed': processed, 'skipped': skipped};
}

const _metrics = {
  'HKQuantityTypeIdentifierBodyMass': HealthMetric.weight,
  'HKCategoryTypeIdentifierSleepAnalysis': HealthMetric.sleep,
  'HKQuantityTypeIdentifierStepCount': HealthMetric.steps,
  'HKQuantityTypeIdentifierDistanceWalkingRunning': HealthMetric.distance,
  'HKQuantityTypeIdentifierActiveEnergyBurned': HealthMetric.activeEnergy,
  'HKQuantityTypeIdentifierBasalEnergyBurned': HealthMetric.basalEnergy,
  'HKQuantityTypeIdentifierAppleExerciseTime': HealthMetric.exerciseMinutes,
  'HKQuantityTypeIdentifierRestingHeartRate': HealthMetric.restingHeartRate,
  'HKQuantityTypeIdentifierHeartRateVariabilitySDNN': HealthMetric.hrvSdnn,
  'HKQuantityTypeIdentifierVO2Max': HealthMetric.vo2Max,
};
HealthObservation? _observation(
  Map<String, String> a,
  Map<String, String> meta,
) {
  final metric = _metrics[a['type']];
  final raw = a['value'];
  final unit = a['unit'] ?? '';
  final source = a['sourceName'];
  final start = _strictDate(a['startDate'] ?? '');
  final end = _strictDate(a['endDate'] ?? '');
  final offsetMatch = RegExp(
    r'([+-])(\d{2})(\d{2})$',
  ).firstMatch(a['endDate'] ?? '');
  if (metric == null ||
      raw == null ||
      source == null ||
      start == null ||
      end == null ||
      end.isBefore(start) ||
      offsetMatch == null) {
    return null;
  }
  final hours = int.parse(offsetMatch[2]!);
  final minutes = int.parse(offsetMatch[3]!);
  if (hours > 14 || minutes > 59 || (hours == 14 && minutes != 0)) return null;
  final offset = (hours * 60 + minutes) * (offsetMatch[1] == '-' ? -1 : 1);
  final normalized = normalizeHealthUnit(metric, unit, raw);
  final category = switch (raw) {
    'HKCategoryValueSleepAnalysisInBed' => 'inBed',
    'HKCategoryValueSleepAnalysisAwake' => 'awake',
    'HKCategoryValueSleepAnalysisAsleep' ||
    'HKCategoryValueSleepAnalysisAsleepUnspecified' => 'asleep',
    'HKCategoryValueSleepAnalysisAsleepCore' => 'core',
    'HKCategoryValueSleepAnalysisAsleepDeep' => 'deep',
    'HKCategoryValueSleepAnalysisAsleepREM' => 'rem',
    _ => 'unknown',
  };
  if (metric != HealthMetric.sleep && normalized == null) return null;
  final sortedMeta = meta.keys.toList()..sort();
  // HKDevice's description may carry its in-process memory address. That
  // address is not sample provenance and changes between otherwise identical
  // exports. Preserve the actual device description for fallback distinction.
  final device = a['device']?.replaceFirst(
    RegExp(r'<HKDevice:\s*0x[0-9a-fA-F]+(?:,\s*)?'),
    '<HKDevice: ',
  );
  final stable = jsonEncode([
    a['type'],
    source,
    device,
    _strictDate(a['creationDate'] ?? '')?.toUtc().toIso8601String() ??
        a['creationDate'],
    start.toUtc().toIso8601String(),
    end.toUtc().toIso8601String(),
    unit,
    raw,
    for (final key in sortedMeta) [key, meta[key]],
  ]);
  String hash(String text) => sha256.convert(utf8.encode(text)).toString();
  final sync = meta['HKMetadataKeySyncIdentifier'];
  final logical = sync == null
      ? hash(stable)
      : hash(jsonEncode([a['type'], source, sync]));
  return HealthObservation(
    id: hash(stable),
    logicalId: logical,
    metric: metric,
    source: source,
    rawValue: raw,
    originalUnit: unit,
    canonicalUnit: metric == HealthMetric.sleep ? 'min' : normalized!.unit,
    value: normalized?.value,
    category: metric == HealthMetric.sleep ? category : null,
    start: start.toUtc(),
    end: end.toUtc(),
    offsetMinutes: offset,
    timeZone: meta['HKTimeZone'],
    syncVersion: int.tryParse(meta['HKMetadataKeySyncVersion'] ?? '') ?? 0,
  );
}

DateTime? _strictDate(String text) {
  final match = RegExp(
    r'^(\d{4})-(\d{2})-(\d{2})[ T](\d{2}):(\d{2}):(\d{2}) ?([+-])(\d{2})(\d{2})$',
  ).firstMatch(text);
  if (match == null) return null;
  final parts = [for (var i = 1; i <= 6; i++) int.parse(match[i]!)];
  final local = DateTime.utc(
    parts[0],
    parts[1],
    parts[2],
    parts[3],
    parts[4],
    parts[5],
  );
  if (local.year != parts[0] ||
      local.month != parts[1] ||
      local.day != parts[2] ||
      local.hour != parts[3] ||
      local.minute != parts[4] ||
      local.second != parts[5]) {
    return null;
  }
  final hours = int.parse(match[8]!);
  final minutes = int.parse(match[9]!);
  if (hours > 14 || minutes > 59 || (hours == 14 && minutes != 0)) return null;
  return local.subtract(
    Duration(minutes: (hours * 60 + minutes) * (match[7] == '-' ? -1 : 1)),
  );
}
