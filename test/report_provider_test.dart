import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:inbodysimpletracker/logic/providers/report_provider.dart';
import 'package:inbodysimpletracker/data/services/firestore_service.dart';
import 'package:inbodysimpletracker/data/models/inbody_report.dart';

// 建立 Mock 類別
class MockFirestoreService extends Mock implements FirestoreService {}

void main() {
  late MockFirestoreService mockFirestoreService;
  late ReportProvider reportProvider;
  late StreamController<List<InbodyReport>> reportStreamController;

  // 準備假數據
  final mockReport = InbodyReport(
    id: '1',
    reportDate: DateTime.now(),
    weight: 70.0,
    bodyFatPercent: 15.0,
    muscleMass: 35.0,
    visceralFat: 5.0,
  );

  setUp(() {
    mockFirestoreService = MockFirestoreService();
    reportStreamController = StreamController<List<InbodyReport>>();
    reportProvider = ReportProvider(firestoreService: mockFirestoreService);
  });

  tearDown(() {
    reportStreamController.close();
  });

  group('ReportProvider 測試', () {
    test('初始狀態下報告列表應為空', () {
      expect(reportProvider.reports, isEmpty);
    });

    test('listenReports 應能接收 Stream 數據並更新列表', () async {
      const String uid = 'user123';
      
      // 1. 模擬 Service 的 getReports 回傳一個 Stream
      when(() => mockFirestoreService.getReports(uid))
          .thenAnswer((_) => reportStreamController.stream);

      // 2. 開始監聽
      reportProvider.listenReports(uid);

      // 3. 往 Stream 丟入假數據
      reportStreamController.add([mockReport]);

      // 等待非同步通知觸發
      await Future.delayed(Duration.zero);

      // 4. 驗證 Provider 狀態是否更新
      expect(reportProvider.reports.length, 1);
      expect(reportProvider.reports.first.weight, 70.0);
    });

    test('addReport 應正確調用 Service 的新增方法', () async {
      const String uid = 'user123';
      
      // 模擬 addReport 為一個成功的 Future
      when(() => mockFirestoreService.addReport(uid, mockReport))
          .thenAnswer((_) async => {});

      // 執行新增
      await reportProvider.addReport(uid, mockReport);

      // 驗證 Service 是否被正確呼叫過一次
      verify(() => mockFirestoreService.addReport(uid, mockReport)).called(1);
    });
  });
}
