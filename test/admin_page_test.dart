import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inbodysimpletracker/presentation/admin/admin_page.dart';
import 'package:inbodysimpletracker/logic/providers/auth_provider.dart';

class MockAuthProvider extends Mock implements AuthProvider {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {}

void main() {
  late MockAuthProvider mockAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockUsersCollection;
  late MockDocumentReference mockUserDoc;
  late MockCollectionReference mockReportsCollection;
  late MockQuerySnapshot mockSnapshot;
  late StreamController<QuerySnapshot<Map<String, dynamic>>> streamController;

  setUp(() {
    mockAuth = MockAuthProvider();
    mockFirestore = MockFirebaseFirestore();
    mockUsersCollection = MockCollectionReference();
    mockUserDoc = MockDocumentReference();
    mockReportsCollection = MockCollectionReference();
    mockSnapshot = MockQuerySnapshot();
    streamController = StreamController<QuerySnapshot<Map<String, dynamic>>>();

    when(() => mockAuth.isAdmin).thenReturn(true);
    when(() => mockFirestore.collection("users")).thenReturn(mockUsersCollection);
    when(() => mockUsersCollection.snapshots()).thenAnswer((_) => streamController.stream);
    
    // Setup the doc and subcollection access
    when(() => mockUsersCollection.doc(any())).thenReturn(mockUserDoc);
    when(() => mockUserDoc.collection("reports")).thenReturn(mockReportsCollection);
    when(() => mockReportsCollection.orderBy("reportDate", descending: true)).thenReturn(mockReportsCollection);
    when(() => mockReportsCollection.snapshots()).thenAnswer((_) => const Stream.empty());

    when(() => mockSnapshot.docs).thenReturn([]);
  });

  tearDown(() {
    streamController.close();
  });

  Widget createWidgetToTest() {
    return MaterialApp(
      home: ChangeNotifierProvider<AuthProvider>.value(
        value: mockAuth,
        child: AdminPage(firestore: mockFirestore),
      ),
    );
  }

  group('AdminPage Widget Tests', () {
    testWidgets('Should redirect if not admin', (tester) async {
      when(() => mockAuth.isAdmin).thenReturn(false);
      await tester.pumpWidget(createWidgetToTest());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Should display user list from Firestore', (tester) async {
      final mockQueryDoc = MockQueryDocumentSnapshot();
      final mockData = {'email': 'user@test.com', 'role': 'user'};
      
      when(() => mockQueryDoc.data()).thenReturn(mockData);
      when(() => mockQueryDoc.id).thenReturn('uid_123');
      when(() => mockSnapshot.docs).thenReturn([mockQueryDoc]);

      await tester.pumpWidget(createWidgetToTest());
      
      streamController.add(mockSnapshot);
      await tester.pump();
      await tester.pump();

      expect(find.text('user@test.com'), findsOneWidget);
      expect(find.textContaining('Role: user'), findsOneWidget);
    });
  });
}
