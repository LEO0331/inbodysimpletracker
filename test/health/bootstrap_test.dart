import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inbodysimpletracker/main.dart';
import 'package:inbodysimpletracker/presentation/health_cloud_context.dart';

void main() {
  testWidgets(
    'local entry stays accessible when cloud bootstrap is pending or fails',
    (tester) async {
      final pending = Completer<void>();
      await tester.pumpWidget(
        BootstrapApp(
          initializeCloud: () => pending.future,
          localHealthBuilder: (_) =>
              const Scaffold(body: Text('Offline local vault')),
        ),
      );
      await tester.tap(find.text('Open Local Health'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      expect(find.text('Offline local vault'), findsOneWidget);
      pending.completeError(StateError('cloud unavailable'));
      await tester.pump();
      expect(find.text('Offline local vault'), findsOneWidget);
      expect(tester.takeException(), isNull);
      final context = tester.element(find.text('Offline local vault'));
      Navigator.of(context).pop();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      expect(
        find.text(
          'Cloud features are unavailable. Local Health can still open.',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('legacy context does not require Firebase or login to render', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: HealthCloudContext())),
    );
    expect(
      find.textContaining('Local Health works without login.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
