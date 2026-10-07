import '../../../data/models/training_checkpoint.dart';

String sideLabel(CheckpointSide side) => switch (side) {
  CheckpointSide.left => 'Left',
  CheckpointSide.right => 'Right',
  CheckpointSide.bilateral => 'Bilateral',
  CheckpointSide.notApplicable => 'N/A',
};

String angleLabel(CameraAngle angle) => switch (angle) {
  CameraAngle.front => 'Front',
  CameraAngle.side => 'Side',
  CameraAngle.rear => 'Rear',
  CameraAngle.oblique => 'Oblique',
  CameraAngle.other => 'Other',
};
