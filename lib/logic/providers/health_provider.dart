import 'package:flutter/foundation.dart';
import '../../core/utils/health_aggregation.dart';
import '../../data/models/health_observation.dart';
import '../../data/services/health_repository.dart';
import '../../data/services/health_import_service.dart';
import '../../data/services/health_backup_service.dart';
import '../../data/services/health_store.dart';

/// A device-local vault. Never depends on a cloud account or cloud services.
class HealthProvider extends ChangeNotifier {
  HealthProvider({
    HealthRepository? repository,
    bool? personalImportEnabled,
    HealthImportService Function(HealthRepository)? importServiceFactory,
  }) : repository = repository ?? createHealthRepository(),
       personalImportEnabled =
           personalImportEnabled ??
           const bool.fromEnvironment(
             'HEALTH_VAULT_VERIFIED',
             defaultValue: false,
           ),
       _importServiceFactory = importServiceFactory ?? HealthImportService.new;
  final HealthRepository repository;
  final bool personalImportEnabled;
  final HealthImportService Function(HealthRepository) _importServiceFactory;
  String? _pendingImportPath;
  String? _pendingRestorePath;
  bool get hasPendingImport => _pendingImportPath != null;
  bool get hasPendingRestore => _pendingRestorePath != null;
  bool unlocked = false;
  bool busy = false;
  bool truncated = false;
  bool incompleteSleepContext = false;
  bool _disposed = false;
  bool _lockRequested = false;
  String? error;
  String? resultMessage;
  HealthImportProgress? progress;
  HealthImportService? _importer;
  List<HealthDailySummary> summaries = [];
  List<HealthImportBatch> imports = [];
  List<HealthNote> notes = [];
  List<String> sources = [];
  HealthMetric metric = HealthMetric.weight;
  String? source;
  int? offsetMinutes;
  DateTime week = DateTime.now();
  void _notify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> _run(
    Future<void> Function() action, {
    bool needsUnlock = true,
  }) async {
    if (_disposed || busy || (needsUnlock && !unlocked)) return;
    busy = true;
    error = null;
    resultMessage = null;
    _notify();
    try {
      await action();
    } catch (_) {
      error =
          'The local operation could not be completed. Your source file has not been changed. Retry after reopening the vault.';
    } finally {
      progress = null;
      _importer = null;
      if (_lockRequested || _disposed) {
        await _close();
        _lockRequested = false;
      }
      busy = false;
      _notify();
    }
  }

  Future<void> open() => _run(() async {
    await repository.open();
    if (_lockRequested || _disposed) return;
    unlocked = true;
    await _refresh();
    if (unlocked && _pendingImportPath != null) {
      final path = _pendingImportPath!;
      _pendingImportPath = null;
      await _performImport(path);
    }
  }, needsUnlock: false);

  /// Files pickers can background Flutter. Keep only the selected path in memory
  /// and require explicit vault reopening before touching its contents.
  Future<void> selectedImportFile(String path) async {
    if (_disposed || !personalImportEnabled) return;
    if (!unlocked || busy) {
      _pendingImportPath = path;
      _notify();
      return;
    }
    await importFile(path);
  }

  void selectedRestoreFile(String path) {
    if (_disposed || !personalImportEnabled) return;
    _pendingRestorePath = path;
    _notify();
  }

  String? takeSelectedRestoreFile() {
    if (_disposed || !unlocked) return null;
    final path = _pendingRestorePath;
    _pendingRestorePath = null;
    _notify();
    return path;
  }

  Future<void> lock() async {
    unlocked = false;
    summaries = [];
    imports = [];
    notes = [];
    sources = [];
    truncated = false;
    incompleteSleepContext = false;
    progress = null;
    error = null;
    resultMessage = null;
    _lockRequested = true;
    _importer?.cancel();
    _notify();
    if (!busy) {
      busy = true;
      await _close();
      _lockRequested = false;
      busy = false;
      _notify();
    }
  }

  Future<void> _close() async {
    try {
      await repository.close();
    } catch (_) {
      if (!_disposed) {
        error =
            'The local vault could not finish closing. Restart the app before reopening it.';
      }
    }
  }

