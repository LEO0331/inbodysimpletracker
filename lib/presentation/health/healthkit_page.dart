import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/health_observation.dart';
import '../../logic/providers/health_provider.dart';

class AppleHealthRefreshPage extends StatefulWidget {
  const AppleHealthRefreshPage({super.key});

  @override
  State<AppleHealthRefreshPage> createState() => _AppleHealthRefreshPageState();
}

class _AppleHealthRefreshPageState extends State<AppleHealthRefreshPage> {
  final _selected = <HealthMetric>{
    HealthMetric.weight,
    HealthMetric.sleep,
    HealthMetric.steps,
    HealthMetric.exerciseMinutes,
    HealthMetric.restingHeartRate,
    HealthMetric.hrvSdnn,
  };

  Future<void> _clear() async {
    final vault = context.read<HealthProvider>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove local HealthKit data?'),
        content: const Text(
          'Removes fetched HealthKit observations and refresh cursors from this vault. Apple Health, XML imports and notes remain unchanged. A later refresh will read available history again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove locally'),
          ),
        ],
      ),
    );
    if (confirmed == true && vault.unlocked) await vault.clearHealthKitData();
  }

  @override
  Widget build(BuildContext context) {
    final vault = context.watch<HealthProvider>();
    if (!vault.unlocked) return const SizedBox.shrink();
    return Scaffold(
      appBar: AppBar(title: const Text('Apple Health refresh')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Read selected observations from Apple Health on this iPhone into your encrypted local vault. Refresh fetches changes and deletions since the last completed page. No background refresh or upload runs.',
          ),
          const SizedBox(height: 12),
          const Text(
            'If refresh is interrupted, progress stays encrypted locally. The affected HealthKit type is hidden from review until its refresh completes. Refresh again to resume.',
          ),
          const SizedBox(height: 12),
          const Text(
            'Apple controls access for each type. Completing the permission screen does not prove that read access was granted. An empty refresh can mean no changes, no available data or limited access. Review permissions in Apple Health if needed.',
          ),
          const SizedBox(height: 12),
          const Text(
            'HealthKit and XML imports are shown as separate sources, so overlapping history is never added together. After a restore, the first refresh rebuilds fetched history for each selected type. Empty or limited read access can produce empty history; choose access before refreshing.',
          ),
          for (final metric in HealthMetric.values)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(_label(metric)),
              value: _selected.contains(metric),
              onChanged: vault.busy
                  ? null
                  : (value) => setState(() {
                      if (value == true) {
                        _selected.add(metric);
                      } else {
                        _selected.remove(metric);
                      }
                    }),
            ),
          if (!vault.personalImportEnabled)
            const Text(
              'Apple Health refresh is awaiting native device validation.',
            ),
          FilledButton(
            onPressed:
                vault.busy || !vault.personalImportEnabled || _selected.isEmpty
                ? null
                : () => vault.refreshHealthKit(
                    _selected,
                    requestAuthorization: true,
                  ),
            child: const Text('Choose access and refresh'),
          ),
          OutlinedButton(
            onPressed:
                vault.busy || !vault.personalImportEnabled || _selected.isEmpty
                ? null
                : () => vault.refreshHealthKit(_selected),
            child: const Text('Refresh selected types'),
          ),
          if (vault.healthKitProgress != null) ...[
            const LinearProgressIndicator(),
            Text(vault.healthKitProgressLabel),
            TextButton(
              onPressed: vault.cancelHealthKitRefresh,
              child: const Text('Cancel refresh'),
            ),
          ],
          if (vault.error != null) Text(vault.error!),
          if (vault.resultMessage != null) Text(vault.resultMessage!),
          TextButton(
            onPressed: vault.busy || !vault.personalImportEnabled
                ? null
                : _clear,
            child: const Text('Remove fetched HealthKit data locally'),
          ),
        ],
      ),
    );
  }
}

String _label(HealthMetric metric) => switch (metric) {
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
