import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:inbodysimpletracker/logic/providers/auth_provider.dart';
import 'package:inbodysimpletracker/data/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}
class MockUser extends Mock implements User {}

void main() {
  late MockAuthService mockAuthService;
  late AuthProvider authProvider;
  late StreamController<User?> userStreamController;
  late MockUser mockUser;

  setUp(() {
    mockAuthService = MockAuthService();
    mockUser = MockUser();
    userStreamController = StreamController<User?>();

    when(() => mockUser.email).thenReturn('test@example.com');
    when(() => mockUser.uid).thenReturn('uid_123');

    when(() => mockAuthService.userChanges).thenAnswer((_) => userStreamController.stream);
    when(() => mockAuthService.currentUser).thenReturn(null);

    authProvider = AuthProvider(authService: mockAuthService);
  });

  tearDown(() {
    userStreamController.close();
  });

  group('AuthProvider Tests', () {
    test('Initial state should be loading and not authenticated', () {
      expect(authProvider.isLoading, isTrue);
      expect(authProvider.isAuthenticated, isFalse);
    });

    test('login success should update state and check admin', () async {
      when(() => mockAuthService.signIn(any(), any())).thenAnswer((_) async => mockUser);
      when(() => mockAuthService.isAdmin()).thenAnswer((_) async => true);
      
      await authProvider.login('test@example.com', 'password');
      
      userStreamController.add(mockUser);
      await Future.delayed(Duration.zero);

      expect(authProvider.isAuthenticated, isTrue);
      expect(authProvider.isAdmin, isTrue);
      expect(authProvider.isLoading, isFalse);
    });

    test('login failure with invalid email', () async {
      when(() => mockAuthService.signIn(any(), any()))
          .thenThrow(FirebaseAuthException(code: 'invalid-email'));

      await authProvider.login('bad-email', 'password');

      expect(authProvider.errorMessage, equals('Invalid email address.'));
      expect(authProvider.isLoading, isFalse);
    });

    test('login failure with user not found', () async {
      when(() => mockAuthService.signIn(any(), any()))
          .thenThrow(FirebaseAuthException(code: 'user-not-found'));

      await authProvider.login('none@test.com', 'password');

      expect(authProvider.errorMessage, equals('No account found with this email address.'));
    });

    test('signup failure with email already in use', () async {
      when(() => mockAuthService.signUp(any(), any()))
          .thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

      await authProvider.signup('used@test.com', 'password');

      expect(authProvider.errorMessage, equals('An account with this email already exists.'));
    });

    test('logout should clear user and reset admin', () async {
      // Setup authenticated state
      when(() => mockAuthService.isAdmin()).thenAnswer((_) async => true);
      userStreamController.add(mockUser);
      await Future.delayed(Duration.zero);
      expect(authProvider.isAuthenticated, isTrue);

      when(() => mockAuthService.signOut()).thenAnswer((_) async => {});
      await authProvider.logout();
      
      userStreamController.add(null);
      await Future.delayed(Duration.zero);

      expect(authProvider.isAuthenticated, isFalse);
      expect(authProvider.isAdmin, isFalse);
    });

    test('clearError should reset error message', () {
      authProvider.clearError();
      expect(authProvider.errorMessage, isNull);
    });
  });
}
