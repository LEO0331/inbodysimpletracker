import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/services/local_checkpoint_service.dart';
import '../../data/services/linked_local_video_service.dart';
import '../../logic/providers/checkpoint_provider.dart';
import 'checkpoint_list_page.dart';

class LocalCheckpointEntryPage extends StatelessWidget {
  const LocalCheckpointEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final directory = LocalCheckpointService.defaultDirectory();
    return ChangeNotifierProvider(
      create: (_) => CheckpointProvider(
        uid: 'local',
        metadataIsLocal: true,
        checkpointService: LocalCheckpointService(directory),
        localVideoService: LinkedLocalVideoService(
          documentsDirectory: () async => directory,
        ),
      ),
      child: const CheckpointListPage(uid: 'local'),
    );
  }
}
