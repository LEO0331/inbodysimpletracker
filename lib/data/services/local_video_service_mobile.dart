import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalVideoService {
  final Future<Directory> Function() _documentsDirectory;

  LocalVideoService({Future<Directory> Function()? documentsDirectory})
    : _documentsDirectory =
          documentsDirectory ?? getApplicationDocumentsDirectory;

  bool get isSupported => true;

  static String sanitizeFileName(String name) {
    final base = name.replaceAll('\\', '/').split('/').last;
    final safe = base.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    if (safe.isEmpty || safe == '.' || safe == '..') return 'video';
    // Bound filename length while preserving the playback extension.
    if (safe.length <= 120) return safe;
    final dot = safe.lastIndexOf('.');
    final extension = dot >= 0 && safe.length - dot <= 10
        ? safe.substring(dot)
        : '';
    return '${safe.substring(0, 120 - extension.length)}$extension';
  }

  static String destinationReference(
    String checkpointId,
    String originalFileName,
  ) {
    if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(checkpointId)) {
      throw ArgumentError.value(
        checkpointId,
        'checkpointId',
        'Invalid checkpoint ID',
      );
    }
    return 'training_videos/$checkpointId/${sanitizeFileName(originalFileName)}';
  }

  Future<File?> _managedFile(String relativePath) async {
    // Cloud metadata must never be able to access files outside this directory.
    final segments = relativePath.split('/');
    if (segments.length != 3 ||
        segments.first != 'training_videos' ||
        !RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(segments[1]) ||
        segments[2] != sanitizeFileName(segments[2]) ||
        relativePath.contains('\\')) {
      return null;
    }
    final root = await _documentsDirectory();
    final videoRoot = Directory(
      '${root.path}${Platform.pathSeparator}training_videos',
    );
    final checkpointDirectory = Directory(
      '${videoRoot.path}${Platform.pathSeparator}${segments[1]}',
    );
    final file = File(
      '${checkpointDirectory.path}${Platform.pathSeparator}${segments[2]}',
    );
    // Refuse symlinks, including ancestor directories.
    for (final path in [videoRoot.path, checkpointDirectory.path, file.path]) {
      if (await FileSystemEntity.type(path, followLinks: false) ==
          FileSystemEntityType.link) {
        return null;
      }
    }
    return file;
  }

  Future<String> copyVideo({
    required String checkpointId,
    required String sourcePath,
    required String originalFileName,
  }) async {
    final reference = destinationReference(checkpointId, originalFileName);
    final destination = await _managedFile(reference);
    if (destination == null) {
      throw StateError('Unsafe local video destination.');
    }
    if (await destination.exists()) {
      throw StateError('Checkpoint video already exists.');
    }
    await destination.parent.create(recursive: true);
    try {
      await File(sourcePath).copy(destination.path);
    } catch (_) {
      try {
        await deleteVideo(reference);
      } catch (_) {
        // Preserve the copy error if best-effort cleanup also fails.
      }
      rethrow;
    }
    return reference;
  }

  Future<String?> resolvePath(String relativePath) async {
    final file = await _managedFile(relativePath);
    return file != null && await file.exists() ? file.path : null;
  }

  Future<void> deleteVideo(String relativePath) async {
    final file = await _managedFile(relativePath);
    if (file == null) return;
    if (await file.exists()) await file.delete();
    final directory = file.parent;
    if (await directory.exists() && await directory.list().isEmpty) {
      await directory.delete();
    }
  }
}