  Future<void> _refresh() async {
    if (!unlocked || _lockRequested || _disposed) return;
    final day = DateTime.utc(week.year, week.month, week.day);
    final availableSources = await repository.listSources(metric);
    if (!unlocked || _lockRequested || _disposed) return;
    if (source != null && !availableSources.contains(source)) source = null;
    final queryFrom = day.subtract(
      Duration(days: metric == HealthMetric.sleep ? 2 : 0, hours: 14),
    );
    final rows = await repository.queryObservations(
      from: queryFrom,
      to: day.add(const Duration(days: 7, hours: 14)),
      metric: metric,
      source: source,
      limit: 5001,
    );
    final batches = await repository.listImports();
    final savedNotes = await repository.listNotes(
      day,
      day.add(const Duration(days: 7)),
    );
    if (!unlocked || _lockRequested || _disposed) return;
    truncated = rows.length > 5000;
    incompleteSleepContext =
        metric == HealthMetric.sleep &&
        rows.any((row) => !row.start.isAfter(queryFrom));
    summaries = truncated || incompleteSleepContext
        ? []
        : computeDailyHealthSummaries(rows, offsetMinutes: offsetMinutes)
              .where(
                (s) =>
                    !s.date.isBefore(day) &&
                    s.date.isBefore(day.add(const Duration(days: 7))),
              )
              .toList();
    imports = batches;
    notes = savedNotes;
    sources = availableSources;
  }

  Future<void> refresh() => _run(_refresh);
  Future<void> setFilter({
    HealthMetric? selectedMetric,
    String? selectedSource,
    bool clearSource = false,
    DateTime? selectedWeek,
    int? selectedOffset,
    bool originalOffset = false,
  }) => _run(() async {
    if (selectedMetric != null) {
      metric = selectedMetric;
      source = null;
    }
    if (clearSource) {
      source = null;
    } else if (selectedSource != null) {
      source = selectedSource;
    }
    if (selectedWeek != null) week = selectedWeek;
    if (originalOffset) {
      offsetMinutes = null;
    } else if (selectedOffset != null) {
      offsetMinutes = selectedOffset;
    }
    await _refresh();
  });
  Future<void> importFile(String path) => _run(() => _performImport(path));
  Future<void> _performImport(String path) async {
    if (!personalImportEnabled) {
      error = 'Private Health import is awaiting native device validation.';
      return;
    }
    _importer = _importServiceFactory(repository);
    final result = await _importer!.importFile(
      path,
      onProgress: (value) {
        if (unlocked) {
          progress = value;
          _notify();
        }
      },
    );
    if (!unlocked) return;
    resultMessage =
        'Import completed: ${result.processed} processed, ${result.imported} imported, ${result.skipped} skipped.';
    // The service owns staging, cancellation and deduplication.
    await _refresh();
  }

  void cancelImport() => _importer?.cancel();
  Future<void> deleteImport(String id) => _run(() async {
    await repository.deleteImport(id);
    await _refresh();
  });
  Future<void> saveNote(DateTime date, String text) => _run(() async {
    if (!personalImportEnabled) {
      error = 'Private Health notes are awaiting native device validation.';
      return;
    }
    final value = text.trim();
    if (value.isEmpty || value.length > 4000) {
      error = 'Enter a note between 1 and 4,000 characters.';
      return;
    }
    await repository.saveNote(
      HealthNote(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        date: DateTime.utc(date.year, date.month, date.day),
        text: value,
      ),
    );
    await _refresh();
  });
  Future<void> deleteNote(String id) => _run(() async {
    await repository.deleteNote(id);
    await _refresh();
  });
  Future<void> exportBackup(String path, String passphrase) => _run(() async {
    if (passphrase.length < 12) {
      error = 'Use a backup passphrase of at least 12 characters.';
      return;
    }
    await HealthBackupService(repository).exportToFile(path, passphrase);
    if (unlocked) {
      resultMessage =
          'Encrypted local-vault backup created. Videos and cloud metadata are excluded.';
    }
  });
  Future<void> restoreBackup(String path, String passphrase) => _run(() async {
    if (!personalImportEnabled) {
      error = 'Private Health restore is awaiting native device validation.';
      return;
    }
    await HealthBackupService(repository).restoreFromFile(path, passphrase);
    await _refresh();
    if (unlocked) {
      resultMessage = 'Local vault restored.';
    }
  });
  @override
  void dispose() {
    _disposed = true;
    _pendingImportPath = null;
    _pendingRestorePath = null;
    lock();
    super.dispose();
  }
}
