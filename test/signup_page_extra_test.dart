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

  Widget createTestWidget() {
    return MaterialApp(
      home: ChangeNotifierProvider<AuthProvider>.value(
        value: mockAuth,
        child: const SignupPage(),
      ),
    );
  }

  group('SignupPage Extra Coverage', () {
    testWidgets('Shows error if passwords do not match', (tester) async {
       tester.view.physicalSize = const Size(1200, 1600);
       addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createTestWidget());
      
      await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'test@e.com');
      await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password123');
      await tester.enterText(find.widgetWithText(TextFormField, 'Confirm Password'), 'different');
      
      final createBtn = find.widgetWithText(ElevatedButton, 'Create Account');
      await tester.ensureVisible(createBtn);
      await tester.tap(createBtn);
      await tester.pumpAndSettle();
      
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('Shows error from provider', (tester) async {
       tester.view.physicalSize = const Size(1200, 1600);
       addTearDown(() => tester.view.resetPhysicalSize());

      when(() => mockAuth.errorMessage).thenReturn('Signup failed on server');
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Signup failed on server'), findsOneWidget);
    });
  });
}
