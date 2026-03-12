import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:inbodysimpletracker/presentation/auth/signup_page.dart';
import 'package:inbodysimpletracker/logic/providers/auth_provider.dart';

class MockAuthProvider extends Mock implements AuthProvider {}

void main() {
  late MockAuthProvider mockAuth;

  setUp(() {
    mockAuth = MockAuthProvider();

    when(() => mockAuth.isLoading).thenReturn(false);
    when(() => mockAuth.isAuthenticated).thenReturn(false);
    when(() => mockAuth.errorMessage).thenReturn(null);
  });

  Widget createWidgetToTest() {
    return MaterialApp(
      home: ChangeNotifierProvider<AuthProvider>.value(
        value: mockAuth,
        child: const SignupPage(),
      ),
    );
  }

  group('SignupPage Widget Tests', () {
    testWidgets('Should render signup fields and buttons', (tester) async {
      await tester.pumpWidget(createWidgetToTest());

      expect(find.text('Sign Up'), findsWidgets);
      expect(find.text('Create Account'), findsWidgets);
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
    });

    testWidgets('Should show validation errors for empty fields', (tester) async {
      await tester.pumpWidget(createWidgetToTest());

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter a password'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
    });

    testWidgets('Should show error if passwords do not match', (tester) async {
      await tester.pumpWidget(createWidgetToTest());

      await tester.enterText(find.byType(TextFormField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.enterText(find.byType(TextFormField).at(2), 'password456');

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('Should call signup on AuthProvider when form is valid', (tester) async {
      when(() => mockAuth.signup(any(), any())).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetToTest());

      await tester.enterText(find.byType(TextFormField).at(0), 'new@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.enterText(find.byType(TextFormField).at(2), 'password123');

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      verify(() => mockAuth.signup('new@example.com', 'password123')).called(1);
    });

    testWidgets('Should display error message from provider', (tester) async {
      when(() => mockAuth.errorMessage).thenReturn('Email already in use');

      await tester.pumpWidget(createWidgetToTest());

      expect(find.text('Email already in use'), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);
    });

    testWidgets('Should show loading state', (tester) async {
      when(() => mockAuth.isLoading).thenReturn(true);

      await tester.pumpWidget(createWidgetToTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
