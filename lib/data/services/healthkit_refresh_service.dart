import '../models/health_observation.dart';
import 'healthkit_client.dart';
import 'healthkit_repository.dart';

class HealthKitRefreshProgress {
  const HealthKitRefreshProgress({
    required this.metric,
    required this.pages,
    required this.samples,
    required this.deletions,
  });
  final HealthMetric metric;
  final int pages, samples, deletions;
}

class HealthKitRefreshResult {
  const HealthKitRefreshResult({
    required this.pages,
    required this.samples,
    required this.deletions,
  });
  final int pages, samples, deletions;
}

/// Foreground refresh only. Each page commits data and its cursor together;
/// interruption resumes from the last committed page on the next refresh.
class HealthKitRefreshService {
  HealthKitRefreshService(this.repository, {HealthKitClient? client})
    : client = client ?? const MethodChannelHealthKitClient();
  final HealthKitRepository repository;
  final HealthKitClient client;
  bool _running = false;
  bool _cancelled = false;

  Future<void> cancel() async {
    if (!_running) return;
    _cancelled = true;
    await client.cancel();
  }

  void _checkCancelled() {
    if (_cancelled) {
      throw const HealthKitException('HealthKit refresh cancelled.');
    }
  }

  Future<HealthKitRefreshResult> refresh(
    List<HealthMetric> metrics, {
    bool requestAuthorization = false,
    void Function(HealthKitRefreshProgress)? onProgress,
  }) async {
    final selected = List<HealthMetric>.of(metrics);
    if (_running) {
      throw const HealthKitException('HealthKit refresh is already running.');
    }
    if (selected.isEmpty ||
        selected.toSet().length != selected.length ||
        selected.length > HealthMetric.values.length) {
      throw const HealthKitException('Choose at least one health category.');
    }
    _running = true;
    _cancelled = false;
    var pages = 0, samples = 0, deletions = 0;
    try {
      if (!await client.isAvailable()) {
        throw const HealthKitException(
          'HealthKit is unavailable on this device.',
        );
      }
      _checkCancelled();
      if (requestAuthorization) {
        final completed = await client.requestAuthorization(selected);
        _checkCancelled();
        if (!completed) {
          throw const HealthKitException(
            'HealthKit access request did not complete.',
          );
        }
      }
      for (final metric in selected) {
        _checkCancelled();
        var anchor = await repository.readHealthKitAnchor(metric);
        while (true) {
          _checkCancelled();
          if (pages >= 10000) {
            throw const HealthKitException(
              'Refresh paused. Refresh again to continue.',
            );
          }
          final page = await client.readPage(metric, anchor);
          _checkCancelled();
          validateHealthKitPage(metric, page);
          if (page.anchor == anchor &&
              (page.more ||
                  page.samples.isNotEmpty ||
                  page.deletedIds.isNotEmpty)) {
            throw const HealthKitException(
              'HealthKit returned an invalid cursor.',
            );
          }
          // Even an empty final page must publish the completed metric batch.
          await repository.applyHealthKitPage(
            metric: metric,
            expectedAnchor: anchor,
            nextAnchor: page.anchor,
            samples: page.samples,
            deletedIds: page.deletedIds,
            hasMore: page.more,
          );
          anchor = page.anchor;
          pages++;
          samples += page.samples.length;
          deletions += page.deletedIds.length;
          _checkCancelled();
          onProgress?.call(
            HealthKitRefreshProgress(
              metric: metric,
              pages: pages,
              samples: samples,
              deletions: deletions,
            ),
          );
          if (!page.more) break;
        }
      }
      return HealthKitRefreshResult(
        pages: pages,
        samples: samples,
        deletions: deletions,
      );
    } on HealthKitException {
      rethrow;
    } catch (_) {
      _checkCancelled();
      // Platform/database errors may embed private identifiers or paths.
      throw const HealthKitException(
        'Private Health refresh could not finish. Refresh again to resume.',
      );
    } finally {
      _running = false;
    }
  }
}
