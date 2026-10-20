import 'dart:io';

import '../../core/utils/checkpoint_validation.dart';
import 'local_video_service.dart';

/// Only for the device-only Windows store, never cloud-backed checkpoints.
/// Links are owned by the user: removing a checkpoint must not delete the source.
class LinkedLocalVideoService extends LocalVideoService {
  LinkedLocalVideoService({super.documentsDirectory});

  static const prefix = 'linked-file:';

  Future<File?> _linkedFile(String reference) async {
    if (!reference.startsWith(prefix)) return null;
    final file = File(reference.substring(prefix.length));
    if (!file.isAbsolute ||
        file.path.startsWith(r'\\') ||
        !RegExp(
          r'\.(mp4|mov|m4v)$',
          caseSensitive: false,
        ).hasMatch(file.path) ||
        await FileSystemEntity.type(file.path, followLinks: false) !=
            FileSystemEntityType.file) {
      return null;
    }
    return file;
  }

  @override
  Future<String> copyVideo({
    required String checkpointId,
    required String sourcePath,
    required String originalFileName,
    int maxSizeBytes = defaultMaxVideoBytes,
  }) async {
    final reference = '$prefix${File(sourcePath).absolute.path}';
    final file = await _linkedFile(reference);
    if (file == null) {
      throw ArgumentError('Select an existing local video file.');
    }
    final validation = requiredVideo(
      file.path,
      fileName: originalFileName,
      sizeBytes: await file.length(),
      maxSizeBytes: maxSizeBytes,
    );
    if (validation != null) throw ArgumentError(validation);
    return reference;
  }

  @override
  Future<String?> resolvePath(
    String relativePath, {
    String? checkpointId,
  }) async {
    if (relativePath.startsWith(prefix)) {
      return (await _linkedFile(relativePath))?.path;
    }
    // Keep pre-existing managed copies readable until explicitly migrated.
    return super.resolvePath(relativePath, checkpointId: checkpointId);
  }

  @override
  Future<void> deleteVideo(String relativePath, {String? checkpointId}) async {
    if (relativePath.startsWith(prefix)) return;
    return super.deleteVideo(relativePath, checkpointId: checkpointId);
  }
}
