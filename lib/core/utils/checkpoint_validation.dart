const defaultMaxVideoBytes = 2 * 1024 * 1024 * 1024;
const maxExerciseLength = 120;
const maxNotesLength = 4000;
const maxLoadUnitLength = 20;

String? requiredExercise(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Exercise name is required.';
  }
  if (value.trim().length > maxExerciseLength) {
    return 'Exercise name must be $maxExerciseLength characters or fewer.';
  }
  return null;
}

String? optionalNotes(String? value) =>
    (value?.trim().length ?? 0) > maxNotesLength
    ? 'Notes must be $maxNotesLength characters or fewer.'
    : null;

String? optionalLoadUnit(String? value) =>
    (value?.trim().length ?? 0) > maxLoadUnitLength
    ? 'Load unit must be $maxLoadUnitLength characters or fewer.'
    : null;

String? optionalNumber(
  String? value, {
  bool integer = false,
  bool rpe = false,
}) {
  if (value == null || value.trim().isEmpty) return null;
  final number = num.tryParse(value.trim());
  if (number == null ||
      !number.isFinite ||
      (integer && int.tryParse(value.trim()) == null)) {
    return integer ? 'Enter a whole number.' : 'Enter a valid number.';
  }
  if (rpe && (number < 1 || number > 10)) {
    return 'RPE must be between 1 and 10.';
  }
  if (!rpe && number <= 0) return 'Enter a positive number.';
  return null;
}

String? requiredVideo(
  String? path, {
  String? fileName,
  int? sizeBytes,
  int maxSizeBytes = defaultMaxVideoBytes,
}) {
  if (path == null || path.trim().isEmpty) return 'Select a video.';
  final name = (fileName ?? path).toLowerCase();
  if (!['.mp4', '.mov', '.m4v'].any(name.endsWith)) {
    return 'Select an MP4, MOV, or M4V video.';
  }
  if (sizeBytes != null && sizeBytes <= 0) return 'Select a non-empty video.';
  if (sizeBytes != null && sizeBytes > maxSizeBytes) {
    return 'Video exceeds the ${(maxSizeBytes / (1024 * 1024)).toStringAsFixed(0)} MB size limit.';
  }
  return null;
}
