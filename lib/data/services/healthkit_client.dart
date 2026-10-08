import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/health_observation.dart';

class HealthKitException implements Exception {
  const HealthKitException(this.message);
  final String message;
  @override
  String toString() => message;
}

class HealthKitPage {
  const HealthKitPage({
    required this.samples,
    required this.deletedIds,
    required this.anchor,
    required this.more,
  });
  final List<HealthObservation> samples;
  final List<String> deletedIds;
  final String anchor;
  final bool more;
}

abstract class HealthKitClient {
  Future<bool> isAvailable();

  /// True means the authorization request completed, not read access granted.
  Future<bool> requestAuthorization(List<HealthMetric> metrics);
  Future<HealthKitPage> readPage(HealthMetric metric, String? anchor);
  Future<void> cancel();
}

class MethodChannelHealthKitClient implements HealthKitClient {
  const MethodChannelHealthKitClient();
  static const _channel = MethodChannel('inbodysimpletracker/private_health');
  bool get _supported => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  Future<T?> _invoke<T>(String method, [Object? arguments]) async {
    if (!_supported) {
      throw const HealthKitException('HealthKit is available on iPhone only.');
    }
    try {
      return await _channel.invokeMethod<T>(method, arguments);
    } on PlatformException {
      throw const HealthKitException('Private Health refresh unavailable.');
    } on MissingPluginException {
      throw const HealthKitException('Private Health refresh unavailable.');
    }
  }

  @override
  Future<bool> isAvailable() async =>
      _supported && await _invoke<bool>('healthKitAvailable') == true;

  @override
  Future<bool> requestAuthorization(List<HealthMetric> metrics) async =>
      await _invoke<bool>('healthKitAuthorize', {
        'metrics': metrics.map((metric) => metric.name).toList(),
      }) ==
      true;

  @override
  Future<HealthKitPage> readPage(HealthMetric metric, String? anchor) async {
    try {
      final response = await _invoke<Object>('healthKitReadPage', {
        'metric': metric.name,
        'anchor': anchor,
        'limit': 500,
      });
      if (response is! Map ||
          response['samples'] is! List ||
          response['deletedIds'] is! List ||
          response['anchor'] is! String ||
          response['more'] is! bool) {
        throw const FormatException();
      }
      final rows = response['samples'] as List;
      final deleted = response['deletedIds'] as List;
      if (rows.length > 500 || deleted.length > 500) {
        throw const FormatException();
      }
      final page = HealthKitPage(
        samples: rows
            .map(
              (row) => HealthObservation.fromMap(
                Map<String, Object?>.from(row as Map),
              ),
            )
            .toList(growable: false),
        deletedIds: deleted.cast<String>().toList(growable: false),
        anchor: response['anchor'] as String,
        more: response['more'] as bool,
      );
      validateHealthKitPage(metric, page);
      return page;
    } on HealthKitException {
      rethrow;
    } catch (_) {
      throw const HealthKitException('HealthKit returned an invalid page.');
    }
  }

  @override
  Future<void> cancel() async {
    if (!_supported) return;
    try {
      await _invoke<bool>('healthKitCancel');
    } on HealthKitException {
      // Dart cancellation still prevents applying a returned page.
    }
  }
}

/// Validate injected clients too, before any cursor or sample is committed.
void validateHealthKitPage(HealthMetric metric, HealthKitPage page) {
  const invalid = HealthKitException('HealthKit returned an invalid page.');
  if (page.samples.length > 500 ||
      page.deletedIds.length > 500 ||
      page.anchor.isEmpty ||
      page.anchor.length > 65536) {
    throw invalid;
  }
  try {
    if (base64Decode(page.anchor).isEmpty) throw invalid;
  } catch (_) {
    throw invalid;
  }
  final idPattern = RegExp(
    '^hk:${metric.name}:[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\$',
  );
  final seen = <String>{};
  final units = <HealthMetric, String>{
    HealthMetric.weight: 'kg',
    HealthMetric.sleep: 'min',
    HealthMetric.steps: 'count',
    HealthMetric.distance: 'km',
    HealthMetric.activeEnergy: 'kcal',
    HealthMetric.basalEnergy: 'kcal',
    HealthMetric.exerciseMinutes: 'min',
    HealthMetric.restingHeartRate: 'count/min',
    HealthMetric.hrvSdnn: 'ms',
    HealthMetric.vo2Max: 'mL/min·kg',
  };
  for (final sample in page.samples) {
    if (!idPattern.hasMatch(sample.id) ||
        !seen.add(sample.id) ||
        sample.logicalId != sample.id ||
        sample.metric != metric ||
        !sample.source.startsWith('HealthKit · ') ||
        sample.source.length <= 'HealthKit · '.length ||
        utf8.encode(sample.source).length > 530 ||
        sample.rawValue.length > 128 ||
        sample.canonicalUnit != units[metric] ||
        sample.originalUnit != units[metric] ||
        sample.syncVersion != 0 ||
        sample.offsetMinutes.abs() > 840 ||
        (sample.timeZone?.length ?? 0) > 128 ||
        sample.end.isBefore(sample.start) ||
        sample.start.year < 1 ||
        sample.end.year > 9999) {
      throw invalid;
    }
    if (metric == HealthMetric.sleep) {
      if (sample.value != null ||
          !{
            'inBed',
            'asleep',
            'awake',
            'core',
            'deep',
            'rem',
          }.contains(sample.category)) {
        throw invalid;
      }
    } else if (sample.category != null ||
        sample.value == null ||
        !sample.value!.isFinite ||
        sample.value! < 0) {
      throw invalid;
    }
  }
  for (final id in page.deletedIds) {
    if (!idPattern.hasMatch(id) || !seen.add(id)) throw invalid;
  }
}
