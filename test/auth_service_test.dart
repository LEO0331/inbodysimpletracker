import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inbodysimpletracker/data/services/auth_service.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}

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

      when(() => mockAuth.createUserWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          )).thenAnswer((_) async => mockCredential);
      when(() => mockCredential.user).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn('uid_123');

      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc('uid_123')).thenReturn(mockDoc);
      when(() => mockDoc.set(any())).thenAnswer((_) async => {});

      final user = await authService.signUp('test@example.com', 'password123');

      expect(user, mockUser);
      verify(() => mockDoc.set(any())).called(1);
    });

    test('signIn should call FirebaseAuth signInWithEmailAndPassword', () async {
      final mockCredential = MockUserCredential();
      when(() => mockAuth.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          )).thenAnswer((_) async => mockCredential);
      when(() => mockCredential.user).thenReturn(mockUser);

      final user = await authService.signIn('test@example.com', 'password123');

      expect(user, mockUser);
    });

    test('isAdmin should return true for admin role', () async {
      final mockCollection = MockCollectionReference();
      final mockDoc = MockDocumentReference();
      final mockSnapshot = MockDocumentSnapshot();

      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn('uid_123');
      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc('uid_123')).thenReturn(mockDoc);
      when(() => mockDoc.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.data()).thenReturn({'role': 'admin'});

      final isAdmin = await authService.isAdmin();

      expect(isAdmin, isTrue);
    });

    test('signOut should call FirebaseAuth signOut', () async {
      when(() => mockAuth.signOut()).thenAnswer((_) async => {});
      await authService.signOut();
      verify(() => mockAuth.signOut()).called(1);
    });
  });
}
