import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inbodysimpletracker/presentation/checkpoints/add_checkpoint_page.dart';
import 'package:inbodysimpletracker/presentation/checkpoints/checkpoint_list_page.dart';
import 'package:inbodysimpletracker/presentation/checkpoints/widgets/checkpoint_form_validation.dart';

void main() {
  test('exercise and video are required', () {
    expect(requiredExercise('  '), isNotNull);
    expect(requiredExercise('Hip Abduction'), isNull);
    expect(requiredVideo(null), isNotNull);
    expect(requiredVideo('/temporary/selected.mov'), isNull);
  });

  test('optional numeric fields reject malformed and nonfinite numbers', () {
    for (final value in ['bad', 'NaN', 'Infinity', '-1']) {
      expect(optionalNumber(value), isNotNull, reason: value);
    }
    expect(optionalNumber(''), isNull);
    expect(optionalNumber('10.5'), isNull);
    expect(optionalNumber('3', integer: true), isNull);
    expect(optionalNumber('3.5', integer: true), isNotNull);
  });

  test('RPE accepts only finite numbers between 1 and 10', () {
    for (final value in ['0', '10.1', 'NaN', 'invalid']) {
      expect(optionalNumber(value, rpe: true), isNotNull);
    }
    for (final value in ['', '1', '6', '10']) {
      expect(optionalNumber(value, rpe: true), isNull);
    }
  });

  test('month filters clamp to calendar month end', () {
    expect(calendarMonthsAgo(DateTime(2026, 5, 31), 3), DateTime(2026, 2, 28));
    expect(calendarMonthsAgo(DateTime(2024, 5, 31), 3), DateTime(2024, 2, 29));
    expect(calendarMonthsAgo(DateTime(2026, 1, 7), 6), DateTime(2025, 7, 7));
  });

  testWidgets('empty add form shows exercise and video errors', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddCheckpointPage()));
    final save = find.widgetWithText(FilledButton, 'Save');
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pump();
    expect(find.text('Select a video.'), findsOneWidget);
    await tester.ensureVisible(
      find.widgetWithText(TextFormField, 'Exercise name'),
    );
    expect(find.text('Exercise name is required.'), findsOneWidget);
  });

  testWidgets('form reports invalid numeric and RPE entries', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddCheckpointPage()));
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Exercise name'),
      'Hip Abduction',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Load (optional)'),
      'bad',
    );
    final rpe = find.widgetWithText(TextFormField, 'RPE (1–10, optional)');
    await tester.ensureVisible(rpe);
    await tester.enterText(rpe, '11');
    final save = find.widgetWithText(FilledButton, 'Save');
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pump();
    await tester.ensureVisible(rpe);
    expect(find.text('RPE must be between 1 and 10.'), findsOneWidget);
    await tester.ensureVisible(
      find.widgetWithText(TextFormField, 'Load (optional)'),
    );
    expect(find.text('Enter a valid number.'), findsOneWidget);
  });
}
