import 'package:cloud_firestore/cloud_firestore.dart';

class InbodyReport {
  final String id;
  final DateTime reportDate;
  final double weight;
  final double bodyFatPercent;
  final double muscleMass;
  final double visceralFat;

  InbodyReport({
    required this.id,
    required this.reportDate,
    required this.weight,
    required this.bodyFatPercent,
    required this.muscleMass,
    required this.visceralFat,
  });

  Map<String, dynamic> toMap() => {
        "reportDate": Timestamp.fromDate(reportDate),
        "weight": weight,
        "bodyFatPercent": bodyFatPercent,
        "muscleMass": muscleMass,
        "visceralFat": visceralFat,
      };

  // ✅ 強防禦性解析模式：確保在 Web 平台不因 Null 崩潰
  factory InbodyReport.fromMap(String id, Map<String, dynamic>? map) {
    // 1. 如果 map 本身是 null，回傳一個帶有預設值的物件
    if (map == null) {
      return InbodyReport(
        id: id,
        reportDate: DateTime.now(),
        weight: 0.0,
        bodyFatPercent: 0.0,
        muscleMass: 0.0,
        visceralFat: 0.0,
      );
    }

    // 2. 安全處理日期 (支援 Timestamp, String, 甚至是 null)
    DateTime parseSafeDate(dynamic rawDate) {
      if (rawDate is Timestamp) return rawDate.toDate();
      if (rawDate is String) return DateTime.tryParse(rawDate) ?? DateTime.now();
      return DateTime.now();
    }

    // 3. 安全處理數值 (處理 num, String 轉型及 Null 保護)
    double toSafeDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return InbodyReport(
      id: id,
      reportDate: parseSafeDate(map["reportDate"]),
      weight: toSafeDouble(map["weight"]),
      bodyFatPercent: toSafeDouble(map["bodyFatPercent"]),
      muscleMass: toSafeDouble(map["muscleMass"]),
      visceralFat: toSafeDouble(map["visceralFat"]),
    );
  }
}
