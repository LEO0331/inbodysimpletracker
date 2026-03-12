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
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}
class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {}

void main() {
  late MockAuthProvider mockAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference usersCollection;
  late MockCollectionReference reportsCollection;
  late MockQuerySnapshot usersSnapshot;
  late MockQuerySnapshot reportsSnapshot;
  late MockQueryDocumentSnapshot userDoc;
  late MockQueryDocumentSnapshot reportDoc;

  setUp(() {
    mockAuth = MockAuthProvider();
    mockFirestore = MockFirebaseFirestore();
    usersCollection = MockCollectionReference();
    reportsCollection = MockCollectionReference();
    usersSnapshot = MockQuerySnapshot();
    reportsSnapshot = MockQuerySnapshot();
    userDoc = MockQueryDocumentSnapshot();
    reportDoc = MockQueryDocumentSnapshot();

    when(() => mockAuth.isAdmin).thenReturn(true);
    when(() => mockAuth.isAuthenticated).thenReturn(true);
    when(() => mockFirestore.collection("users")).thenReturn(usersCollection);
    when(() => usersCollection.snapshots()).thenAnswer((_) => Stream.value(usersSnapshot));
    
    // Mock user details
    when(() => usersSnapshot.docs).thenReturn([userDoc]);
    when(() => userDoc.id).thenReturn('user_123');
    when(() => userDoc.data()).thenReturn({'email': 'test@user.com', 'role': 'user'});

    // Mock reports collection
    final userDocRef = MockDocumentReference();
    when(() => usersCollection.doc('user_123')).thenReturn(userDocRef);
    when(() => userDocRef.collection('reports')).thenReturn(reportsCollection);
    when(() => reportsCollection.orderBy('reportDate', descending: true)).thenReturn(reportsCollection);
    when(() => reportsCollection.snapshots()).thenAnswer((_) => Stream.value(reportsSnapshot));
    
    // Mock report details
    when(() => reportsSnapshot.docs).thenReturn([reportDoc]);
    when(() => reportDoc.id).thenReturn('report_456');
    when(() => reportDoc.data()).thenReturn({
      'reportDate': Timestamp.now(),
      'weight': 70.0,
      'bodyFatPercent': 15.0,
      'muscleMass': 35.0
    });
  });

  testWidgets('AdminPage renders users and reports', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ChangeNotifierProvider<AuthProvider>.value(
        value: mockAuth,
        child: AdminPage(firestore: mockFirestore),
      ),
    ));
    await tester.pump();
    
    expect(find.text('Admin Management'), findsOneWidget);
    expect(find.text('test@user.com'), findsOneWidget);
    
    // Expand the tile to show reports
    await tester.tap(find.byType(ExpansionTile));
    await tester.pumpAndSettle();
    
    expect(find.textContaining('W: 70.0'), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);
  });
}
