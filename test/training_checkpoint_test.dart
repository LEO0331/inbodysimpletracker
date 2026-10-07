import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inbodysimpletracker/data/models/training_checkpoint.dart';

void main() {
  test('metadata round trip preserves all fields and excludes ID', () {
    final date = DateTime(2026, 10, 7);
    final checkpoint = TrainingCheckpoint(
      id: 'checkpoint',
      checkpointDate: date,
      exerciseName: 'Hip Abduction',
      side: CheckpointSide.right,
      cameraAngle: CameraAngle.side,
      load: 10,
      sets: 3,
      reps: 12,
      rpe: 6,
      notes: 'Baseline',
      localVideoPath: 'training_videos/checkpoint/video.mov',
      originalFileName: 'video.mov',
      fileSizeBytes: 4,
      durationMs: 200,
      createdAt: date,
      updatedAt: date,
    );
    final map = checkpoint.toMap();
    expect(map['checkpointDate'], isA<Timestamp>());
    expect(map.containsKey('id'), isFalse);
    final restored = TrainingCheckpoint.fromMap(checkpoint.id, map);
    expect(restored.toMap(), map);
    expect(restored.id, checkpoint.id);
  });

  test('null fields and unknown enum values have safe defaults', () {
    final checkpoint = TrainingCheckpoint.fromMap('empty', null);
    expect(checkpoint.side, CheckpointSide.notApplicable);
    expect(checkpoint.cameraAngle, CameraAngle.other);
    expect(checkpoint.loadUnit, 'kg');
    expect(checkpoint.load, isNull);
    expect(checkpoint.sets, isNull);
    expect(checkpoint.reps, isNull);
    expect(checkpoint.rpe, isNull);
    expect(checkpoint.notes, isNull);
    expect(checkpoint.fileSizeBytes, isNull);
    expect(checkpoint.durationMs, isNull);
    expect(
      TrainingCheckpoint.fromMap('unknown', {
        'side': 3,
        'cameraAngle': 'unknown',
      }).side,
      CheckpointSide.notApplicable,
    );
  });

  test(
    'parses numeric strings but rejects malformed and out of range values',
    () {
      final checkpoint = TrainingCheckpoint.fromMap('id', {
        'checkpointDate': '2026-10-07',
        'load': '10.5',
        'sets': '3',
        'reps': 12,
        'rpe': '6',
        'side': 'left',
        'cameraAngle': 'front',
      });
      expect(checkpoint.load, 10.5);
      expect(checkpoint.sets, 3);
      expect(checkpoint.rpe, 6);
      expect(checkpoint.side, CheckpointSide.left);
      expect(checkpoint.cameraAngle, CameraAngle.front);
      expect(checkpoint.checkpointDate, DateTime(2026, 10, 7));
      for (final bad in ['oops', 'NaN', double.infinity, -1, {}, []]) {
        final parsed = TrainingCheckpoint.fromMap('bad', {
          'load': bad,
          'sets': bad,
          'rpe': bad,
        });
        expect(parsed.load, isNull);
        expect(parsed.sets, isNull);
        expect(parsed.rpe, isNull);
      }
      expect(
        TrainingCheckpoint.fromMap('bad', {'sets': 1.5, 'rpe': 11}).sets,
        isNull,
      );
      expect(
        TrainingCheckpoint.fromMap('bad', {'sets': 1.5, 'rpe': 11}).rpe,
        isNull,
      );
    },
  );
}
