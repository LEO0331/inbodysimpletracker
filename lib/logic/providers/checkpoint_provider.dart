import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../../core/utils/checkpoint_validation.dart';
import '../../data/models/training_checkpoint.dart';
import '../../data/services/checkpoint_service.dart';
import '../../data/services/local_video_service.dart';

class CheckpointOperationException implements Exception {
  final String message;
  final bool localVideoRemoved;

  const CheckpointOperationException(
    this.message, {
    this.localVideoRemoved = false,
  });

  @override
  String toString() => message;
}

class CheckpointProvider extends ChangeNotifier {
  final String uid;
  final CheckpointService _checkpointService;
  final LocalVideoService localVideoService;
  final int maxVideoBytes;
  final Map<String, TrainingCheckpoint> _deleting = {};
  StreamSubscription<List<TrainingCheckpoint>>? _subscription;
  bool _disposed = false;
  List<TrainingCheckpoint> checkpoints = [];
  bool isLoading = true;
  bool isSaving = false;
  String? error;

  CheckpointProvider({
    required this.uid,
    CheckpointService? checkpointService,
    LocalVideoService? localVideoService,
    this.maxVideoBytes = defaultMaxVideoBytes,
  }) : _checkpointService = checkpointService ?? CheckpointService(),
       localVideoService = localVideoService ?? LocalVideoService() {
    _subscription = _checkpointService
        .getCheckpoints(uid)
        .listen(
          (data) {
            checkpoints = [...data];
            // Firestore may emit an optimistic delete before the server responds.
            // Keep the record until the deletion is actually acknowledged.
            for (final pending in _deleting.values) {
              if (!checkpoints.any((item) => item.id == pending.id)) {
                checkpoints.add(pending);
              }
            }
            _sortCheckpoints();
            isLoading = false;
            error = null;
            _notify();
          },
          onError: (Object exception) {
            isLoading = false;
            error = 'Unable to load checkpoints. Please try again.';
            _notify();
          },
        );
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  void _sortCheckpoints() {
    checkpoints.sort((a, b) {
      final order = b.checkpointDate.compareTo(a.checkpointDate);
      return order != 0 ? order : a.id.compareTo(b.id);
    });
  }

  Future<TrainingCheckpoint> saveCheckpoint({
    required DateTime checkpointDate,
    required String exerciseName,
    required CheckpointSide side,
    required CameraAngle cameraAngle,
    required PlatformFile video,
    double? load,
    String loadUnit = 'kg',
    int? sets,
    int? reps,
    double? rpe,
    String? notes,
  }) async {
    if (_disposed) throw StateError('This checkpoint session has ended.');
    if (isSaving) throw StateError('A checkpoint is already being saved.');
    if (!localVideoService.isSupported) {
      throw UnsupportedError(
        'Adding local video checkpoints is currently available on mobile.',
      );
    }
    final validations = [
      requiredExercise(exerciseName),
      optionalNumber(load?.toString()),
      optionalNumber(sets?.toString(), integer: true),
      optionalNumber(reps?.toString(), integer: true),
      optionalNumber(rpe?.toString(), rpe: true),
      optionalLoadUnit(loadUnit),
      optionalNotes(notes),
      requiredVideo(
        video.path,
        fileName: video.name,
        sizeBytes: video.size,
        maxSizeBytes: maxVideoBytes,
      ),
    ];
    for (final validation in validations) {
      if (validation != null) throw ArgumentError(validation);
    }
    isSaving = true;
    _notify();
    String? localPath;
    String? id;
    var savingMetadata = false;
    try {
      id = _checkpointService.createId(uid);
      localPath = await localVideoService.copyVideo(
        checkpointId: id,
        sourcePath: video.path!,
        originalFileName: video.name,
        maxSizeBytes: maxVideoBytes,
      );
      if (_disposed) throw StateError('This checkpoint session has ended.');
      final now = DateTime.now();
      final checkpoint = TrainingCheckpoint(
        id: id,
        checkpointDate: checkpointDate,
        exerciseName: exerciseName.trim(),
        side: side,
        cameraAngle: cameraAngle,
        load: load,
        loadUnit: loadUnit.trim().isEmpty ? 'kg' : loadUnit.trim(),
        sets: sets,
        reps: reps,
        rpe: rpe,
        notes: notes?.trim(),
        localVideoPath: localPath,
        originalFileName: video.name,
        fileSizeBytes: video.size,
        createdAt: now,
        updatedAt: now,
      );
      savingMetadata = true;
      await _checkpointService.saveCheckpoint(uid, checkpoint);
      if (!_disposed) {
        checkpoints.removeWhere((item) => item.id == checkpoint.id);
        checkpoints.add(checkpoint);
        _sortCheckpoints();
      }
      return checkpoint;
    } catch (exception) {
      if (exception is LocalVideoCopyException) {
        throw const CheckpointOperationException(
          'Video copy failed. Cleanup also failed, so a local video copy may remain on this device.',
        );
      }
      if (localPath != null) {
        try {
          await localVideoService.deleteVideo(localPath, checkpointId: id);
        } catch (_) {
          throw const CheckpointOperationException(
            'Checkpoint was not saved. Cleanup also failed, so a local video copy may remain on this device.',
          );
        }
      }
      if (_disposed) throw StateError('This checkpoint session has ended.');
      if (exception is ArgumentError) rethrow;
      throw CheckpointOperationException(
        savingMetadata
            ? 'Unable to save checkpoint metadata. The local copy was removed; please try again.'
            : 'Unable to copy the selected video. Check that the file is available and the device has enough storage, then try again.',
      );
    } finally {
      isSaving = false;
      _notify();
    }
  }

  Future<void> deleteCheckpoint(TrainingCheckpoint checkpoint) async {
    if (_disposed) throw StateError('This checkpoint session has ended.');
    if (_deleting.containsKey(checkpoint.id)) {
      throw StateError('This checkpoint is already being deleted.');
    }
    _deleting[checkpoint.id] = checkpoint;
    try {
      try {
        await localVideoService.deleteVideo(
          checkpoint.localVideoPath,
          checkpointId: checkpoint.id,
        );
      } catch (_) {
        throw const CheckpointOperationException(
          'Unable to remove the local video. Checkpoint metadata was kept; please try again.',
        );
      }
      if (_disposed) throw StateError('This checkpoint session has ended.');
      try {
        await _checkpointService.deleteCheckpoint(uid, checkpoint.id);
      } catch (_) {
        throw const CheckpointOperationException(
          'The local video was removed, but checkpoint metadata could not be deleted. Please retry deleting the checkpoint.',
          localVideoRemoved: true,
        );
      }
      checkpoints.removeWhere((item) => item.id == checkpoint.id);
      _notify();
    } finally {
      _deleting.remove(checkpoint.id);
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _subscription?.cancel();
    super.dispose();
  }
}
