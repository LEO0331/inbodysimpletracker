import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:inbodysimpletracker/presentation/auth/login_page.dart';
import 'package:inbodysimpletracker/logic/providers/auth_provider.dart';
import 'package:inbodysimpletracker/logic/providers/mqtt_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

class MockAuthProvider extends Mock implements AuthProvider {}
class MockMqttProvider extends Mock implements MqttProvider {}
class MockUser extends Mock implements User {}

void main() {
  late MockAuthProvider mockAuth;
  late MockMqttProvider mockMqtt;

  setUp(() {
    mockAuth = MockAuthProvider();
    mockMqtt = MockMqttProvider();

    // Default mock behaviors
    when(() => mockAuth.isLoading).thenReturn(false);
    when(() => mockAuth.isAuthenticated).thenReturn(false);
    when(() => mockAuth.errorMessage).thenReturn(null);
    when(() => mockAuth.user).thenReturn(null);
  });

  Widget createWidgetToTest() {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: mockAuth),
          ChangeNotifierProvider<MqttProvider>.value(value: mockMqtt),
        ],
        child: const LoginPage(),
      ),
    );
  }

  group('LoginPage Widget Tests', () {
    testWidgets('Should render login fields and buttons', (tester) async {
      await tester.pumpWidget(createWidgetToTest());

      expect(find.text('Login'), findsWidgets); // AppBar title and Button text
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text("Don't have an account? "), findsOneWidget);
      expect(find.text('Sign up'), findsOneWidget);
    });

    testWidgets('Should show validation errors when fields are empty', (tester) async {
      await tester.pumpWidget(createWidgetToTest());

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('Should show error message when login fails', (tester) async {
      when(() => mockAuth.errorMessage).thenReturn('Invalid credentials');

      await tester.pumpWidget(createWidgetToTest());

      expect(find.text('Invalid credentials'), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);
    });

    testWidgets('Should show loading indicator when authenticating', (tester) async {
      when(() => mockAuth.isLoading).thenReturn(true);

      await tester.pumpWidget(createWidgetToTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Login'), findsOneWidget); // AppBar title
      // The button text 'Login' should be hidden behind indicator
    });

    testWidgets('Should call login on AuthProvider when form is valid', (tester) async {
      when(() => mockAuth.login(any(), any())).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetToTest());

      await tester.enterText(find.byType(TextFormField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      verify(() => mockAuth.login('test@example.com', 'password123')).called(1);
    });
  });
}
