import 'package:file_picker/file_picker.dart';

import '../../core/utils/checkpoint_validation.dart';

class LocalVideoService {
  // Native callers inject a directory provider. Web never opens local storage.
  LocalVideoService({Object? documentsDirectory});

  bool get isSupported => false;

  Future<List<PlatformFile>> scanDirectory(String path) async =>
      throw UnsupportedError('Folder import is unavailable on web.');

  Future<String> fingerprintVideo(
    String path, {
    int maxSizeBytes = defaultMaxVideoBytes,
  }) async => throw UnsupportedError('Video import is unavailable on web.');

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
