class LocalVideoService {
  bool get isSupported => false;

  Future<String> copyVideo({
    required String checkpointId,
    required String sourcePath,
    required String originalFileName,
  }) async => throw UnsupportedError(
    'Adding local video checkpoints is currently available on mobile.',
  );

  Future<String?> resolvePath(String relativePath) async => null;

  Future<void> deleteVideo(String relativePath) async {}
}
