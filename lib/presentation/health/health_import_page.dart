import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/providers/health_provider.dart';

class HealthImportPage extends StatelessWidget {
  const HealthImportPage({super.key});
  Future<void> _pick(BuildContext context) async {
    final vault = context.read<HealthProvider>();
    try {
      final files = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xml', 'zip'],
        withData: false,
        allowCompression: false,
      );
      final path = files?.files.single.path;
      if (path != null) {
        await vault.selectedImportFile(path);
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'The file could not be selected. Try selecting export.xml or the Apple Health ZIP again.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vault = context.watch<HealthProvider>();
    if (!vault.unlocked) return const SizedBox.shrink();
    return Scaffold(
      appBar: AppBar(title: const Text('Import Apple Health locally')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Choose export.xml or Apple Health’s ZIP through Files. The original file is preserved. Imported records stay in the local encrypted vault.',
          ),
          const SizedBox(height: 16),
          const Text(
            'Included: body weight, sleep, steps, active/basal energy, exercise minutes, resting heart rate and HRV. Source labels, units and original time offsets are preserved.',
          ),
          const SizedBox(height: 12),
          const Text(
            'Excluded: demographics, clinical/CDA documents, raw heart rate, workouts and unrelated types. Unsupported or invalid records are counted as skipped. No missing workouts or measurements are invented.',
          ),
          const SizedBox(height: 16),
          if (!vault.personalImportEnabled)
            const Text(
              'Private Health import is awaiting native device validation.',
            ),
          FilledButton(
            onPressed:
                vault.busy || !vault.personalImportEnabled || !vault.unlocked
                ? null
                : () => _pick(context),
            child: const Text('Choose XML or ZIP'),
          ),
          if (vault.busy) ...[
            const SizedBox(height: 16),
            const LinearProgressIndicator(),
            Text(
              'Processed ${vault.progress?.processed ?? 0} · Imported ${vault.progress?.imported ?? 0} · Skipped ${vault.progress?.skipped ?? 0}',
            ),
            TextButton(
              onPressed: vault.cancelImport,
              child: const Text('Cancel import'),
            ),
          ],
          if (vault.error != null) Text(vault.error!),
          if (vault.resultMessage != null) Text(vault.resultMessage!),
          const SizedBox(height: 20),
          const Text('Import history', style: TextStyle(fontSize: 20)),
          if (vault.imports.isEmpty)
            const Text('No completed imports. Missing data is shown as a gap.'),
          for (final batch in vault.imports)
            ListTile(
              title: Text(
                '${batch.createdAt.toLocal().toString().split('.').first} · ${batch.status}',
              ),
              subtitle: Text(
                '${batch.recordCount} records · ${batch.skippedCount} skipped',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Undo import',
                onPressed: vault.busy
                    ? null
                    : () async {
                        final remove = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Undo this import?'),
                            content: const Text(
                              'Removes this import’s membership. Records retained by other imports and your original file are preserved.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Keep'),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Undo import'),
                              ),
                            ],
                          ),
                        );
                        if (remove == true) await vault.deleteImport(batch.id);
                      },
              ),
            ),
        ],
      ),
    );
  }
}
