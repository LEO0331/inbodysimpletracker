import '../models/health_observation.dart';

/// Optional native capability. Anchor advancement and sample changes are atomic.
abstract class HealthKitRepository {
  Future<String?> readHealthKitAnchor(HealthMetric metric);
  Future<void> applyHealthKitPage({
    required HealthMetric metric,
    required String? expectedAnchor,
    required String nextAnchor,
    required List<HealthObservation> samples,
    required List<String> deletedIds,
    bool hasMore = false,
  });
  Future<void> deleteHealthKitData();
}
