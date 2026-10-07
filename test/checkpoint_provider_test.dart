import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:inbodysimpletracker/data/models/training_checkpoint.dart';
import 'package:inbodysimpletracker/data/services/checkpoint_service.dart';
import 'package:inbodysimpletracker/data/services/local_video_service.dart';
import 'package:inbodysimpletracker/logic/providers/checkpoint_provider.dart';

class MockCheckpointService extends Mock implements CheckpointService {}

class MockLocalVideoService extends Mock implements LocalVideoService {}

void main() {
  late MockCheckpointService metadata;
  late MockLocalVideoService videos;
  late StreamController<List<TrainingCheckpoint>> stream;
  late CheckpointProvider provider;
  var disposed = false;
  final date = DateTime(2026, 10, 7);
  final fallback = TrainingCheckpoint(
    id: 'id',
    checkpointDate: date,
    exerciseName: 'Hip Abduction',
    side: CheckpointSide.right,
    cameraAngle: CameraAngle.side,
    localVideoPath: 'training_videos/id/video.mov',
    originalFileName: 'video.mov',
    createdAt: date,
    updatedAt: date,
  );
  setUpAll(() => registerFallbackValue(fallback));
  setUp(() {
    disposed = false;
    metadata = MockCheckpointService();
    videos = MockLocalVideoService();
    stream = StreamController<List<TrainingCheckpoint>>();
    when(
      () => metadata.getCheckpoints('user'),
    ).thenAnswer((_) => stream.stream);
    when(() => metadata.createId('user')).thenReturn('id');
    when(() => videos.isSupported).thenReturn(true);
    when(
      () => videos.copyVideo(
        checkpointId: 'id',
        sourcePath: '/picked',
        originalFileName: 'video.mov',
      ),
    ).thenAnswer((_) async => fallback.localVideoPath);
    when(() => videos.deleteVideo(any())).thenAnswer((_) async {});
    when(() => metadata.saveCheckpoint('user', any())).thenAnswer((_) async {});
    provider = CheckpointProvider(
      uid: 'user',
      checkpointService: metadata,
      localVideoService: videos,
    );
  });
  tearDown(() async {
    if (!disposed) provider.dispose();
    await stream.close();
  });

  Future<TrainingCheckpoint> save() => provider.saveCheckpoint(
    checkpointDate: date,
    exerciseName: ' Hip Abduction ',
    side: CheckpointSide.right,
    cameraAngle: CameraAngle.side,
    video: PlatformFile(name: 'video.mov', size: 4, path: '/picked'),
    load: 10,
    sets: 3,
    reps: 12,
    rpe: 6,
  );

  test('subscribes to user metadata and exposes stream errors', () async {
    expect(provider.isLoading, isTrue);
    stream.add([fallback]);
    await Future<void>.delayed(Duration.zero);
    expect(provider.checkpoints, [fallback]);
    expect(provider.isLoading, isFalse);
    stream.addError(StateError('offline'));
    await Future<void>.delayed(Duration.zero);
    expect(provider.error, isNotNull);
    stream.add([]);
    await Future<void>.delayed(Duration.zero);
    expect(provider.error, isNull);
  });

  test(
    'save copies video and writes only metadata with a relative reference',
    () async {
      final result = await save();
      expect(result.localVideoPath, fallback.localVideoPath);
      expect(result.exerciseName, 'Hip Abduction');
      expect(result.fileSizeBytes, 4);
      verify(() => metadata.saveCheckpoint('user', result)).called(1);
      expect(provider.isSaving, isFalse);
    },
  );

  test('failed metadata save cleans up copied video', () async {
    when(
      () => metadata.saveCheckpoint('user', any()),
    ).thenThrow(StateError('offline'));
    await expectLater(save(), throwsStateError);
    verify(() => videos.deleteVideo(fallback.localVideoPath)).called(1);
    expect(provider.isSaving, isFalse);
  });

  test('duplicate save is rejected while first save is pending', () async {
    final pending = Completer<void>();
    when(
      () => metadata.saveCheckpoint('user', any()),
    ).thenAnswer((_) => pending.future);
    final first = save();
    await Future<void>.delayed(Duration.zero);
    await expectLater(save(), throwsStateError);
    pending.complete();
    await first;
    verify(() => metadata.saveCheckpoint('user', any())).called(1);
  });

  test('delete removes local copy and metadata for scoped uid', () async {
    when(
      () => metadata.deleteCheckpoint('user', 'id'),
    ).thenAnswer((_) async {});
    await provider.deleteCheckpoint(fallback);
    verifyInOrder([
      () => videos.deleteVideo(fallback.localVideoPath),
      () => metadata.deleteCheckpoint('user', 'id'),
    ]);
  });

  test('required and numeric validation prevents copying any file', () async {
    Future<TrainingCheckpoint> invalid({
      String exercise = 'Exercise',
      String? path = '/picked',
      double? rpe,
      double? load,
      int? sets,
    }) => provider.saveCheckpoint(
      checkpointDate: date,
      exerciseName: exercise,
      side: CheckpointSide.bilateral,
      cameraAngle: CameraAngle.front,
      video: PlatformFile(name: 'video.mov', size: 4, path: path),
      rpe: rpe,
      load: load,
      sets: sets,
    );
    await expectLater(invalid(exercise: ' '), throwsArgumentError);
    await expectLater(invalid(path: null), throwsArgumentError);
    await expectLater(invalid(rpe: 0), throwsArgumentError);
    await expectLater(invalid(rpe: 11), throwsArgumentError);
    await expectLater(invalid(load: double.nan), throwsArgumentError);
    await expectLater(invalid(sets: -1), throwsArgumentError);
    verifyNever(
      () => videos.copyVideo(
        checkpointId: any(named: 'checkpointId'),
        sourcePath: any(named: 'sourcePath'),
        originalFileName: any(named: 'originalFileName'),
      ),
    );
    expect(provider.isSaving, isFalse);
  });

  test('disposed account scope rejects saves and deletes', () async {
    provider.dispose();
    disposed = true;
    await expectLater(save(), throwsStateError);
    await expectLater(provider.deleteCheckpoint(fallback), throwsStateError);
    verifyNever(() => metadata.saveCheckpoint('user', any()));
    verifyNever(() => videos.deleteVideo(any()));
  });

  test(
    'account scope ending during copy cleans file without saving metadata',
    () async {
      final pendingCopy = Completer<String>();
      when(
        () => videos.copyVideo(
          checkpointId: 'id',
          sourcePath: '/picked',
          originalFileName: 'video.mov',
        ),
      ).thenAnswer((_) => pendingCopy.future);
      final pendingSave = save();
      provider.dispose();
      disposed = true;
      pendingCopy.complete(fallback.localVideoPath);
      await expectLater(pendingSave, throwsStateError);
      verify(() => videos.deleteVideo(fallback.localVideoPath)).called(1);
      verifyNever(() => metadata.saveCheckpoint('user', any()));
    },
  );
}
