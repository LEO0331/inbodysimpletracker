import '../../core/utils/checkpoint_validation.dart';

class LocalVideoService {
  bool get isSupported => false;

  Future<String> copyVideo({
    required String checkpointId,
    required String sourcePath,
    required String originalFileName,
    int maxSizeBytes = defaultMaxVideoBytes,
  }) async => throw UnsupportedError(
    'Adding local video checkpoints is currently available on mobile.',
  );

  Future<String?> resolvePath(
    String relativePath, {
    String? checkpointId,
  }) async => null;

  Future<void> deleteVideo(String relativePath, {String? checkpointId}) async {}
}
