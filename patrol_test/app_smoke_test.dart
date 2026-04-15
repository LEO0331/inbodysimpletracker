import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inbodysimpletracker/main.dart' as app;
import 'package:patrol/patrol.dart';

void main() {
  patrolTest('home login signup smoke validations', ($) async {
    app.main();
    await $.pumpAndSettle();

    // Ensure deterministic unauthenticated state for the smoke flow.
    if ($.tester.any(find.byIcon(Icons.menu))) {
      await $.tester.tap(find.byIcon(Icons.menu));
      await $.pumpAndSettle();
      if ($.tester.any(find.text('Logout'))) {
        await $.tester.tap(find.text('Logout'));
        await $.pumpAndSettle();
      }
    }

    // Case 1: home unauthenticated state
    expect(find.text('Welcome to InBody Tracker'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    expect(find.widgetWithText(OutlinedButton, 'Sign Up'), findsOneWidget);
    expect(find.byIcon(Icons.menu), findsNothing);

    // Case 2: navigate home -> login
    await $.tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await $.pumpAndSettle();
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);

    // Case 3: login empty-form validation
    await $.tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await $.pumpAndSettle();
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);

    // Case 4: login invalid format/length validation
    await $.tester.enterText(
      find.widgetWithText(TextFormField, 'Email'),
      'bad-email',
    );
    await $.tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      '123',
    );
    await $.tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await $.pumpAndSettle();
    expect(find.text('Please enter a valid email'), findsOneWidget);
    expect(find.text('Password must be at least 6 characters'), findsOneWidget);

    // Case 5: navigate login -> signup
    await $.tester.tap(find.widgetWithText(TextButton, 'Sign Up'));
    await $.pumpAndSettle();
    expect(find.text('Create Account'), findsWidgets);
    expect(find.widgetWithText(TextFormField, 'Confirm Password'), findsOneWidget);

    // Case 6: signup validation (empty + invalid + mismatch)
    await $.tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
    await $.pumpAndSettle();
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
    expect(find.text('Please confirm your password'), findsOneWidget);

    await $.tester.enterText(
      find.widgetWithText(TextFormField, 'Email'),
      'invalid-email',
    );
    await $.tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      '123',
    );
    await $.tester.enterText(
      find.widgetWithText(TextFormField, 'Confirm Password'),
      '456',
    );
    await $.tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
    await $.pumpAndSettle();

    expect(find.text('Please enter a valid email'), findsOneWidget);
    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    expect(find.text('Passwords do not match'), findsOneWidget);
  });
}
