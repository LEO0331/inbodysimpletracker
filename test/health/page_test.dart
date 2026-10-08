import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inbodysimpletracker/logic/providers/health_provider.dart';
import 'package:inbodysimpletracker/presentation/health/health_entry_page.dart';
import 'provider_test.dart' show FakeHealthRepository, SpyHealthImporter;

class PendingHealthPicker extends FilePicker {
  final completion = Completer<FilePickerResult?>();
  @override
  Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    bool allowCompression = true,
    int compressionQuality = 30,
    bool allowMultiple = false,
    bool withData = false,
    bool withReadStream = false,
    bool lockParentWindow = false,
    bool readSequential = false,
  }) {
    expect(withData, isFalse);
    expect(allowCompression, isFalse);
    return completion.future;
  }
}

void main() {
  testWidgets(
    'local entry scopes native sensitive-view protection to its lifetime',
    (tester) async {
      final visibility = <bool>[];
      const channel = MethodChannel('inbodysimpletracker/private_health');
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
        call,
      ) async {
        if (call.method == 'setSensitiveView') {
          visibility.add((call.arguments as Map)['visible'] as bool);
        }
        return null;
      });
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          channel,
          null,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: HealthEntryPage(
            providerFactory: () =>
                HealthProvider(repository: FakeHealthRepository()),
          ),
        ),
      );
      await tester.pump();
      expect(visibility, [true]);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      expect(visibility, [true, false]);
    },
  );
  testWidgets(
    'Files import completion after pause survives until explicit unlock',
    (tester) async {
      final picker = PendingHealthPicker();
      FilePicker.platform = picker;
      final repo = FakeHealthRepository();
      final importer = SpyHealthImporter(repo);
      final vault = HealthProvider(
        repository: repo,
        personalImportEnabled: true,
        importServiceFactory: (_) => importer,
      );
      await tester.pumpWidget(
        MaterialApp(home: HealthEntryPage(providerFactory: () => vault)),
      );
      await tester.tap(find.text('Open local vault'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Import / history'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Choose XML or ZIP'));
      await tester.pump();
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump();
      picker.completion.complete(
        FilePickerResult([
          PlatformFile(
            name: 'synthetic.xml',
            path: '/synthetic/selected.xml',
            size: 10,
          ),
        ]),
      );
      await tester.pump();
      expect(vault.hasPendingImport, isTrue);
      expect(importer.calls, 0);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open local vault'));
      await tester.pumpAndSettle();
      expect(importer.calls, 1);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'restore picker may complete after page disposal without retaining passphrase',
    (tester) async {
      final picker = PendingHealthPicker();
      FilePicker.platform = picker;
      final vault = HealthProvider(
        repository: FakeHealthRepository(),
        personalImportEnabled: true,
      );
      await tester.pumpWidget(
        MaterialApp(home: HealthEntryPage(providerFactory: () => vault)),
      );
      await tester.tap(find.text('Open local vault'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Encrypted backup'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextField).first,
        'synthetic passphrase',
      );
      await tester.ensureVisible(find.text('Restore and replace local vault'));
      await tester.tap(find.text('Restore and replace local vault'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.text('Choose backup'));
      await tester.pump();
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump();
      picker.completion.complete(
        FilePickerResult([
          PlatformFile(
            name: 'synthetic.healthbackup',
            path: '/synthetic/selected.healthbackup',
            size: 10,
          ),
        ]),
      );
      await tester.pump();
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      expect(vault.hasPendingRestore, isTrue);
      expect(vault.unlocked, isFalse);
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Open local vault'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Encrypted backup'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(find.byType(TextField).first).controller!.text,
        isEmpty,
      );
    },
  );
  testWidgets('local entry opens without any authentication provider', (
    tester,
  ) async {
    final repository = FakeHealthRepository();
    await tester.pumpWidget(
      MaterialApp(
        home: HealthEntryPage(
          providerFactory: () => HealthProvider(repository: repository),
        ),
      ),
    );
    expect(
      find.text('Private Health import is awaiting native device validation.'),
      findsOneWidget,
    );
    expect(repository.opened, isFalse);
    await tester.tap(find.text('Open local vault'));
    await tester.pumpAndSettle();
    expect(find.text('Local Health · weekly review'), findsOneWidget);
    expect(repository.opened, isTrue);
    await tester.tap(find.byTooltip('Lock local vault'));
    await tester.pumpAndSettle();
    expect(find.text('Open local vault'), findsOneWidget);
  });
  testWidgets('backgrounding locks and removes local subpages', (tester) async {
    final repository = FakeHealthRepository();
    await tester.pumpWidget(
      MaterialApp(
        home: HealthEntryPage(
          providerFactory: () => HealthProvider(repository: repository),
        ),
      ),
    );
    await tester.tap(find.text('Open local vault'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Import / history'));
    await tester.pumpAndSettle();
    expect(find.text('Import Apple Health locally'), findsOneWidget);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pumpAndSettle();
    expect(repository.opened, isFalse);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(find.text('Open local vault'), findsOneWidget);
  });
}
