import 'package:flutter_test/flutter_test.dart';
import 'package:inbodysimpletracker/data/services/checkpoint_service.dart';

void main() {
  test('includes missing dates and sorts equal dates deterministically', () {
    final checkpoints = decodeCheckpointSnapshotRecords([
      (id: 'old', data: <String, dynamic>{}, hasPendingWrites: false),
      (
        id: 'recent_b',
        data: <String, dynamic>{'checkpointDate': '2026-10-07'},
        hasPendingWrites: false,
      ),
      (
        id: 'recent_a',
        data: <String, dynamic>{'checkpointDate': '2026-10-07'},
        hasPendingWrites: false,
      ),
    ]);
    expect(checkpoints.map((item) => item.id), ['recent_a', 'recent_b', 'old']);
    expect(
      checkpoints.last.checkpointDate,
      DateTime.fromMillisecondsSinceEpoch(0),
    );
  });

  test(
    'pending saves appear only after acknowledgement and rejected saves stay absent',
    () {
      final old = (
        id: 'old',
        data: <String, dynamic>{},
        hasPendingWrites: false,
      );
      final data = <String, dynamic>{'checkpointDate': '2026-10-08'};
      final pending = (id: 'new', data: data, hasPendingWrites: true);
      expect(
        decodeCheckpointSnapshotRecords([old, pending]).map((item) => item.id),
        ['old'],
      );
      final acknowledged = (id: 'new', data: data, hasPendingWrites: false);
      expect(
        decodeCheckpointSnapshotRecords([
          old,
          acknowledged,
        ]).map((item) => item.id),
        ['new', 'old'],
      );
      expect(decodeCheckpointSnapshotRecords([old]).map((item) => item.id), [
        'old',
      ]);
    },
  );
}
