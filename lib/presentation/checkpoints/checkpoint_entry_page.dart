import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/providers/auth_provider.dart';
import '../../logic/providers/checkpoint_provider.dart';
import 'checkpoint_list_page.dart';

/// Keeps checkpoint subscriptions scoped to the signed-in account and route.
class CheckpointEntryPage extends StatelessWidget {
  const CheckpointEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = context.watch<AuthProvider>().user?.uid;
    if (uid == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Training Checkpoints')),
        body: Center(
          child: FilledButton(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            child: const Text('Login to view checkpoints'),
          ),
        ),
      );
    }
    return ChangeNotifierProvider(
      key: ValueKey(uid),
      create: (_) => CheckpointProvider(uid: uid),
      child: CheckpointListPage(uid: uid),
    );
  }
}
