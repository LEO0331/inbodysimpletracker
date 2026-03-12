import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:inbodysimpletracker/presentation/auth/login_page.dart';
import 'package:inbodysimpletracker/logic/providers/auth_provider.dart';
import 'package:inbodysimpletracker/logic/providers/mqtt_provider.dart';

class MockAuthProvider extends Mock implements AuthProvider {}
class MockMqttProvider extends Mock implements MqttProvider {}

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
    );
  }

  group('LoginPage Detailed Tests', () {
    testWidgets('Shows error message if login fails', (tester) async {
       tester.view.physicalSize = const Size(1200, 1600);
       addTearDown(() => tester.view.resetPhysicalSize());

      when(() => mockAuth.errorMessage).thenReturn('Invalid credentials');
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Invalid credentials'), findsOneWidget);
    });

    testWidgets('Form validation works', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createTestWidget());
      final loginBtn = find.widgetWithText(ElevatedButton, 'Login');
      await tester.ensureVisible(loginBtn);
      await tester.tap(loginBtn);
      await tester.pumpAndSettle();
      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('Calls login with correct credentials', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(() => tester.view.resetPhysicalSize());

      when(() => mockAuth.login(any(), any())).thenAnswer((_) async {});
      await tester.pumpWidget(createTestWidget());
      
      await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'test@example.com');
      await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password123');
      
      final loginBtn = find.widgetWithText(ElevatedButton, 'Login');
      await tester.ensureVisible(loginBtn);
      await tester.tap(loginBtn);
      await tester.pump();
      
      verify(() => mockAuth.login('test@example.com', 'password123')).called(1);
    });
  });
}
