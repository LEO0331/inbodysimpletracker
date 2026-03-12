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
      expect(find.text('1'), findsOneWidget); // Index indicator
    });

    testWidgets('Should expand to show details and delete button', (tester) async {
      await tester.pumpWidget(createWidgetToTest());

      // Tap to expand
      await tester.tap(find.byType(ExpansionTile));
      await tester.pumpAndSettle();

      expect(find.text('Body Fat %'), findsOneWidget);
      expect(find.text('20.1%'), findsOneWidget);
      expect(find.text('Muscle Mass'), findsOneWidget);
      expect(find.text('40.0 kg'), findsOneWidget);
      expect(find.text('Delete Report'), findsOneWidget);
    });

    testWidgets('Should show delete confirmation dialog and trigger deletion', (tester) async {
      final mockCollection = _MockCollectionReference();
      final mockDoc = _MockDocumentReference();
      final mockSubCollection = _MockCollectionReference();
      final mockReportDoc = _MockDocumentReference();

      when(() => mockFirestore.collection("users")).thenReturn(mockCollection);
      when(() => mockCollection.doc("user_uid_123")).thenReturn(mockDoc);
      when(() => mockDoc.collection("reports")).thenReturn(mockSubCollection);
      when(() => mockSubCollection.doc("report_id_123")).thenReturn(mockReportDoc);
      when(() => mockReportDoc.delete()).thenAnswer((_) async => {});

      await tester.pumpWidget(createWidgetToTest());

      // Expand
      await tester.tap(find.byType(ExpansionTile));
      await tester.pumpAndSettle();

      // Click Delete Report button
      await tester.tap(find.text('Delete Report'));
      await tester.pumpAndSettle();

      expect(find.text('Delete Report'), findsNWidgets(2)); // Title and Button
      expect(find.text('Are you sure you want to delete this report? This action cannot be undone.'), findsOneWidget);

      // Confirm delete
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      verify(() => mockReportDoc.delete()).called(1);
      expect(find.text('Report deleted successfully'), findsOneWidget);
    });
  });
}

class _MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class _MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
