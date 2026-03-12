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
    when(() => mockAuth.errorMessage).thenReturn(null);
  });

  testWidgets('SignupPage Basic Render', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ChangeNotifierProvider<AuthProvider>.value(
        value: mockAuth,
        child: const SignupPage(),
      ),
    ));
    expect(find.byType(SignupPage), findsOneWidget);
  });
}
