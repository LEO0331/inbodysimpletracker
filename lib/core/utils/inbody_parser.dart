class InbodyParser {
  /// Parses the recognized text from OCR or PDF into a map of metrics.
  static Map<String, dynamic> parse(String text) {
    final normalizedText = text.replaceAll('：', ':');

    double getValue(List<RegExp> regexes) {
      for (final regex in regexes) {
        final match = regex.firstMatch(normalizedText);
        if (match == null) continue;

        final rawValue = match.group(1);
        if (rawValue == null) continue;

        final value = double.tryParse(rawValue);
        if (value != null) return value;
      }

      return 0.0;
    }

    String getReportDate() {
      final regex = RegExp(
        r'(\d{4})[./-](\d{1,2})[./-](\d{1,2})\.?\s+(\d{1,2}):(\d{2})',
      );
      final match = regex.firstMatch(normalizedText);
      if (match == null) return DateTime.now().toIso8601String();

      final year = int.parse(match.group(1)!);
      final month = int.parse(match.group(2)!);
      final day = int.parse(match.group(3)!);
      final hour = int.parse(match.group(4)!);
      final minute = int.parse(match.group(5)!);
      return DateTime(year, month, day, hour, minute).toIso8601String();
    }

    double getVisceralFat() {
      final value = getValue([
        RegExp(r'(?:內臟脂肪級別|内脏脂肪级别)[^\d]{0,20}(\d+(?:\.\d+)?)'),
        RegExp(
          r'Visceral\s*Fat(?:\s*Level)?[:\s]*(\d+(?:\.\d+)?)',
          caseSensitive: false,
        ),
      ]);

      if (value != 0.0) return value;

      final regex = RegExp(
        r'(?:內臟脂肪級別|内脏脂肪级别)[\s\S]{0,30}?級別[^\d]{0,10}(\d+(?:\.\d+)?)',
      );
      final match = regex.firstMatch(normalizedText);
      return match != null ? (double.tryParse(match.group(1)!) ?? 0.0) : 0.0;
    }

    return {
      "weight": getValue([
        RegExp(r'(?:^|[\s\n])(?:體重|体重)[^\d]{0,20}(\d+(?:\.\d+)?)'),
        RegExp(r'Weight[:\s]*(\d+(?:\.\d+)?)', caseSensitive: false),
      ]),
      "bodyFatPercent": getValue([
        RegExp(r'(?:體脂肪率|体脂肪率|PBF)[^\d]{0,20}(\d+(?:\.\d+)?)'),
        RegExp(
          r'(?:Percent\s*Body\s*Fat|Body\s*Fat\s*Percent|Body\s*Fat)[:\s]*(\d+(?:\.\d+)?)',
          caseSensitive: false,
        ),
      ]),
      "muscleMass": getValue([
        RegExp(r'(?:骨骼肌重|骨骼肌量|SMM)[^\d]{0,20}(\d+(?:\.\d+)?)'),
        RegExp(r'Muscle\s*Mass[:\s]*(\d+(?:\.\d+)?)', caseSensitive: false),
      ]),
      "visceralFat": getVisceralFat(),
      "reportDate": getReportDate(),
    };
  }
}
