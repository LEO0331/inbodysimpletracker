import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../logic/providers/health_provider.dart';
import 'health_timeline_page.dart';

/// Standalone local entry: no Firebase bootstrap, authentication or cloud UID.
class HealthEntryPage extends StatelessWidget {
  const HealthEntryPage({
    super.key,
    this.providerFactory,
    this.cloudContextBuilder,
  });
  final HealthProvider Function()? providerFactory;
  final WidgetBuilder? cloudContextBuilder;
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(title: const Text('Local Health')),
        body: const Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Local Health is available in the native mobile app. Web does not import or upload Apple Health files. Existing InBody features remain available.',
          ),
        ),
      );
    }
    return ChangeNotifierProvider(
      create: (_) => providerFactory?.call() ?? HealthProvider(),
      child: _VaultLifecycle(cloudContextBuilder: cloudContextBuilder),
    );
  }
}

class _VaultLifecycle extends StatefulWidget {
  const _VaultLifecycle({this.cloudContextBuilder});
  final WidgetBuilder? cloudContextBuilder;
  @override
  State<_VaultLifecycle> createState() => _VaultLifecycleState();
}

class _VaultLifecycleState extends State<_VaultLifecycle>
    with WidgetsBindingObserver {
  Future<void> _setSensitiveView(bool visible) async {
    try {
      await const MethodChannel(
        'inbodysimpletracker/private_health',
      ).invokeMethod<void>('setSensitiveView', {'visible': visible});
    } catch (_) {
      // Unsupported desktop/test hooks do not expose any data or logs. Native
      // vault protection and personal-data validation remain separate gates.
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setSensitiveView(true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      context.read<HealthProvider>().lock();
      final entryRoute = ModalRoute.of(context);
      if (entryRoute != null) {
        Navigator.of(context).popUntil((route) => route == entryRoute);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _setSensitiveView(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vault = context.watch<HealthProvider>();
    if (vault.unlocked) {
      return HealthTimelinePage(
        cloudContextBuilder: widget.cloudContextBuilder,
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Local Health')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 48),
              const SizedBox(height: 16),
              const Text(
                'Your device-local Health vault',
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 12),
              const Text(
                'Health observations and notes are stored locally. Opening this vault uses this device’s protected key, independently of your cloud account. Keep an encrypted backup before uninstalling the app.',
              ),
              if (!vault.personalImportEnabled)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Private Health import is awaiting native device validation.',
                  ),
                ),
              if (vault.error != null) Text(vault.error!),
              if (vault.hasPendingImport)
                const Text(
                  'An import file was selected. Reopen the local vault to continue.',
                ),
              if (vault.hasPendingRestore)
                const Text(
                  'A backup was selected. Reopen the vault, then enter its passphrase and confirm restore again.',
                ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: vault.busy ? null : vault.open,
                child: Text(vault.busy ? 'Opening…' : 'Open local vault'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
