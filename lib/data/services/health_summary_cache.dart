import '../models/health_observation.dart';
import '../models/health_summary_window.dart';

/// Optional native capability; existing repositories retain their bounded fallback.
abstract class HealthSummaryCache {
  Future<HealthSummaryWindow> queryDailySummaries({
    required DateTime from,
    required DateTime to,
    required HealthMetric metric,
    String? source,
    int? offsetMinutes,
  });
}
