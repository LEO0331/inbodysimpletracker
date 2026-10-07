String? requiredExercise(String? value) =>
    value == null || value.trim().isEmpty ? 'Exercise name is required.' : null;

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
  if (!rpe && number < 0) return 'Enter zero or a positive number.';
  return null;
}

String? requiredVideo(String? path) =>
    path == null || path.isEmpty ? 'Select a video.' : null;
