import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:video_player/video_player.dart';
import 'package:inbodysimpletracker/presentation/checkpoints/widgets/checkpoint_video_player_mobile.dart';

class FakeVideoController extends VideoPlayerController {
  FakeVideoController({
    this.initialization,
    this.failInitialize = false,
    this.failDispose = false,
  }) : super.file(File('/fake/selected.mov'));

  final Future<void>? initialization;
  final bool failInitialize;
  final bool failDispose;
  int initializeCalls = 0;
  int disposeCalls = 0;
  bool failPlay = false;
  bool failSeek = false;

  @override
  Future<void> initialize() async {
    initializeCalls++;
    await initialization;
    if (disposeCalls > 0) return;
    if (failInitialize) throw StateError('corrupt file');
    value = const VideoPlayerValue(
      duration: Duration(seconds: 60),
      size: Size(640, 360),
      isInitialized: true,
    );
  }

  @override
  Future<void> play() async {
    if (failPlay) throw StateError('decoder failed');
    value = value.copyWith(isPlaying: true);
  }

  @override
  Future<void> pause() async => value = value.copyWith(isPlaying: false);

  @override
  Future<void> seekTo(Duration position) async {
    if (failSeek) throw StateError('seek failed');
    value = value.copyWith(position: position);
  }

  @override
  Future<void> dispose() async {
    disposeCalls++;
    await super.dispose();
    if (failDispose) throw StateError('platform disposal failed');
  }
}

Widget player(
  FakeVideoController controller, {
  String path = '/fake/first.mov',
}) => MaterialApp(
  home: Scaffold(
    body: CheckpointVideoPlayer(
      path: path,
      controllerFactory: (_) => controller,
    ),
  ),
);

void main() {
  testWidgets(
    'initializes on demand, preserves aspect, plays pauses and seeks',
    (tester) async {
      final controller = FakeVideoController();
      await tester.pumpWidget(player(controller));
      await tester.pumpAndSettle();
      expect(controller.initializeCalls, 1);
      expect(
        tester.widget<AspectRatio>(find.byType(AspectRatio)).aspectRatio,
        closeTo(16 / 9, .001),
      );
      await tester.tap(find.byTooltip('Play'));
      await tester.pump();
      expect(controller.value.isPlaying, isTrue);
      await tester.tap(find.byTooltip('Pause'));
      await tester.pump();
      expect(controller.value.isPlaying, isFalse);
      tester.widget<Slider>(find.byType(Slider)).onChanged!(15000);
      await tester.pump();
      expect(controller.value.position, const Duration(seconds: 15));
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
      expect(controller.disposeCalls, 1);
    },
  );

  testWidgets(
    'leaving during initialization disposes once and reopening is fresh',
    (tester) async {
      final pending = Completer<void>();
      final first = FakeVideoController(initialization: pending.future);
      await tester.pumpWidget(player(first));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      pending.complete();
      await tester.pump();
      expect(first.disposeCalls, 1);
      expect(tester.takeException(), isNull);
      final second = FakeVideoController();
      await tester.pumpWidget(player(second));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Play'), findsOneWidget);
      expect(second.initializeCalls, 1);
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
      expect(second.disposeCalls, 1);
    },
  );

  testWidgets('path switch releases old controller even when disposal fails', (
    tester,
  ) async {
    final first = FakeVideoController(failDispose: true);
    final second = FakeVideoController();
    await tester.pumpWidget(player(first));
    await tester.pumpAndSettle();
    await tester.pumpWidget(player(second, path: '/fake/second.mov'));
    await tester.pumpAndSettle();
    expect(first.disposeCalls, 1);
    expect(second.initializeCalls, 1);
    expect(find.byTooltip('Play'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets('corrupt video displays error and releases failed controller', (
    tester,
  ) async {
    final controller = FakeVideoController(failInitialize: true);
    await tester.pumpWidget(player(controller));
    await tester.pumpAndSettle();
    expect(find.textContaining('Unable to play this video.'), findsOneWidget);
    expect(controller.disposeCalls, 1);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(controller.disposeCalls, 1);
  });

  testWidgets(
    'controller construction and play failures become friendly errors',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CheckpointVideoPlayer(
            path: '/fake',
            controllerFactory: (_) => throw StateError('plugin error'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Unable to play this video.'), findsOneWidget);
      final controller = FakeVideoController()..failPlay = true;
      await tester.pumpWidget(player(controller, path: '/fake/new.mov'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Play'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Unable to play this video.'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
    },
  );

  testWidgets('runtime decoder and seek failures release their controllers', (
    tester,
  ) async {
    final decoder = FakeVideoController();
    await tester.pumpWidget(player(decoder));
    await tester.pumpAndSettle();
    decoder.value = decoder.value.copyWith(errorDescription: 'decoder error');
    await tester.pumpAndSettle();
    expect(find.textContaining('Unable to play this video.'), findsOneWidget);
    expect(decoder.disposeCalls, 1);
    final seeker = FakeVideoController()..failSeek = true;
    await tester.pumpWidget(player(seeker, path: '/fake/seek.mov'));
    await tester.pumpAndSettle();
    tester.widget<Slider>(find.byType(Slider)).onChanged!(1000);
    await tester.pumpAndSettle();
    expect(find.text('Unable to seek this video.'), findsOneWidget);
    expect(seeker.disposeCalls, 1);
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('switch during initialization ignores stale completion', (
    tester,
  ) async {
    final pending = Completer<void>();
    final first = FakeVideoController(initialization: pending.future);
    final second = FakeVideoController();
    await tester.pumpWidget(player(first));
    await tester.pump();
    await tester.pumpWidget(player(second, path: '/fake/replacement.mov'));
    await tester.pumpAndSettle();
    pending.complete();
    await tester.pumpAndSettle();
    expect(first.disposeCalls, 1);
    expect(second.initializeCalls, 1);
    expect(find.byTooltip('Play'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(second.disposeCalls, 1);
    expect(tester.takeException(), isNull);
  });
}
