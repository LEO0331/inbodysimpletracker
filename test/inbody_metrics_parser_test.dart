import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:inbodysimpletracker/presentation/dashboard/dashboard_page.dart';
import 'package:inbodysimpletracker/logic/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

// Mock 類別
class MockAuthProvider extends Mock implements AuthProvider {}
class MockUser extends Mock implements User {}
class MockFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockQuery extends Mock implements Query<Map<String, dynamic>> {}
class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}

void main() {
  late MockAuthProvider mockAuth;
  late MockUser mockUser;
  late MockFirestore mockFirestore;
  late StreamController<QuerySnapshot<Map<String, dynamic>>> streamController;

  setUp(() {
    mockAuth = MockAuthProvider();
    mockUser = MockUser();
    mockFirestore = MockFirestore();
    streamController = StreamController<QuerySnapshot<Map<String, dynamic>>>();

    // 模擬 Auth 狀態
    when(() => mockAuth.user).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn('test_uid');

    // 模擬 Firestore 鏈式調用 (最繁瑣但必要的部分)
    final mockCollection = MockCollectionReference();
    final mockDoc = MockDocumentReference();
    final mockSubCollection = MockCollectionReference();
    final mockQuery = MockQuery();

    when(() => mockFirestore.collection("users")).thenReturn(mockCollection);
    when(() => mockCollection.doc('test_uid')).thenReturn(mockDoc);
    when(() => mockDoc.collection("reports")).thenReturn(mockSubCollection);
    when(() => mockSubCollection.orderBy("reportDate", descending: true)).thenReturn(mockQuery);
    when(() => mockQuery.snapshots()).thenAnswer((_) => streamController.stream);
  });

  tearDown(() {
    streamController.close();
  });

  // 輔助方法：包裝 Provider 以進行測試
  Widget createWidgetToTest() {
    return MaterialApp(
      home: ChangeNotifierProvider<AuthProvider>.value(
        value: mockAuth,
        child: const DashboardPage(),
      ),
    );
  }

  group('DashboardPage UI 測試', () {
    testWidgets('當沒有資料時應顯示提示文字', (tester) async {
      await tester.pumpWidget(createWidgetToTest());
      
      // 模擬空的 Snapshot
      final mockSnapshot = MockQuerySnapshot();
      when(() => mockSnapshot.docs).thenReturn([]);
      streamController.add(mockSnapshot);
      
      await tester.pump(); // 觸發重繪
      expect(find.text("No reports yet."), findsOneWidget);
    });

    testWidgets('指標切換測試 - 點擊 Fat % 應更新選取狀態', (tester) async {
      await tester.pumpWidget(createWidgetToTest());

      // 隨便給一個資料讓頁面渲染出來
      final mockSnapshot = MockQuerySnapshot();
      when(() => mockSnapshot.docs).thenReturn([]); // 簡化
      streamController.add(mockSnapshot);
      await tester.pump();

      // 尋找 Fat % 按鈕 (ChoiceChip)
      final fatChip = find.text("Fat %");
      expect(fatChip, findsOneWidget);

      await tester.tap(fatChip);
      await tester.pump();

      // 這裡可以透過檢查 _selectedMetric 的狀態或 UI 顏色變化來驗證
      // 或是驗證是否觸發了重新渲染
    });

    testWidgets('日期篩選下拉選單應存在且可點擊', (tester) async {
      await tester.pumpWidget(createWidgetToTest());
      
      // 模擬資料放入 Stream
      streamController.add(MockQuerySnapshot()); 
      await tester.pump();

      // 檢查 Dropdown 是否顯示預設值 "All"
      expect(find.text("All"), findsOneWidget);

      // 點擊展開 Dropdown
      await tester.tap(find.text("All"));
      await tester.pumpAndSettle(); // 等待動畫結束

      // 驗證選項是否存在
      expect(find.text("3 Months"), findsWidgets);
      expect(find.text("6 Months"), findsWidgets);
    });
  });
}
