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
    when(() => mockAuth.errorMessage).thenReturn(null);
  });

  testWidgets('LoginPage Basic Render', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: mockAuth),
          ChangeNotifierProvider<MqttProvider>.value(value: mockMqtt),
        ],
        child: const LoginPage(),
      ),
    ));
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
