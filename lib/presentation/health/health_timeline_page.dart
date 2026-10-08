import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/health_observation.dart';
import '../../logic/providers/health_provider.dart';
import 'health_import_page.dart';
import 'health_backup_page.dart';
import 'healthkit_page.dart';

class HealthTimelinePage extends StatelessWidget {
  const HealthTimelinePage({super.key, this.cloudContextBuilder});
  final WidgetBuilder? cloudContextBuilder;
  void _navigate(BuildContext context, Widget page) {
    final vault = context.read<HealthProvider>();
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ChangeNotifierProvider.value(value: vault, child: page),
      ),
    );
  }

  Future<void> _note(BuildContext context) async {
    final vault = context.read<HealthProvider>();
    DateTime date = vault.week;
    final controller = TextEditingController();
    final text = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Local training context'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () async {
                    final selected = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (selected != null) setState(() => date = selected);
                  },
                  child: Text(date.toString().split(' ').first),
                ),
                TextField(
                  controller: controller,
                  maxLength: 4000,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText:
                        'What do you want to revisit at your next training review?',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Save locally'),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    if (text != null && vault.unlocked) await vault.saveNote(date, text);
  }

  @override
  Widget build(BuildContext context) {
    final vault = context.watch<HealthProvider>();
    if (!vault.unlocked) return const SizedBox.shrink();
    final start = DateTime(vault.week.year, vault.week.month, vault.week.day);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Health · weekly review'),
        actions: [
          IconButton(
            onPressed: vault.lock,
            icon: const Icon(Icons.lock_outline),
            tooltip: 'Lock local vault',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Health observations and these notes stay on this device. Training videos are local; existing InBody reports and checkpoint metadata use separate cloud features.',
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: [
              OutlinedButton(
                onPressed: vault.busy
                    ? null
                    : () => _navigate(context, const HealthImportPage()),
                child: const Text('Import / history'),
              ),
              OutlinedButton(
                onPressed: vault.busy
                    ? null
                    : () => _navigate(context, const HealthBackupPage()),
                child: const Text('Encrypted backup'),
              ),
              if (vault.healthKitSupported)
                OutlinedButton(
                  onPressed: vault.busy
                      ? null
                      : () =>
                            _navigate(context, const AppleHealthRefreshPage()),
                  child: const Text('Apple Health refresh'),
                ),
              OutlinedButton(
                onPressed: vault.busy || !vault.personalImportEnabled
                    ? null
                    : () => _note(context),
                child: const Text('Add local context'),
              ),
            ],
          ),
          if (cloudContextBuilder != null) cloudContextBuilder!(context),
          if (!vault.personalImportEnabled)
            const Text(
              'Personal imports, Apple Health refresh, restore and notes are awaiting native device validation.',
            ),
          Row(
            children: [
              IconButton(
                onPressed: vault.busy
                    ? null
                    : () => vault.setFilter(
                        selectedWeek: start.subtract(const Duration(days: 7)),
                      ),
                icon: const Icon(Icons.chevron_left),
                tooltip: 'Previous week',
              ),
              Expanded(
                child: Text(
                  '${start.toString().split(' ').first} — ${start.add(const Duration(days: 6)).toString().split(' ').first}',
                ),
              ),
              IconButton(
                onPressed: vault.busy
                    ? null
                    : () => vault.setFilter(
                        selectedWeek: start.add(const Duration(days: 7)),
                      ),
                icon: const Icon(Icons.chevron_right),
                tooltip: 'Next week',
              ),
            ],
          ),
          TextButton(
            onPressed: vault.busy
                ? null
                : () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: start,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) await vault.setFilter(selectedWeek: date);
                  },
            child: const Text('Choose review date'),
          ),
          DropdownButtonFormField<HealthMetric>(
            initialValue: vault.metric,
            decoration: const InputDecoration(labelText: 'Metric'),
            items: HealthMetric.values
                .map(
                  (m) =>
                      DropdownMenuItem(value: m, child: Text(_metricLabel(m))),
                )
                .toList(),
            onChanged: vault.busy
                ? null
                : (m) {
                    if (m != null) vault.setFilter(selectedMetric: m);
                  },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            key: ValueKey(
              '${vault.metric}:${vault.source}:${vault.sources.length}',
            ),
            initialValue: vault.source ?? '',
            decoration: const InputDecoration(
              labelText: 'Source (never combined across devices)',
            ),
            items: [
              const DropdownMenuItem(
                value: '',
                child: Text('All sources, shown separately'),
              ),
              ...vault.sources.map(
                (s) => DropdownMenuItem(
                  value: s,
                  child: Text(s, overflow: TextOverflow.ellipsis),
                ),
              ),
            ],
            onChanged: vault.busy
                ? null
                : (s) =>
                      vault.setFilter(selectedSource: s, clearSource: s == ''),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            initialValue: vault.offsetMinutes ?? -9999,
            decoration: const InputDecoration(labelText: 'Day grouping'),
            items: [
              const DropdownMenuItem(
                value: -9999,
                child: Text('Original record offset'),
              ),
              for (final offset in _fixedOffsets())
                DropdownMenuItem(
                  value: offset,
                  child: Text(_offsetLabel(offset)),
                ),
            ],
            onChanged: vault.busy
                ? null
                : (offset) => vault.setFilter(
                    selectedOffset: offset,
                    originalOffset: offset == -9999,
                  ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Fixed offsets do not apply daylight saving rules. Activity spanning midnight is attributed to its end day. XML summaries can differ from Apple Health’s source-prioritized totals.',
            ),
          ),
          if (vault.busy) const LinearProgressIndicator(),
          if (vault.error != null) Text(vault.error!),
          if (vault.truncated)
            const Text(
              'Some dates exceed the safe observation limit. Their totals are withheld; other dates remain available. Select one source to narrow the data.',
            ),
          if (vault.metric == HealthMetric.sleep)
            const Text(
              'Sleep episodes use up to two days of context; unusually long or incomplete episodes may be incomplete.',
            ),
          if (vault.incompleteSleepContext)
            const Text(
              'Some sleep episodes have incomplete context. Totals for those dates are withheld.',
            ),
          for (var i = 0; i < 7; i++) ...[
            const Divider(),
            Text(
              start.add(Duration(days: i)).toString().split(' ').first,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (vault.withheldDays.contains(
              DateTime.utc(
                start.year,
                start.month,
                start.day,
              ).add(Duration(days: i)),
            ))
              const Text(
                'Summary withheld · incomplete or excessive observations',
              ),
            if (!vault.withheldDays.contains(
                  DateTime.utc(
                    start.year,
                    start.month,
                    start.day,
                  ).add(Duration(days: i)),
                ) &&
                !vault.summaries.any(
                  (s) =>
                      s.date.year == start.add(Duration(days: i)).year &&
                      s.date.month == start.add(Duration(days: i)).month &&
                      s.date.day == start.add(Duration(days: i)).day,
                ))
              const Text('No recorded observations · coverage gap'),
            for (final summary in vault.summaries.where(
              (s) =>
                  s.date.year == start.add(Duration(days: i)).year &&
                  s.date.month == start.add(Duration(days: i)).month &&
                  s.date.day == start.add(Duration(days: i)).day,
            ))
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  summary.hasConflict && summary.value == null
                      ? 'Conflicting intervals · total withheld'
                      : '${summary.value?.toStringAsFixed(2) ?? 'No comparable value'} ${summary.unit}',
                ),
                subtitle: Text(
                  '${summary.source} · ${summary.sampleCount} samples${summary.hasConflict && summary.value != null ? '\nConflicting stages treated as unclassified asleep.' : ''}${summary.stages.isEmpty ? '' : '\nSleep stages (minutes): ${summary.stages}'}',
                ),
              ),
          ],
          const Divider(),
          const Text('Local context notes', style: TextStyle(fontSize: 20)),
          if (vault.notes.isEmpty) const Text('No notes for this week.'),
          for (final note in vault.notes)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(note.text),
              subtitle: Text(note.date.toString().split(' ').first),
              trailing: IconButton(
                tooltip: 'Delete local note',
                icon: const Icon(Icons.delete_outline),
                onPressed: vault.busy
                    ? null
                    : () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete this local note?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Keep'),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) await vault.deleteNote(note.id);
                      },
              ),
            ),
        ],
      ),
    );
  }
}

