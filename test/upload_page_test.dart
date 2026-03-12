import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inbodysimpletracker/presentation/upload/upload_page.dart';
import 'package:inbodysimpletracker/logic/providers/auth_provider.dart';
import 'package:inbodysimpletracker/logic/providers/mqtt_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

class MockAuthProvider extends Mock implements AuthProvider {}
class MockMqttProvider extends Mock implements MqttProvider {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockUser extends Mock implements User {}

void main() {
  late MockAuthProvider mockAuth;
  late MockMqttProvider mockMqtt;
  late MockFirebaseFirestore mockFirestore;
  late MockUser mockUser;
  late MockCollectionReference mockUsersCollection;
  late MockDocumentReference mockUserDoc;
  late MockCollectionReference mockReportsCollection;

  setUp(() {
    mockAuth = MockAuthProvider();
    mockMqtt = MockMqttProvider();
    mockFirestore = MockFirebaseFirestore();
    mockUser = MockUser();
    mockUsersCollection = MockCollectionReference();
    mockUserDoc = MockDocumentReference();
    mockReportsCollection = MockCollectionReference();

    when(() => mockAuth.user).thenReturn(mockUser);
    when(() => mockUser.email).thenReturn('test@example.com');
    when(() => mockUser.uid).thenReturn('uid_123');

    // Setup basic Firestore mocks
    when(() => mockFirestore.collection("users")).thenReturn(mockUsersCollection);
    when(() => mockUsersCollection.doc(any())).thenReturn(mockUserDoc);
    when(() => mockUserDoc.collection("reports")).thenReturn(mockReportsCollection);
  });

  Widget createWidgetToTest() {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: mockAuth),
          ChangeNotifierProvider<MqttProvider>.value(value: mockMqtt),
        ],
        child: UploadPage(firestore: mockFirestore),
      ),
    );
  }

  group('UploadPage Widget Tests', () {
    testWidgets('Should render upload options', (tester) async {
      await tester.pumpWidget(createWidgetToTest());

      expect(find.text('InBody Report Analysis'), findsOneWidget);
      expect(find.text('Upload Image / PDF'), findsOneWidget);
      expect(find.text('Manual Entry'), findsOneWidget);
      expect(find.byIcon(Icons.dashboard), findsOneWidget);
    });

    testWidgets('Should show manual entry dialog and accept input', (tester) async {
      when(() => mockReportsCollection.add(any())).thenAnswer((_) async => mockUserDoc);

      await tester.pumpWidget(createWidgetToTest());

      await tester.tap(find.text('Manual Entry'));
      await tester.pumpAndSettle();

      expect(find.text('Manual Input'), findsOneWidget);
      
      await tester.enterText(find.byType(TextField).at(0), '75.5');
      await tester.enterText(find.byType(TextField).at(1), '18.2');
      await tester.enterText(find.byType(TextField).at(2), '38.0');

      await tester.tap(find.text('confirm'));
      await tester.pumpAndSettle();

      expect(find.text('Manual Input'), findsNothing);
      verify(() => mockReportsCollection.add(any())).called(1);
    });
  });
}
