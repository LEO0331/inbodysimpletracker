import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/models/training_checkpoint.dart';
import '../../logic/providers/checkpoint_provider.dart';
import 'widgets/checkpoint_labels.dart';
import 'widgets/checkpoint_video_player.dart';

class CheckpointDetailPage extends StatefulWidget {
  const CheckpointDetailPage({super.key, required this.checkpoint});
  final TrainingCheckpoint checkpoint;
  @override
  State<CheckpointDetailPage> createState() => _CheckpointDetailPageState();
}

class _CheckpointDetailPageState extends State<CheckpointDetailPage> {
  late Future<String?> _videoPath;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    _videoPath = context
        .read<CheckpointProvider>()
        .localVideoService
        .resolvePath(widget.checkpoint.localVideoPath);
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete checkpoint?'),
        content: const Text(
          'This removes the checkpoint metadata and its locally stored video from this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted || _deleting) return;
    setState(() => _deleting = true);
    try {
      await context.read<CheckpointProvider>().deleteCheckpoint(
        widget.checkpoint,
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Checkpoint deleted.')));
        Navigator.pop(context);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to delete checkpoint. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.checkpoint;
    return PopScope(
      canPop: !_deleting,
      child: Scaffold(
        appBar: AppBar(
          title: Text(c.exerciseName),
          actions: [
            IconButton(
              onPressed: _deleting ? null : _delete,
              tooltip: 'Delete checkpoint',
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              DateFormat.yMMMd().format(c.checkpointDate),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text('Exercise: ${c.exerciseName}'),
            Text('Side: ${sideLabel(c.side)}'),
            Text('Camera angle: ${angleLabel(c.cameraAngle)}'),
            Text('Load: ${c.load == null ? '–' : '${c.load} ${c.loadUnit}'}'),
            Text('Sets: ${c.sets ?? '–'}'),
            Text('Reps: ${c.reps ?? '–'}'),
            Text('RPE: ${c.rpe ?? '–'}'),
            const SizedBox(height: 12),
            Text('Notes: ${c.notes?.isNotEmpty == true ? c.notes! : '–'}'),
            const SizedBox(height: 24),
            Text(c.originalFileName),
            const Text(
              'Training video files stay on this device and are not uploaded.',
            ),
            const SizedBox(height: 12),
            if (_deleting)
              const Center(child: CircularProgressIndicator())
            else
              FutureBuilder<String?>(
                future: _videoPath,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snapshot.hasError || snapshot.data == null) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('Video is not available on this device.'),
                    );
                  }
                  return CheckpointVideoPlayer(path: snapshot.data!);
                },
              ),
          ],
        ),
      ),
    );
  }
}
