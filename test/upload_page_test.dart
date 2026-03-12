import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inbodysimpletracker/presentation/upload/upload_page.dart';
import 'package:inbodysimpletracker/logic/providers/auth_provider.dart';
import 'package:inbodysimpletracker/logic/providers/mqtt_provider.dart';
import 'package:inbodysimpletracker/core/services/file_service.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

class MockAuthProvider extends Mock implements AuthProvider {}
class MockMqttProvider extends Mock implements MqttProvider {}
class MockFileService extends Mock implements FileService {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockUser extends Mock implements User {}

void main() {
  late MockAuthProvider mockAuth;
  late MockMqttProvider mockMqtt;
  late MockFileService mockFileService;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockReportsCollection;
  late MockUser mockUser;

  setUpAll(() {
    registerFallbackValue(Uint8List(0));
  });

  setUp(() {
    mockAuth = MockAuthProvider();
    mockMqtt = MockMqttProvider();
    mockFileService = MockFileService();
    mockFirestore = MockFirebaseFirestore();
    mockReportsCollection = MockCollectionReference();
    mockUser = MockUser();

    when(() => mockAuth.user).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn('uid_123');

    final mockUsersCollection = _MockCollectionReference();
    final mockUserDoc = _MockDocumentReference();
    when(() => mockFirestore.collection('users')).thenReturn(mockUsersCollection);
    when(() => mockUsersCollection.doc('uid_123')).thenReturn(mockUserDoc);
    when(() => mockUserDoc.collection('reports')).thenReturn(mockReportsCollection);
    
    when(() => mockFileService.dispose()).thenAnswer((_) {});
  });

  Widget createWidgetToTest() {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: mockAuth),
          ChangeNotifierProvider<MqttProvider>.value(value: mockMqtt),
        ],
        child: UploadPage(firestore: mockFirestore, fileService: mockFileService),
      ),
    );
  }

  group('UploadPage Comprehensive Tests', () {
    testWidgets('Should handle successful image OCR and auto-save', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final mockOcrText = 'Weight 75.5kg Body Fat 18.2% Muscle Mass 38.0kg';
      when(() => mockFileService.recognizeImage(any(), any())).thenAnswer((_) async => mockOcrText);
      when(() => mockReportsCollection.add(any())).thenAnswer((_) async => _MockDocumentReference());

      await tester.pumpWidget(createWidgetToTest());
      
      final state = tester.state<UploadPageState>(find.byType(UploadPage));
      await state.processImageBytes(Uint8List(10), 'test.jpg');
      
      await tester.pumpAndSettle();

      expect(find.text('The data has been successfully saved to the cloud.'), findsOneWidget);
      verify(() => mockReportsCollection.add(any())).called(1);
    });

    testWidgets('Should handle successful PDF extraction and auto-save', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final mockPdfText = 'Weight 80.0kg Body Fat 20.0% Muscle Mass 40.0kg';
      when(() => mockFileService.extractPdfText(any())).thenAnswer((_) async => mockPdfText);
      when(() => mockReportsCollection.add(any())).thenAnswer((_) async => _MockDocumentReference());

      await tester.pumpWidget(createWidgetToTest());
      
      final state = tester.state<UploadPageState>(find.byType(UploadPage));
      await state.processPdf(Uint8List(10));
      
      await tester.pumpAndSettle();

      expect(find.text('The data has been successfully saved to the cloud.'), findsOneWidget);
      verify(() => mockReportsCollection.add(any())).called(1);
    });

    testWidgets('Should show manual entry if OCR text has no metrics', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      when(() => mockFileService.recognizeImage(any(), any())).thenAnswer((_) async => 'No metrics here');
      
      await tester.pumpWidget(createWidgetToTest());
      
      final state = tester.state<UploadPageState>(find.byType(UploadPage));
      await state.processImageBytes(Uint8List(10), 'test.jpg');
      
      await tester.pumpAndSettle();

      expect(find.text('Manual Input'), findsOneWidget);
    });
  });
}

// Helper mocks
class _MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class _MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
