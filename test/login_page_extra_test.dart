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

    when(() => mockAuth.isLoading).thenReturn(false);
    when(() => mockAuth.isAuthenticated).thenReturn(false);
    when(() => mockAuth.errorMessage).thenReturn(null);
    when(() => mockAuth.user).thenReturn(null);
    
    when(() => mockMqtt.isLoading).thenReturn(false);
    when(() => mockMqtt.isConnected).thenReturn(false);
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: mockAuth),
          ChangeNotifierProvider<MqttProvider>.value(value: mockMqtt),
        ],
        child: const LoginPage(),
      ),
      routes: {
        '/signup': (context) => const Scaffold(body: Text('Signup Screen')),
      },
    );
  }

  group('LoginPage Loading and Nav Hits Final', () {
    testWidgets('Shows loading indicator', (tester) async {
       when(() => mockAuth.isLoading).thenReturn(true);
       await tester.pumpWidget(createTestWidget());
       expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Navigates to signup', (tester) async {
       await tester.pumpWidget(createTestWidget());
       final signupBtn = find.text('Sign Up');
       await tester.ensureVisible(signupBtn);
       await tester.tap(signupBtn);
       await tester.pumpAndSettle();
       expect(find.text('Signup Screen'), findsOneWidget);
    });

    testWidgets('Shows logout button if authenticated', (tester) async {
       final mockUser = MockUser();
       when(() => mockAuth.isAuthenticated).thenReturn(true);
       when(() => mockAuth.user).thenReturn(mockUser);
       when(() => mockUser.email).thenReturn('test@e.com');
       
       await tester.pumpWidget(createTestWidget());
       expect(find.textContaining('Logged in as: test@e.com'), findsOneWidget);
       expect(find.widgetWithText(OutlinedButton, 'Logout'), findsOneWidget);
    });
  });
}
