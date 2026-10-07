import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CheckpointVideoPlayer extends StatefulWidget {
  const CheckpointVideoPlayer({super.key, required this.path});
  final String path;

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
    if (widget.path != oldWidget.path) _initialize();
  }

  Future<void> _initialize() async {
    final generation = ++_generation;
    final previous = _controller;
    _controller = null;
    _error = null;
    previous?.removeListener(_refresh);
    await previous?.dispose();
    if (!mounted || generation != _generation) return;
    setState(() {});
    final controller = VideoPlayerController.file(File(widget.path));
    _controller = controller;
    controller.addListener(_refresh);
    try {
      await controller.initialize();
    } catch (_) {
      if (mounted && generation == _generation) {
        setState(
          () => _error =
              'Unable to play this video. The format may not be supported.',
        );
      }
    }
    if (mounted && generation == _generation) setState(() {});
  }

  void _refresh() {
    if (mounted) setState(() {});
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
      if (mounted) setState(() => _error = 'Unable to play this video.');
    }
  }

  Future<void> _seek(double value) async {
    try {
      await _controller?.seekTo(Duration(milliseconds: value.round()));
    } catch (_) {
      if (mounted) setState(() => _error = 'Unable to seek this video.');
    }
  }

  @override
  void dispose() {
    _generation++;
    _controller?.removeListener(_refresh);
    _controller?.dispose();
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
          aspectRatio: value.aspectRatio > 0 ? value.aspectRatio : 16 / 9,
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
