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

  group('AuthProvider Extensive Coverage Fixed', () {
    test('Validation: empty login', () async {
      await authProvider.login('', '');
      expect(authProvider.errorMessage, contains('cannot be empty'));
    });

    test('Validation: short password in signup', () async {
      await authProvider.signup('t@e.com', '123');
      expect(authProvider.errorMessage, contains('at least 6 characters'));
    });

    test('Validation: invalid email in signup', () async {
      await authProvider.signup('invalidemail', 'password123');
      expect(authProvider.errorMessage, contains('valid email address'));
    });

    test('Error in isAdmin check during login', () async {
       when(() => mockAuthService.isAdmin()).thenThrow(Exception("DB error"));
       userStreamController.add(mockUser);
       await Future.delayed(Duration.zero);
       expect(authProvider.errorMessage, equals("Error loading user data"));
    });

    test('Generic login failure', () async {
      when(() => mockAuthService.signIn(any(), any())).thenThrow(Exception("Specific Login Fail"));
      await authProvider.login('t@e.com', 'pwd123');
      expect(authProvider.errorMessage, equals('Specific Login Fail'));
    });

    test('Generic signup failure', () async {
      when(() => mockAuthService.signUp(any(), any())).thenThrow(Exception("Specific Signup Fail"));
      await authProvider.signup('t@e.com', 'password123');
      expect(authProvider.errorMessage, equals('Specific Signup Fail'));
    });

    test('Logout failure', () async {
      when(() => mockAuthService.signOut()).thenThrow(Exception("Signout error"));
      await authProvider.logout();
      expect(authProvider.errorMessage, equals('Signout error'));
    });
  });
}
