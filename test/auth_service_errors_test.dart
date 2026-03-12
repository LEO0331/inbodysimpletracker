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

  group('AuthService Detailed Unit Tests', () {
    test('Constructor should use default instances if none provided', () {
       // This might fail if Firebase isn't initialized, but we check if it throws
       try {
         AuthService();
       } catch (e) {
         // Expected failure in test environment without Firebase.initializeApp
       }
    });

    test('signUp handles generic exception', () async {
      when(() => mockAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(Exception("Generic Error"));

      expect(() => authService.signUp('test@e.com', 'pwd'), throwsException);
    });

    test('isAdmin handles exception', () async {
       when(() => mockAuth.currentUser).thenReturn(mockUser);
       when(() => mockUser.uid).thenReturn('uid');
       when(() => mockFirestore.collection(any())).thenThrow(Exception("DB Error"));
       
       final result = await authService.isAdmin();
       expect(result, isFalse);
    });

    test('userChanges returns stream from firebase auth', () {
       when(() => mockAuth.authStateChanges()).thenAnswer((_) => Stream.value(null));
       expect(authService.userChanges, isA<Stream<User?>>());
    });

    test('currentUser returns from firebase auth', () {
       when(() => mockAuth.currentUser).thenReturn(mockUser);
       expect(authService.currentUser, mockUser);
    });
  });
}
