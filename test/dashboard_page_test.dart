import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inbodysimpletracker/presentation/dashboard/dashboard_page.dart';
import 'package:inbodysimpletracker/logic/providers/auth_provider.dart';
import 'package:inbodysimpletracker/logic/providers/mqtt_provider.dart';
import 'package:inbodysimpletracker/data/models/inbody_report.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

class MockAuthProvider extends Mock implements AuthProvider {}
class MockMqttProvider extends Mock implements MqttProvider {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}
class MockUser extends Mock implements User {}

void main() {
  late MockAuthProvider mockAuth;
  late MockMqttProvider mockMqtt;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockUsersCollection;
  late MockDocumentReference mockUserDoc;
  late MockCollectionReference mockReportsCollection;
  late MockQuerySnapshot mockSnapshot;
  late MockUser mockUser;
  late StreamController<QuerySnapshot<Map<String, dynamic>>> streamController;

  setUpAll(() {
    registerFallbackValue(const Duration(days: 90));
  });

  setUp(() {
    mockAuth = MockAuthProvider();
    mockMqtt = MockMqttProvider();
    mockFirestore = MockFirebaseFirestore();
    mockUsersCollection = MockCollectionReference();
    mockUserDoc = MockDocumentReference();
    mockReportsCollection = MockCollectionReference();
    mockSnapshot = MockQuerySnapshot();
    mockUser = MockUser();
    streamController = StreamController<QuerySnapshot<Map<String, dynamic>>>();

    when(() => mockAuth.user).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn('test_uid');
    when(() => mockMqtt.isConnected).thenReturn(false);
    when(() => mockMqtt.isLoading).thenReturn(false);
    when(() => mockMqtt.mqttReports).thenReturn([]);
    when(() => mockMqtt.initMqtt(any())).thenAnswer((_) async {});

    // Firestore structure
    when(() => mockFirestore.collection("users")).thenReturn(mockUsersCollection);
    when(() => mockUsersCollection.doc("test_uid")).thenReturn(mockUserDoc);
    when(() => mockUserDoc.collection("reports")).thenReturn(mockReportsCollection);
    when(() => mockReportsCollection.orderBy("reportDate", descending: true)).thenReturn(mockReportsCollection);
    when(() => mockReportsCollection.snapshots()).thenAnswer((_) => streamController.stream);
    
    when(() => mockSnapshot.docs).thenReturn([]);
  });

  tearDown(() {
    streamController.close();
  });

  Widget createWidgetToTest() {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: mockAuth),
          ChangeNotifierProvider<MqttProvider>.value(value: mockMqtt),
        ],
        child: DashboardPage(firestore: mockFirestore),
      ),
    );
  }

  group('DashboardPage Widget Tests', () {
    testWidgets('Should show "No history reports yet." when list is empty', (tester) async {
      await tester.pumpWidget(createWidgetToTest());
      
      streamController.add(mockSnapshot);
      await (tester as WidgetTester).pumpAndSettle();

      expect(find.text('No history reports yet.'), findsOneWidget);
    });

    testWidgets('Should handle full analysis dialog', (tester) async {
      await tester.pumpWidget(createWidgetToTest());
      
      streamController.add(mockSnapshot);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Full Analysis'));
      await tester.pumpAndSettle();

      expect(find.text('Combined Trend Analysis'), findsOneWidget);
      await tester.tap(find.byType(IconButton).first);
      await tester.pumpAndSettle();
      
      expect(find.text('Combined Trend Analysis'), findsNothing);
    });

    testWidgets('Should show MQTT live section when reports exist', (tester) async {
      final mockLiveReport = InbodyReport(
        id: 'mqtt_1',
        reportDate: DateTime.now(),
        weight: 70.0,
        bodyFatPercent: 15.0,
        muscleMass: 35.0,
        visceralFat: 5,
      );
      
      when(() => mockMqtt.mqttReports).thenReturn([mockLiveReport]);
      when(() => mockMqtt.isConnected).thenReturn(true);

      await tester.pumpWidget(createWidgetToTest());
      
      streamController.add(mockSnapshot);
      await tester.pumpAndSettle();

      expect(find.text('📡 Live MQTT Data (Recent Scan)'), findsOneWidget);
      expect(find.text('MQTT Live'), findsOneWidget);
    });

    testWidgets('Should handle metric chip selection', (tester) async {
      await tester.pumpWidget(createWidgetToTest());
      
      streamController.add(mockSnapshot);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Fat %'));
      await tester.pumpAndSettle();

      final fatChip = tester.widget<ChoiceChip>(find.byWidgetPredicate((w) => w is ChoiceChip && (w.label as Text).data == 'Fat %'));
      expect(fatChip.selected, isTrue);
    });
  });
}