String _metricLabel(HealthMetric metric) => switch (metric) {
  HealthMetric.weight => 'Body weight',
  HealthMetric.sleep => 'Sleep',
  HealthMetric.steps => 'Steps',
  HealthMetric.distance => 'Walking / running distance',
  HealthMetric.activeEnergy => 'Active energy',
  HealthMetric.basalEnergy => 'Basal energy',
  HealthMetric.exerciseMinutes => 'Exercise minutes',
  HealthMetric.restingHeartRate => 'Resting heart rate',
  HealthMetric.hrvSdnn => 'HRV (SDNN)',
  HealthMetric.vo2Max => 'VO₂ max',
};

List<int> _fixedOffsets() {
  final local = DateTime.now().timeZoneOffset.inMinutes;
  return ({
    for (var offset = -720; offset <= 840; offset += 60) offset,
    if (local >= -720 && local <= 840) local,
  }).toList()..sort();
}

String _offsetLabel(int minutes) {
  final magnitude = minutes.abs();
  final label = minutes == 0
      ? 'UTC'
      : 'UTC${minutes < 0 ? '-' : '+'}${magnitude ~/ 60}:${(magnitude % 60).toString().padLeft(2, '0')}';
  return '$label (fixed${minutes == DateTime.now().timeZoneOffset.inMinutes ? ', device current offset' : ''})';
}
