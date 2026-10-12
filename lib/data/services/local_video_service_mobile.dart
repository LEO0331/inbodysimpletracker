import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/utils/checkpoint_validation.dart';
import 'local_video_copy_exception.dart';

class LocalVideoService {
  final Future<Directory> Function() _documentsDirectory;

  LocalVideoService({Future<Directory> Function()? documentsDirectory})
    : _documentsDirectory =
          documentsDirectory ?? getApplicationDocumentsDirectory;

  bool get isSupported => true;

  /// Only direct regular files are selected; links and nested folders are skipped.
  Future<List<PlatformFile>> scanDirectory(String path) async {
    final files = <PlatformFile>[];
    await for (final entity in Directory(path).list(followLinks: false)) {
      if (entity is! File) continue;
      final name = entity.uri.pathSegments.last;
      if (!RegExp(r'\.(mp4|mov|m4v)$', caseSensitive: false).hasMatch(name)) {
        continue;
      }
      files.add(
        PlatformFile(
          name: name,
          size: await entity.length(),
          path: entity.path,
        ),
      );
    }
    files.sort((a, b) => a.name.compareTo(b.name));
    return files;
  }

  /// Stream bytes so large clips do not have to fit in memory.
  Future<String> fingerprintVideo(
    String path, {
    int maxSizeBytes = defaultMaxVideoBytes,
  }) async {
    final file = File(path);
    final length = await file.length();
    if (length <= 0 || length > maxSizeBytes) {
      throw ArgumentError('Select a non-empty video within the size limit.');
    }
    var read = 0;
    final chunks = file.openRead().map((chunk) {
      read += chunk.length;
      if (read > maxSizeBytes) {
        throw ArgumentError('Video exceeds the size limit.');
      }
      return chunk;
    });
    final digest = await sha256.bind(chunks).first;
    if (read != length || await file.length() != length) {
      throw StateError('The selected file changed. Please select it again.');
    }
    return digest.toString();
  }

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

  Future<File?> _managedFile(
    String relativePath, {
    String? checkpointId,
  }) async {
    // Cloud metadata must never be able to access files outside this directory.
    final segments = relativePath.split('/');
    if (segments.length != 3 ||
        segments.first != 'training_videos' ||
        !RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(segments[1]) ||
        (checkpointId != null && segments[1] != checkpointId) ||
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
    int maxSizeBytes = defaultMaxVideoBytes,
  }) async {
    final source = File(sourcePath);
    final length = await source.length();
    final validation = requiredVideo(
      sourcePath,
      fileName: originalFileName,
      sizeBytes: length,
      maxSizeBytes: maxSizeBytes,
    );
    if (validation != null) throw ArgumentError(validation);
    final reference = destinationReference(checkpointId, originalFileName);
    final destination = await _managedFile(reference);
    if (destination == null) {
      throw StateError('Unsafe local video destination.');
    }
    await destination.parent.create(recursive: true);
    // Reserve before entering cleanup: a collision never owns the existing file.
    await destination.create(exclusive: true);
    try {
      await source.copy(destination.path);
      final copiedLength = await destination.length();
      if (copiedLength != length ||
          copiedLength <= 0 ||
          copiedLength > maxSizeBytes) {
        throw StateError(
          'The selected file changed while copying. Please select it again.',
        );
      }
    } catch (_) {
      try {
        await deleteVideo(reference, checkpointId: checkpointId);
      } catch (_) {
        throw LocalVideoCopyException(reference);
      }
      rethrow;
    }
    return reference;
  }

  Future<String?> resolvePath(
    String relativePath, {
    String? checkpointId,
  }) async {
    final file = await _managedFile(relativePath, checkpointId: checkpointId);
    return file != null && await file.exists() ? file.path : null;
  }

  Future<void> deleteVideo(String relativePath, {String? checkpointId}) async {
    final file = await _managedFile(relativePath, checkpointId: checkpointId);
    if (file == null) return;
    if (await file.exists()) await file.delete();
    final directory = file.parent;
    if (await directory.exists() && await directory.list().isEmpty) {
      await directory.delete();
    }
  }
}
