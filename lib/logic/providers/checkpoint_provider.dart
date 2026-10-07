import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../../data/models/training_checkpoint.dart';
import '../../data/services/checkpoint_service.dart';
import '../../data/services/local_video_service.dart';

class CheckpointProvider extends ChangeNotifier {
  final String uid;
  final CheckpointService _checkpointService;
  final LocalVideoService localVideoService;
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
  }) : _checkpointService = checkpointService ?? CheckpointService(),
       localVideoService = localVideoService ?? LocalVideoService() {
    _subscription = _checkpointService
        .getCheckpoints(uid)
        .listen(
          (data) {
            checkpoints = data;
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
    if (exerciseName.trim().isEmpty ||
        video.path == null ||
        video.path!.isEmpty) {
      throw ArgumentError('Exercise name and a video are required.');
    }
    if ((load != null && (!load.isFinite || load < 0)) ||
        (sets != null && sets < 0) ||
        (reps != null && reps < 0) ||
        (rpe != null && (!rpe.isFinite || rpe < 1 || rpe > 10))) {
      throw ArgumentError('Invalid numeric checkpoint values.');
    }
    isSaving = true;
    _notify();
    String? localPath;
    try {
      final id = _checkpointService.createId(uid);
      localPath = await localVideoService.copyVideo(
        checkpointId: id,
        sourcePath: video.path!,
        originalFileName: video.name,
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
      await _checkpointService.saveCheckpoint(uid, checkpoint);
      return checkpoint;
    } catch (_) {
      if (localPath != null) {
        try {
          await localVideoService.deleteVideo(localPath);
        } catch (_) {
          // Preserve the save error if best-effort local cleanup also fails.
        }
      }
      rethrow;
    } finally {
      isSaving = false;
      _notify();
    }
  }

  Future<void> deleteCheckpoint(TrainingCheckpoint checkpoint) async {
    if (_disposed) throw StateError('This checkpoint session has ended.');
    await localVideoService.deleteVideo(checkpoint.localVideoPath);
    await _checkpointService.deleteCheckpoint(uid, checkpoint.id);
  }

  @override
  void dispose() {
    _disposed = true;
    _subscription?.cancel();
    super.dispose();
  }
}
