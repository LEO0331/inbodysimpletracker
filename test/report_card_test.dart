import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inbodysimpletracker/presentation/dashboard/report_card.dart';
import 'package:inbodysimpletracker/data/models/inbody_report.dart';
import 'package:inbodysimpletracker/logic/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

class MockAuthProvider extends Mock implements AuthProvider {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockUser extends Mock implements User {}

void main() {
  late MockAuthProvider mockAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockUser mockUser;
  late InbodyReport sampleReport;

  setUp(() {
    mockAuth = MockAuthProvider();
    mockFirestore = MockFirebaseFirestore();
    mockUser = MockUser();
    
    sampleReport = InbodyReport(
      id: 'report_id_123',
      reportDate: DateTime(2023, 10, 27),
      weight: 80.5,
      bodyFatPercent: 20.1,
      muscleMass: 40.0,
      visceralFat: 8,
    );

    when(() => mockAuth.user).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn('user_uid_123');
  });

  Widget createWidgetToTest() {
    return MaterialApp(
      home: Scaffold(
        body: ChangeNotifierProvider<AuthProvider>.value(
          value: mockAuth,
          child: ReportCard(
            report: sampleReport,
            index: 1,
            firestore: mockFirestore,
          ),
        ),
      ),
    );
  }

  group('ReportCard Widget Tests', () {
    testWidgets('Should render report summary data', (tester) async {
       await tester.pumpWidget(createWidgetToTest());
       expect(find.text('Oct 27, 2023'), findsOneWidget);
       expect(find.text('Weight: 80.5 kg'), findsOneWidget);
    });

    testWidgets('Should expand and show details', (tester) async {
       await tester.pumpWidget(createWidgetToTest());
       await tester.tap(find.byType(ExpansionTile));
       await tester.pumpAndSettle();
       expect(find.text('20.1%'), findsOneWidget);
       expect(find.text('Delete Report'), findsOneWidget);
    });

    testWidgets('Should handle deletion error', (tester) async {
      final mockCollection = MockCollectionReference();
      final mockDoc = MockDocumentReference();
      final mockSubCollection = MockCollectionReference();
      final mockReportDoc = MockDocumentReference();

      when(() => mockFirestore.collection("users")).thenReturn(mockCollection);
      when(() => mockCollection.doc("user_uid_123")).thenReturn(mockDoc);
      when(() => mockDoc.collection("reports")).thenReturn(mockSubCollection);
      when(() => mockSubCollection.doc("report_id_123")).thenReturn(mockReportDoc);
      
      when(() => mockReportDoc.delete()).thenThrow(Exception("Firebase Error"));

      await tester.pumpWidget(createWidgetToTest());
      await tester.tap(find.byType(ExpansionTile));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete Report'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Error deleting report'), findsOneWidget);
    });
  });
}
