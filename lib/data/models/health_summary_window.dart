import '../../core/utils/health_aggregation.dart';

/// Derived results and explicit gaps. Calendar dates use UTC midnight as labels.
class HealthSummaryWindow {
  const HealthSummaryWindow({
    required this.summaries,
    this.limitedDays = const [],
    this.incompleteDays = const [],
    this.cacheHitDays = 0,
  });
  final List<HealthDailySummary> summaries;
  final List<DateTime> limitedDays;
  final List<DateTime> incompleteDays;
  final int cacheHitDays;
}
