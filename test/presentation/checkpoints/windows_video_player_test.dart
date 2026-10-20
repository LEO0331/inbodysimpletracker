import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inbodysimpletracker/presentation/checkpoints/widgets/checkpoint_video_player_mobile.dart';

void main() {
  const channel = MethodChannel('inbody/local_video');
  const path = r'C:\private\training_videos\clip\video.mp4';

  testWidgets(
    'Windows playback delegates the exact local path to the native player',
    (tester) async {
      MethodCall? received;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
        call,
      ) async {
        received = call;
        return null;
      });
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          channel,
          null,
        ),
      );
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CheckpointVideoPlayer(path: path)),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);
      await tester.tap(find.text('Play in Windows video player'));
      await tester.pump();
      expect(received?.method, 'open');
      expect(received?.arguments, path);
    },
    skip: !Platform.isWindows,
  );

  testWidgets('Windows playback failures remain visible and retryable', (
    tester,
  ) async {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
      _,
    ) async {
      throw PlatformException(code: 'open_failed');
    });
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        null,
      ),
    );
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: CheckpointVideoPlayer(path: path)),
      ),
    );
    await tester.tap(find.text('Play in Windows video player'));
    await tester.pump();
    expect(find.textContaining('Unable to open the video.'), findsOneWidget);
    expect(find.text('Play in Windows video player'), findsOneWidget);
  }, skip: !Platform.isWindows);
}
