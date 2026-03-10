import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inbodysimpletracker/data/models/inbody_report.dart';

void main() {
  group('InbodyReport Model 測試', () {
    const String mockId = 'test_report_id';

    test('toMap 應正確轉換為 Map', () {
      final date = DateTime(2024, 1, 1);
      final report = InbodyReport(
        id: mockId,
        reportDate: date,
        weight: 70.5,
        bodyFatPercent: 15.2,
        muscleMass: 35.0,
        visceralFat: 5.0,
      );

      final map = report.toMap();

      expect(map['weight'], 70.5);
      expect(map['reportDate'], isA<Timestamp>());
      expect((map['reportDate'] as Timestamp).toDate(), date);
    });

    test('fromMap 應正確解析標準 Firestore 數據', () {
      final timestamp = Timestamp.now();
      final Map<String, dynamic> mockMap = {
        "reportDate": timestamp,
        "weight": 75.2,
        "bodyFatPercent": 18.5,
        "muscleMass": 33.1,
        "visceralFat": 7,
      };

      final report = InbodyReport.fromMap(mockId, mockMap);

      expect(report.id, mockId);
      expect(report.weight, 75.2);
      expect(report.visceralFat, 7.0); // 測試 int 是否能轉為 double
      expect(report.reportDate, timestamp.toDate());
    });

    test('fromMap 處理 Null 數據應回傳預設值', () {
      final report = InbodyReport.fromMap(mockId, null);

      expect(report.id, mockId);
      expect(report.weight, 0.0);
      expect(report.reportDate, isA<DateTime>());
    });

    test('fromMap 處理欄位缺失或 Null 欄位應展現防禦性', () {
      final Map<String, dynamic> incompleteMap = {
        "weight": null,
        "bodyFatPercent": "20.5", // 測試字串格式解析
        // 缺少 muscleMass 與 visceralFat
      };

      final report = InbodyReport.fromMap(mockId, incompleteMap);

      expect(report.weight, 0.0);
      expect(report.bodyFatPercent, 20.5); // 驗證 String to Double 成功
      expect(report.muscleMass, 0.0);
      expect(report.visceralFat, 0.0);
    });

    test('fromMap 處理異常日期格式 (String) 應解析成功', () {
      final Map<String, dynamic> dateStringMap = {
        "reportDate": "2024-05-20",
        "weight": 60.0,
      };

      final report = InbodyReport.fromMap(mockId, dateStringMap);

      expect(report.reportDate.year, 2024);
      expect(report.reportDate.month, 5);
      expect(report.reportDate.day, 20);
    });

    test('fromMap 遇到完全錯誤的資料類型應回傳 0.0 而非崩潰', () {
      final Map<String, dynamic> garbageMap = {
        "weight": ["not", "a", "number"],
        "visceralFat": {"key": "value"},
      };

      final report = InbodyReport.fromMap(mockId, garbageMap);

      expect(report.weight, 0.0);
      expect(report.visceralFat, 0.0);
    });
  });
}
