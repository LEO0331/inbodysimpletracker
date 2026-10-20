// Run with flutter test and explicit local source/destination defines.
// This is an opt-in import command, never part of the normal test suite.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:inbodysimpletracker/data/models/training_checkpoint.dart';
import 'package:inbodysimpletracker/data/services/local_checkpoint_service.dart';
import 'package:inbodysimpletracker/data/services/linked_local_video_service.dart';
import 'package:inbodysimpletracker/data/services/local_video_service.dart';
import 'package:inbodysimpletracker/logic/providers/checkpoint_provider.dart';

void main() {
  test('Import explicitly selected desktop videos into local checkpoints', () async {
    const source = String.fromEnvironment('CHECKPOINT_SOURCE');
    const destination = String.fromEnvironment('LOCAL_CHECKPOINT_DIRECTORY');
    const workoutDate = String.fromEnvironment('CHECKPOINT_DATE');
    if (source.isEmpty || destination.isEmpty || workoutDate.isEmpty) {
      fail(
        'Supply CHECKPOINT_SOURCE, LOCAL_CHECKPOINT_DIRECTORY and CHECKPOINT_DATE.',
      );
    }
    final root = Directory(destination);
    final store = LocalCheckpointService(root);
    final videos = LinkedLocalVideoService(
      documentsDirectory: () async => root,
    );
    final managedVideos = LocalVideoService(
      documentsDirectory: () async => root,
    );
    final provider = CheckpointProvider(
      uid: 'local',
      metadataIsLocal: true,
      checkpointService: store,
      localVideoService: videos,
    );
    addTearDown(provider.dispose);
    await store.getCheckpoints('local').first;
    while (provider.isLoading) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    if (provider.error != null) fail(provider.error!);
    final files = await videos.scanDirectory(source);
    var index = 0;
    for (final file in files) {
      index++;
      final hash = await videos.fingerprintVideo(file.path!);
      final existing = provider.checkpoints
          .where((record) => record.videoSha256 == hash)
          .firstOrNull;
      if (existing != null) {
        if (!existing.localVideoPath.startsWith(
          LinkedLocalVideoService.prefix,
        )) {
          final linkedPath = await videos.copyVideo(
            checkpointId: existing.id,
            sourcePath: file.path!,
            originalFileName: file.name,
          );
          final updated = TrainingCheckpoint.fromMap(existing.id, {
            ...existing.toMap(),
            'localVideoPath': linkedPath,
            'updatedAt': DateTime.now(),
          });
          // Save the verified source link before removing a redundant managed copy.
          await store.saveCheckpoint('local', updated);
          await managedVideos.deleteVideo(
            existing.localVideoPath,
            checkpointId: existing.id,
          );
        }
        continue;
      }
      final saved = await provider.saveCheckpoint(
        checkpointDate: DateTime.parse(workoutDate),
        exerciseName: 'Training clip $index',
        side: CheckpointSide.notApplicable,
        cameraAngle: CameraAngle.other,
        video: file,
        notes:
            'Imported without exercise or form analysis. Exercise name is a placeholder; side and camera angle have not been reviewed. Workout date supplied by owner.',
        checkDuplicates: true,
      );
      final path = await videos.resolvePath(
        saved.localVideoPath,
        checkpointId: saved.id,
      );
      expect(path, isNotNull);
      expect(await videos.fingerprintVideo(path!), hash);
      expect(await File(file.path!).exists(), isTrue);
    }
    final reopened = await LocalCheckpointService(root).readAll();
    for (final file in files) {
      final hash = await videos.fingerprintVideo(file.path!);
      final matches = reopened
          .where((record) => record.videoSha256 == hash)
          .toList();
      expect(matches, hasLength(1));
      expect(
        matches.single.localVideoPath,
        startsWith(LinkedLocalVideoService.prefix),
      );
      final linkedPath = await videos.resolvePath(
        matches.single.localVideoPath,
        checkpointId: matches.single.id,
      );
      expect(linkedPath, File(file.path!).absolute.path);
      expect(await videos.fingerprintVideo(linkedPath!), hash);
    }
    // ignore: avoid_print
    print(
      'Verified ${files.length} source clips against ${reopened.length} saved local records.',
    );
  });
}
