import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/training_checkpoint.dart';
import '../../logic/providers/checkpoint_provider.dart';
import 'add_checkpoint_page.dart';
import 'checkpoint_detail_page.dart';
import 'widgets/checkpoint_card.dart';
import 'widgets/checkpoint_labels.dart';

DateTime calendarMonthsAgo(DateTime now, int months) {
  final monthStart = DateTime(now.year, now.month - months);
  final lastDay = DateTime(monthStart.year, monthStart.month + 1, 0).day;
  return DateTime(
    monthStart.year,
    monthStart.month,
    now.day > lastDay ? lastDay : now.day,
  );
}

class CheckpointListPage extends StatefulWidget {
  const CheckpointListPage({super.key, required this.uid});
  final String uid;
  @override
  State<CheckpointListPage> createState() => _CheckpointListPageState();
}

class _CheckpointListPageState extends State<CheckpointListPage> {
  String _exercise = '';
  CheckpointSide? _side;
  int _months = 0;

  Future<void> _add() async {
    final provider = context.read<CheckpointProvider>();
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: provider,
          child: const AddCheckpointPage(),
        ),
      ),
    );
    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Checkpoint saved. Video stored locally.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CheckpointProvider>();
    final since = _months == 0
        ? null
        : calendarMonthsAgo(DateTime.now(), _months);
    final checkpoints =
        provider.checkpoints
            .where(
              (c) =>
                  c.exerciseName.toLowerCase().contains(
                    _exercise.toLowerCase().trim(),
                  ) &&
                  (_side == null || c.side == _side) &&
                  (since == null || !c.checkpointDate.isBefore(since)),
            )
            .toList()
          ..sort((a, b) => b.checkpointDate.compareTo(a.checkpointDate));
    return Scaffold(
      appBar: AppBar(title: const Text('Training Checkpoints')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.add),
        label: const Text('Add Checkpoint'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Filter by exercise',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) => setState(() => _exercise = value),
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<CheckpointSide>(
                        initialValue: _side,
                        hint: const Text('All sides'),
                        decoration: const InputDecoration(labelText: 'Side'),
                        items: [
                          const DropdownMenuItem<CheckpointSide>(
                            value: null,
                            child: Text('All sides'),
                          ),
                          ...CheckpointSide.values.map(
                            (side) => DropdownMenuItem(
                              value: side,
                              child: Text(sideLabel(side)),
                            ),
                          ),
                        ],
                        onChanged: (side) => setState(() => _side = side),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        initialValue: _months,
                        decoration: const InputDecoration(labelText: 'Date'),
                        items: const [
                          DropdownMenuItem(value: 0, child: Text('All')),
                          DropdownMenuItem(
                            value: 3,
                            child: Text('Last 3 months'),
                          ),
                          DropdownMenuItem(
                            value: 6,
                            child: Text('Last 6 months'),
                          ),
                        ],
                        onChanged: (months) =>
                            setState(() => _months = months!),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (provider.error != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                provider.error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : checkpoints.isEmpty
                ? const Center(
                    child: Text('No checkpoints match these filters.'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 96),
                    itemCount: checkpoints.length,
                    itemBuilder: (context, index) => CheckpointCard(
                      checkpoint: checkpoints[index],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider.value(
                            value: provider,
                            child: CheckpointDetailPage(
                              checkpoint: checkpoints[index],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
