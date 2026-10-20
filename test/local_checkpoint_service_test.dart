import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:inbodysimpletracker/data/models/training_checkpoint.dart';
import 'package:inbodysimpletracker/data/services/local_checkpoint_service.dart';

void main() {
  late Directory directory;
  setUp(
    () async =>
        directory = await Directory.systemTemp.createTemp('checkpoints_'),
  );
  tearDown(() async => directory.delete(recursive: true));

  TrainingCheckpoint checkpoint(String id) => TrainingCheckpoint(
    id: id,
    checkpointDate: DateTime(2026, 10, 19),
    exerciseName: 'Training clip',
    side: CheckpointSide.notApplicable,
    cameraAngle: CameraAngle.other,
    localVideoPath: 'training_videos/$id/video.mp4',
    originalFileName: 'video.mp4',
    createdAt: DateTime(2026, 10, 20),
    updatedAt: DateTime(2026, 10, 20),
  );

  test(
    'local records persist across reopen, update and deletion without Firebase',
    () async {
      final service = LocalCheckpointService(directory);
      expect(await service.getCheckpoints('local').first, isEmpty);
      await service.saveCheckpoint('local', checkpoint('a'));
      await service.saveCheckpoint('local', checkpoint('b'));
      await service.saveCheckpoint('local', checkpoint('a'));
      final reopened = LocalCheckpointService(directory);
      final records = await reopened.readAll();
      expect(records.map((record) => record.id), ['a', 'b']);
      expect(records.first.checkpointDate, DateTime(2026, 10, 19));
      expect(records.first.localVideoPath, 'training_videos/a/video.mp4');
      await reopened.deleteCheckpoint('local', 'a');
      expect(
        (await LocalCheckpointService(directory).readAll()).single.id,
        'b',
      );
    },
  );

  test('active subscribers see saves and deletions', () async {
    final service = LocalCheckpointService(directory);
    final events = service.getCheckpoints('local').take(3).toList();
    await Future<void>.delayed(const Duration(milliseconds: 20));
    await service.saveCheckpoint('local', checkpoint('a'));
    await Future<void>.delayed(const Duration(milliseconds: 20));
    await service.deleteCheckpoint('local', 'a');
    expect((await events).map((records) => records.length), [0, 1, 0]);
  });

  test(
    'corrupt existing records are preserved rather than overwritten',
    () async {
      final file = File('${directory.path}/checkpoints.json');
      await file.writeAsString('{broken');
      await expectLater(
        LocalCheckpointService(
          directory,
        ).saveCheckpoint('local', checkpoint('a')),
        throwsFormatException,
      );
      expect(await file.readAsString(), '{broken');
    },
  );
}
