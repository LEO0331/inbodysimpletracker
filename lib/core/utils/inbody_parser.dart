class InbodyParser {
  /// Parses the recognized text from OCR or PDF into a map of metrics.
  static Map<String, dynamic> parse(String text) {
    final weightRegex = RegExp(r'Weight[:\s]*([\d.]+)');
    final fatRegex = RegExp(r'Body\s*Fat[:\s]*([\d.]+)');
    final muscleRegex = RegExp(r'Muscle\s*Mass[:\s]*([\d.]+)');
    final visceralRegex = RegExp(r'Visceral\s*Fat[:\s]*([\d.]+)');

    double getValue(RegExp regex) {
      final match = regex.firstMatch(text);
      return match != null ? (double.tryParse(match.group(1)!) ?? 0.0) : 0.0;
    }

    return {
      "weight": getValue(weightRegex),
      "bodyFatPercent": getValue(fatRegex),
      "muscleMass": getValue(muscleRegex),
      "visceralFat": getValue(visceralRegex),
      "reportDate": DateTime.now().toIso8601String(),
    };
  }
}
