import '../models/health_observation.dart';

/// Local-only contract. Cloud identifiers and services do not cross this boundary.
abstract class HealthRepository {
  Future<void> open();
  Future<void> close();
  Future<String> beginImport();
  Future<int> appendObservations(
    String batchId,
    List<HealthObservation> observations,
  );
  Future<void> finishImport(String batchId, {required int skippedCount});
  Future<void> abortImport(String batchId);
  Future<void> deleteImport(String batchId);
  Future<List<HealthImportBatch>> listImports();
  Future<List<String>> listSources(HealthMetric metric);
  Future<List<HealthObservation>> queryObservations({
    required DateTime from,
    required DateTime to,
    HealthMetric? metric,
    String? source,
    int limit = 1000,
    int offset = 0,
  });
  Stream<List<Map<String, Object?>>> exportChunks({int chunkSize = 500});
  Future<void> restoreChunks(Stream<List<Map<String, Object?>>> chunks);
  Future<List<HealthNote>> listNotes(DateTime from, DateTime to);
  Future<void> saveNote(HealthNote note);
  Future<void> deleteNote(String id);
}
