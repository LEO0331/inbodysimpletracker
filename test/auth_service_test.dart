// ignore_for_file: subtype_of_sealed_class

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inbodysimpletracker/data/services/auth_service.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockIdTokenResult extends Mock implements IdTokenResult {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

void main() {
  late MockFirebaseAuth mockAuth;
  late MockFirebaseFirestore mockFirestore;
  late AuthService authService;
  late MockUser mockUser;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    authService = AuthService(auth: mockAuth, db: mockFirestore);
    mockUser = MockUser();
  });

  group('AuthService Unit Tests', () {
    test('signUp should create user and set firestore document', () async {
      final mockCredential = MockUserCredential();
      final mockCollection = MockCollectionReference();
      final mockDoc = MockDocumentReference();

      when(
        () => mockAuth.createUserWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        ),
      ).thenAnswer((_) async => mockCredential);
      when(() => mockCredential.user).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn('uid_123');
      when(() => mockUser.email).thenReturn('test@example.com');

      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc('uid_123')).thenReturn(mockDoc);
      when(() => mockDoc.set(any())).thenAnswer((_) async => {});

      final user = await authService.signUp('test@example.com', 'password123');

      expect(user, mockUser);
      verify(() => mockDoc.set(any())).called(1);
    });

    test(
      'signIn should call FirebaseAuth signInWithEmailAndPassword',
      () async {
        final mockCredential = MockUserCredential();
        when(
          () => mockAuth.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          ),
        ).thenAnswer((_) async => mockCredential);
        when(() => mockCredential.user).thenReturn(mockUser);
        when(() => mockUser.uid).thenReturn('uid_123');

        final user = await authService.signIn(
          'test@example.com',
          'password123',
        );

        expect(user, mockUser);
      },
    );

    test('isAdmin should require an admin token claim', () async {
      final token = MockIdTokenResult();
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.getIdTokenResult()).thenAnswer((_) async => token);

      when(() => token.claims).thenReturn({'role': 'admin'});
      expect(await authService.isAdmin(), isTrue);
      when(() => token.claims).thenReturn({'role': 'user'});
      expect(await authService.isAdmin(), isFalse);
      when(() => token.claims).thenReturn({});
      expect(await authService.isAdmin(), isFalse);
      verifyZeroInteractions(mockFirestore);
    });

    test('signOut should call FirebaseAuth signOut', () async {
      when(() => mockAuth.signOut()).thenAnswer((_) async => {});
      await authService.signOut();
      verify(() => mockAuth.signOut()).called(1);
    });
  });
}
