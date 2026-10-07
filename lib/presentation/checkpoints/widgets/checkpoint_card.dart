import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/training_checkpoint.dart';
import 'checkpoint_labels.dart';

class CheckpointCard extends StatelessWidget {
  const CheckpointCard({
    super.key,
    required this.checkpoint,
    required this.onTap,
  });
  final TrainingCheckpoint checkpoint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = checkpoint;
    final metrics = <String>[
      if (c.load != null) '${c.load} ${c.loadUnit}',
      if (c.sets != null || c.reps != null)
        '${c.sets ?? '–'} × ${c.reps ?? '–'}',
      if (c.rpe != null) 'RPE ${c.rpe}',
    ];
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.video_library_outlined),
        title: Text(c.exerciseName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat.yMMMd().format(c.checkpointDate)),
            Text('${sideLabel(c.side)} • ${angleLabel(c.cameraAngle)}'),
            if (metrics.isNotEmpty) Text(metrics.join(' • ')),
            if (c.notes?.trim().isNotEmpty == true)
              Text(c.notes!, maxLines: 2, overflow: TextOverflow.ellipsis),
            const Text('Video stored on its original device'),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
