import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:inbodysimpletracker/core/app_router.dart';
import 'package:inbodysimpletracker/logic/providers/auth_provider.dart';
import 'package:inbodysimpletracker/presentation/checkpoints/checkpoint_entry_page.dart';

class MockAuth extends Mock implements AuthProvider {}

class MockContext extends Mock implements BuildContext {}

void main() {
  test('checkpoint route uses the account-scoped entry page', () {
    final route = AppRouter.generateRoute(
      const RouteSettings(name: '/checkpoints'),
    );
    expect(
      (route as MaterialPageRoute).builder(MockContext()),
      isA<CheckpointEntryPage>(),
    );
  });

  testWidgets(
    'signed-out checkpoint entry offers login without opening storage',
    (tester) async {
      final auth = MockAuth();
      when(() => auth.user).thenReturn(null);
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>.value(
          value: auth,
          child: MaterialApp(
            home: const CheckpointEntryPage(),
            routes: {
              '/login': (_) => const Scaffold(body: Text('Login destination')),
            },
          ),
        ),
      );
      expect(find.text('Login to view checkpoints'), findsOneWidget);
      await tester.tap(find.text('Login to view checkpoints'));
      await tester.pumpAndSettle();
      expect(find.text('Login destination'), findsOneWidget);
    },
  );
}
