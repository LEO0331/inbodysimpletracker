import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inbodysimpletracker/data/services/firestore_service.dart';
import 'package:inbodysimpletracker/data/models/inbody_report.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}
class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {}

void main() {
  late MockFirebaseFirestore mockFirestore;
  late FirestoreService firestoreService;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    firestoreService = FirestoreService(db: mockFirestore);
  });

  group('FirestoreService Unit Tests', () {
    test('addReport should add data to the correct subcollection', () async {
      final mockUsersCollection = MockCollectionReference();
      final mockUserDoc = MockDocumentReference();
      final mockReportsCollection = MockCollectionReference();
      final report = InbodyReport(
        id: '',
        reportDate: DateTime.now(),
        weight: 70.0,
        bodyFatPercent: 15.0,
        muscleMass: 35.0,
        visceralFat: 5,
      );

      when(() => mockFirestore.collection("users")).thenReturn(mockUsersCollection);
      when(() => mockUsersCollection.doc("uid_123")).thenReturn(mockUserDoc);
      when(() => mockUserDoc.collection("reports")).thenReturn(mockReportsCollection);
      when(() => mockReportsCollection.add(any())).thenAnswer((_) async => MockDocumentReference());

      await firestoreService.addReport("uid_123", report);

      verify(() => mockReportsCollection.add(any())).called(1);
    });

    test('getReports should return a stream of InbodyReport lists', () async {
      final mockUsersCollection = MockCollectionReference();
      final mockUserDoc = MockDocumentReference();
      final mockReportsCollection = MockCollectionReference();
      final mockQuery = MockCollectionReference(); // Mocking ordered query as collection ref for simplicity
      final mockSnapshot = MockQuerySnapshot();
      final mockDocSnapshot = MockQueryDocumentSnapshot();

      final reportData = {
        'reportDate': '2023-10-27T10:00:00.000',
        'weight': 70.0,
        'bodyFatPercent': 15.0,
        'muscleMass': 35.0,
        'visceralFat': 5.0,
      };

      when(() => mockFirestore.collection("users")).thenReturn(mockUsersCollection);
      when(() => mockUsersCollection.doc("uid_123")).thenReturn(mockUserDoc);
      when(() => mockUserDoc.collection("reports")).thenReturn(mockReportsCollection);
      when(() => mockReportsCollection.orderBy("reportDate", descending: true)).thenReturn(mockQuery);
      when(() => mockQuery.snapshots()).thenAnswer((_) => Stream.value(mockSnapshot));
      when(() => mockSnapshot.docs).thenReturn([mockDocSnapshot]);
      when(() => mockDocSnapshot.id).thenReturn('doc_id_123');
      when(() => mockDocSnapshot.data()).thenReturn(reportData);

      final resultStream = firestoreService.getReports("uid_123");
      final reports = await resultStream.first;

      expect(reports.length, 1);
      expect(reports[0].id, 'doc_id_123');
      expect(reports[0].weight, 70.0);
    });
  });
}
