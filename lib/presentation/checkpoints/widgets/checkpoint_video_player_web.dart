import 'package:flutter/material.dart';

class CheckpointVideoPlayer extends StatelessWidget {
  const CheckpointVideoPlayer({super.key, required this.path});
  final String path;

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.all(24),
    child: Text('Video is not available on this device.'),
  );
}
