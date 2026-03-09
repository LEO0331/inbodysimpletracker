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

  // ✅ 修正：將 DateTime 轉換為 Firestore 的 Timestamp 儲存
  Map<String, dynamic> toMap() => {
        "reportDate": Timestamp.fromDate(reportDate), 
        "weight": weight,
        "bodyFatPercent": bodyFatPercent,
        "muscleMass": muscleMass,
        "visceralFat": visceralFat,
      };

  // ✅ 修正：支援從 Timestamp 或 String 讀取日期，並處理數值轉型
  factory InbodyReport.fromMap(String id, Map<String, dynamic> map) {
    // 1. 安全處理日期 (支援 Timestamp 與 String)
    DateTime parsedDate;
    var rawDate = map["reportDate"];
    if (rawDate is Timestamp) {
      parsedDate = rawDate.toDate();
    } else if (rawDate is String) {
      parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    // 2. 安全處理數值 (確保 int 能轉為 double)
    double toDouble(dynamic value) {
      if (value is num) return value.toDouble();
      return 0.0;
    }

    return InbodyReport(
      id: id,
      reportDate: parsedDate,
      weight: toDouble(map["weight"]),
      bodyFatPercent: toDouble(map["bodyFatPercent"]),
      muscleMass: toDouble(map["muscleMass"]),
      visceralFat: toDouble(map["visceralFat"]),
    );
  }
}
