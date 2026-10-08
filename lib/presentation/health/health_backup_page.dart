import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/services/health_file_access.dart';
import '../../logic/providers/health_provider.dart';

class HealthBackupPage extends StatefulWidget {
  const HealthBackupPage({super.key});
  @override
  State<HealthBackupPage> createState() => _HealthBackupPageState();
}

class _HealthBackupPageState extends State<HealthBackupPage> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _working = false;
  String? _message;
  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _backup(bool restore) async {
    final vault = context.read<HealthProvider>();
    var passphrase = _password.text;
    if (passphrase.length < 12 || (!restore && passphrase != _confirm.text)) {
      setState(
        () => _message =
            'Use at least 12 characters. Confirm the same passphrase for export.',
      );
      return;
    }
    setState(() {
      _working = true;
      _message = null;
    });
    String? ownedPath;
    try {
      if (restore) {
        final proceed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Replace the entire local vault?'),
            content: const Text(
              'Restore replaces local observations, import history and notes after validation. Back up your current vault first. Videos and cloud records are not restored.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Choose backup'),
              ),
            ],
          ),
        );
        if (proceed != true || !mounted || !vault.unlocked) return;
        var path = vault.takeSelectedRestoreFile();
        if (path == null) {
          // A native Files activity can lock/dispose this page. Do not carry a
          // passphrase in the pending picker operation across that boundary.
          passphrase = '';
          final files = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['healthbackup'],
            withData: false,
            allowCompression: false,
          );
          path = files?.files.single.path;
        }
        if (path != null) {
          if (!vault.unlocked || !mounted) {
            vault.selectedRestoreFile(path);
            return;
          }
          if (passphrase.isEmpty) passphrase = _password.text;
          await vault.restoreBackup(path, passphrase);
        }
      } else {
        ownedPath = await createHealthBackupPath();
        await vault.exportBackup(ownedPath, passphrase);
        passphrase = '';
        if (mounted) {
          _password.clear();
          _confirm.clear();
        }
        if (vault.error == null && vault.unlocked) {
          final exported = await exportHealthBackupFile(ownedPath);
          if (!exported) {
            if (mounted) {
              setState(
                () => _message =
                    'Export canceled. No backup destination was written.',
              );
            }
            return;
          }
        }
      }
      if (mounted) {
        setState(() => _message = vault.error ?? vault.resultMessage);
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _message =
              'The encrypted backup operation could not be completed. No source file was changed.',
        );
      }
    } finally {
      if (ownedPath != null) {
        try {
          await removeHealthBackupFile(ownedPath);
        } catch (_) {
          /* Only an encrypted managed temporary file may remain. */
        }
      }
      if (mounted) {
        _password.clear();
        _confirm.clear();
        setState(() => _working = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vault = context.watch<HealthProvider>();
    if (!vault.unlocked) return const SizedBox.shrink();
    return Scaffold(
      appBar: AppBar(title: const Text('Encrypted local backup')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Backs up only local Health observations, source provenance, import lineage and notes. Training videos, InBody cloud reports and checkpoint cloud metadata are excluded. They will not be restored.',
          ),
          const SizedBox(height: 12),
          const Text(
            'Choose a private destination. Keep the passphrase separately: the app cannot recover a forgotten passphrase. Uninstalling can erase the device vault.',
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: 'Backup passphrase (12+ characters)',
            ),
          ),
          TextField(
            controller: _confirm,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(labelText: 'Confirm for export'),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _working || vault.busy ? null : () => _backup(false),
            child: const Text('Export encrypted backup'),
          ),
          if (!vault.personalImportEnabled)
            const Text(
              'Private Health restore is awaiting native device validation.',
            ),
          if (vault.hasPendingRestore)
            const Text(
              'A selected backup is ready. Enter the passphrase and confirm replacement again.',
            ),
          OutlinedButton(
            onPressed: _working || vault.busy || !vault.personalImportEnabled
                ? null
                : () => _backup(true),
            child: const Text('Restore and replace local vault'),
          ),
          if (_working || vault.busy) const LinearProgressIndicator(),
          if (_message != null) Text(_message!),
        ],
      ),
    );
  }
}
