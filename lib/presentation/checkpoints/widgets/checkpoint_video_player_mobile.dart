import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CheckpointVideoPlayer extends StatefulWidget {
  const CheckpointVideoPlayer({
    super.key,
    required this.path,
    this.controllerFactory,
  });
  final String path;
  final VideoPlayerController Function(String path)? controllerFactory;

  @override
  State<CheckpointVideoPlayer> createState() => _CheckpointVideoPlayerState();
}

class _CheckpointVideoPlayerState extends State<CheckpointVideoPlayer> {
  VideoPlayerController? _controller;
  String? _error;
  int _generation = 0;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void didUpdateWidget(CheckpointVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.path != oldWidget.path ||
        widget.controllerFactory != oldWidget.controllerFactory) {
      _initialize();
    }
  }

  Future<void> _initialize() async {
    final generation = ++_generation;
    final previous = _controller;
    _controller = null;
    _error = null;
    await _release(previous);
    if (!mounted || generation != _generation) return;
    setState(() {});
    try {
      final controller =
          widget.controllerFactory?.call(widget.path) ??
          VideoPlayerController.file(File(widget.path));
      _controller = controller;
      controller.addListener(_refresh);
      await controller.initialize();
    } catch (_) {
      if (mounted && generation == _generation) {
        setState(
          () => _error =
              'Unable to play this video. The format may not be supported.',
        );
        final failed = _controller;
        _controller = null;
        await _release(failed);
      }
    }
    if (mounted && generation == _generation) setState(() {});
  }

  void _refresh() {
    if (!mounted) return;
    if (_controller?.value.hasError == true) {
      _fail(
        _controller!,
        'Unable to play this video. The format may not be supported.',
      );
    } else {
      setState(() {});
    }
  }

  Future<void> _release(VideoPlayerController? controller) async {
    if (controller == null) return;
    controller.removeListener(_refresh);
    try {
      await controller.dispose();
    } catch (_) {
      // A platform disposal failure must not crash navigation or replacement.
    }
  }

  void _fail(VideoPlayerController controller, String message) {
    if (!mounted || _controller != controller) return;
    setState(() {
      _error = message;
      _controller = null;
    });
    unawaited(_release(controller));
  }

  Future<void> _toggle() async {
    final controller = _controller;
    if (controller == null) return;
    try {
      if (controller.value.isPlaying) {
        await controller.pause();
      } else {
        if (controller.value.position >= controller.value.duration) {
          await controller.seekTo(Duration.zero);
        }
        await controller.play();
      }
    } catch (_) {
      _fail(controller, 'Unable to play this video.');
    }
  }

  Future<void> _seek(double value) async {
    final controller = _controller;
    if (controller == null) return;
    try {
      await controller.seekTo(Duration(milliseconds: value.round()));
    } catch (_) {
      _fail(controller, 'Unable to seek this video.');
    }
  }

  @override
  void dispose() {
    _generation++;
    final controller = _controller;
    _controller = null;
    unawaited(_release(controller));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (_error != null || controller?.value.hasError == true) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(_error ?? 'Unable to play this video.'),
      );
    }
    if (controller == null || !controller.value.isInitialized) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final value = controller.value;
    final duration = value.duration.inMilliseconds.toDouble();
    return Column(
      children: [
        AspectRatio(
          aspectRatio: value.aspectRatio.isFinite && value.aspectRatio > 0
              ? value.aspectRatio
              : 16 / 9,
          child: VideoPlayer(controller),
        ),
        Row(
          children: [
            IconButton(
              onPressed: _toggle,
              tooltip: value.isPlaying ? 'Pause' : 'Play',
              icon: Icon(value.isPlaying ? Icons.pause : Icons.play_arrow),
            ),
            Expanded(
              child: Slider(
                min: 0,
                max: duration > 0 ? duration : 1,
                value: value.position.inMilliseconds.toDouble().clamp(
                  0,
                  duration > 0 ? duration : 1,
                ),
                onChanged: duration > 0 ? _seek : null,
              ),
            ),
            Text('${value.position.inSeconds}s / ${value.duration.inSeconds}s'),
          ],
        ),
      ],
    );
  }
}
