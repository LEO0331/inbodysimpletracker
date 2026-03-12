import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:inbodysimpletracker/presentation/auth/home_page.dart';
import 'package:inbodysimpletracker/logic/providers/auth_provider.dart';
import 'package:inbodysimpletracker/logic/providers/mqtt_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

class MockAuthProvider extends Mock implements AuthProvider {}
class MockMqttProvider extends Mock implements MqttProvider {}
class MockUser extends Mock implements User {}

void main() {
  late MockAuthProvider mockAuth;
  late MockMqttProvider mockMqtt;
  late MockUser mockUser;

  setUp(() {
    mockAuth = MockAuthProvider();
    mockMqtt = MockMqttProvider();
    mockUser = MockUser();

    when(() => mockAuth.isAuthenticated).thenReturn(false);
    when(() => mockAuth.isAdmin).thenReturn(false);
    when(() => mockAuth.user).thenReturn(null);
  });

  Widget createWidgetToTest() {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: mockAuth),
          ChangeNotifierProvider<MqttProvider>.value(value: mockMqtt),
        ],
        child: const HomePage(),
      ),
      routes: {
        '/login': (_) => const Scaffold(body: Text('Login Page')),
        '/signup': (_) => const Scaffold(body: Text('Signup Page')),
        '/upload': (_) => const Scaffold(body: Text('Upload Page')),
        '/dashboard': (_) => const Scaffold(body: Text('Dashboard Page')),
        '/admin': (_) => const Scaffold(body: Text('Admin Page')),
      },
    );
  }

  group('HomePage Widget Tests', () {
    testWidgets('Should render welcome screen when not authenticated', (tester) async {
      await tester.pumpWidget(createWidgetToTest());

      expect(find.text('Welcome to InBody Tracker'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsNothing);
    });

    testWidgets('Should render personalized screen when authenticated', (tester) async {
      when(() => mockAuth.isAuthenticated).thenReturn(true);
      when(() => mockAuth.user).thenReturn(mockUser);
      when(() => mockUser.email).thenReturn('test@example.com');

      await tester.pumpWidget(createWidgetToTest());

      expect(find.text('Hello, test!'), findsOneWidget);
      expect(find.text('Start Analysis (Scan)'), findsOneWidget);
      expect(find.text('View Dashboard'), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('Should show Admin Dashboard in drawer for admins', (tester) async {
      when(() => mockAuth.isAuthenticated).thenReturn(true);
      when(() => mockAuth.isAdmin).thenReturn(true);
      when(() => mockAuth.user).thenReturn(mockUser);
      when(() => mockUser.email).thenReturn('admin@example.com');

      await tester.pumpWidget(createWidgetToTest());

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      expect(find.text('Admin Dashboard'), findsOneWidget);
      expect(find.text('Administrator'), findsOneWidget);
    });

    testWidgets('Should not show Admin Dashboard in drawer for regular users', (tester) async {
      when(() => mockAuth.isAuthenticated).thenReturn(true);
      when(() => mockAuth.isAdmin).thenReturn(false);
      when(() => mockAuth.user).thenReturn(mockUser);
      when(() => mockUser.email).thenReturn('user@example.com');

      await tester.pumpWidget(createWidgetToTest());

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      expect(find.text('Admin Dashboard'), findsNothing);
      expect(find.text('Member'), findsOneWidget);
    });

    testWidgets('Should navigate to login page', (tester) async {
      await tester.pumpWidget(createWidgetToTest());

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.text('Login Page'), findsOneWidget);
    });
  });
}
