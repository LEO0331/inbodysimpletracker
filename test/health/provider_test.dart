import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:inbodysimpletracker/data/models/health_observation.dart';
import 'package:inbodysimpletracker/data/services/health_repository.dart';
import 'package:inbodysimpletracker/data/services/health_import_service.dart';
import 'package:inbodysimpletracker/logic/providers/health_provider.dart';

class FakeHealthRepository implements HealthRepository {
  final rows = <HealthObservation>[];
  final notes = <HealthNote>[];
  bool opened = false;
  bool failOpen = false;
  Completer<void>? openBarrier;
  Completer<void>? noteBarrier;
  int saveCount = 0;
  int closeCount = 0;
  bool clearOnDelete = false;
  DateTime? lastQueryFrom;
  @override
  Future<void> open() async {
    if (openBarrier != null) await openBarrier!.future;
    if (failOpen) throw StateError('SENSITIVE_PATH_OR_KEY');
    opened = true;
  }

  @override
  Future<void> close() async {
    opened = false;
    closeCount++;
  }

  @override
  Future<List<HealthObservation>> queryObservations({
    required DateTime from,
    required DateTime to,
    HealthMetric? metric,
    String? source,
    int limit = 1000,
    int offset = 0,
  }) async {
    lastQueryFrom = from;
    return rows
        .where((r) => metric == null || r.metric == metric)
        .where((r) => source == null || r.source == source)
        .skip(offset)
        .take(limit)
        .toList();
  }

  @override
  Future<List<HealthImportBatch>> listImports() async => [];
  @override
  Future<List<String>> listSources(HealthMetric metric) async => rows
      .where((r) => r.metric == metric)
      .map((r) => r.source)
      .toSet()
      .toList();
  @override
  Future<List<HealthNote>> listNotes(DateTime from, DateTime to) async =>
      List.of(notes);
  @override
  Future<void> saveNote(HealthNote note) async {
    saveCount++;
    if (noteBarrier != null) await noteBarrier!.future;
    notes.add(note);
  }

  @override
  Future<void> deleteNote(String id) async =>
      notes.removeWhere((n) => n.id == id);
  @override
  Future<void> deleteImport(String batchId) async {
    if (clearOnDelete) rows.clear();
  }

  @override
  Future<String> beginImport() async => 'synthetic';
  @override
  Future<int> appendObservations(
    String batchId,
    List<HealthObservation> observations,
  ) async {
    rows.addAll(observations);
    return observations.length;
  }

  @override
  Future<void> finishImport(
    String batchId, {
    required int skippedCount,
  }) async {}
  @override
  Future<void> abortImport(String batchId) async {}
  @override
  Stream<List<Map<String, Object?>>> exportChunks({int chunkSize = 500}) =>
      const Stream.empty();
  @override
  Future<void> restoreChunks(Stream<List<Map<String, Object?>>> chunks) async {}
}

HealthObservation syntheticWeight(int index) => HealthObservation(
  id: '$index',
  logicalId: '$index',
  metric: HealthMetric.weight,
  source: 'Synthetic source',
  rawValue: '70',
  originalUnit: 'kg',
  canonicalUnit: 'kg',
  start: DateTime.utc(2026, 1, 1),
  end: DateTime.utc(2026, 1, 1),
  offsetMinutes: 0,
  value: 70,
);

class SpyHealthImporter extends HealthImportService {
  SpyHealthImporter(super.repository);
  int calls = 0;
  @override
  Future<HealthImportResult> importFile(
    String path, {
    void Function(HealthImportProgress)? onProgress,
  }) async {
    calls++;
    return const HealthImportResult(
      batchId: 'synthetic',
      processed: 0,
      imported: 0,
      skipped: 0,
    );
  }
}

void main() {
  test(
    'sleep queries include two prior days plus original-offset margin',
    () async {
      final repo = FakeHealthRepository();
      final provider = HealthProvider(repository: repo)
        ..week = DateTime(2026, 1, 5);
      await provider.open();
      await provider.setFilter(selectedMetric: HealthMetric.sleep);
      expect(repo.lastQueryFrom, DateTime.utc(2026, 1, 2, 10));
      provider.dispose();
    },
  );
  test(
    'sleep episode touching context boundary withholds partial summaries',
    () async {
      final repo = FakeHealthRepository()
        ..rows.add(
          HealthObservation(
            id: 'synthetic-long-sleep',
            logicalId: 'synthetic-long-sleep',
            metric: HealthMetric.sleep,
            source: 'Synthetic source',
            rawValue: 'asleep',
            originalUnit: '',
            canonicalUnit: 'min',
            start: DateTime.utc(2026, 1, 2, 9),
            end: DateTime.utc(2026, 1, 5, 7),
            offsetMinutes: 0,
            category: 'asleep',
          ),
        );
      final provider = HealthProvider(repository: repo)
        ..week = DateTime(2026, 1, 5);
      await provider.open();
      await provider.setFilter(selectedMetric: HealthMetric.sleep);
      expect(provider.incompleteSleepContext, isTrue);
      expect(provider.summaries, isEmpty);
      provider.dispose();
    },
  );
  test(
    'selection returning after background waits for explicit reopen',
    () async {
      final repo = FakeHealthRepository();
      final importer = SpyHealthImporter(repo);
      final provider = HealthProvider(
        repository: repo,
        personalImportEnabled: true,
        importServiceFactory: (_) => importer,
      );
      await provider.open();
      await provider.lock();
      await provider.selectedImportFile('/synthetic/selected.xml');
      expect(provider.hasPendingImport, isTrue);
      expect(importer.calls, 0);
      await provider.open();
      expect(importer.calls, 1);
      expect(provider.hasPendingImport, isFalse);
      provider.dispose();
    },
  );
  test(
    'restore selection retains only path and cannot be consumed locked',
    () async {
      final provider = HealthProvider(
        repository: FakeHealthRepository(),
        personalImportEnabled: true,
      );
      provider.selectedRestoreFile('/synthetic/selected.healthbackup');
      expect(provider.takeSelectedRestoreFile(), isNull);
      await provider.open();
      expect(provider.hasPendingRestore, isTrue);
      expect(
        provider.takeSelectedRestoreFile(),
        '/synthetic/selected.healthbackup',
      );
      expect(provider.hasPendingRestore, isFalse);
      provider.dispose();
    },
  );
  test('personal import is disabled without native verification', () async {
    final repo = FakeHealthRepository();
    final provider = HealthProvider(repository: repo);
    expect(provider.personalImportEnabled, isFalse);
    await provider.open();
    await provider.importFile('never_read_private.xml');
    expect(repo.rows, isEmpty);
    expect(provider.error, contains('awaiting native device validation'));
    provider.dispose();
  });
  test('opening errors are sanitized and can be retried', () async {
    final repo = FakeHealthRepository()..failOpen = true;
    final provider = HealthProvider(repository: repo);
    await provider.open();
    expect(provider.unlocked, isFalse);
    expect(provider.error, isNot(contains('SENSITIVE')));
    repo.failOpen = false;
    await provider.open();
    expect(provider.unlocked, isTrue);
    provider.dispose();
  });
  test('lock clears displayed records and requires explicit reopen', () async {
    final repo = FakeHealthRepository()..rows.add(syntheticWeight(1));
    final provider = HealthProvider(repository: repo)
      ..week = DateTime(2026, 1, 1);
    await provider.open();
    expect(provider.summaries, hasLength(1));
    await provider.lock();
    expect(provider.summaries, isEmpty);
    expect(provider.sources, isEmpty);
    expect(provider.unlocked, isFalse);
    expect(repo.opened, isFalse);
    await provider.refresh();
    expect(provider.unlocked, isFalse);
    await provider.open();
    expect(provider.summaries, hasLength(1));
    provider.dispose();
  });
  test('backgrounding while opening never publishes a vault', () async {
    final repo = FakeHealthRepository()..openBarrier = Completer<void>();
    final provider = HealthProvider(repository: repo);
    final pending = provider.open();
    await provider.lock();
    repo.openBarrier!.complete();
    await pending;
    expect(provider.unlocked, isFalse);
    expect(repo.opened, isFalse);
    provider.dispose();
  });
  test('more than query cap withholds every partial summary', () async {
    final repo = FakeHealthRepository()
      ..rows.addAll(List.generate(5001, syntheticWeight));
    final provider = HealthProvider(repository: repo)
      ..week = DateTime(2026, 1, 1);
    await provider.open();
    expect(provider.truncated, isTrue);
    expect(provider.summaries, isEmpty);
    provider.dispose();
  });
  test('mutations serialize and lock does not repopulate notes', () async {
    final repo = FakeHealthRepository()..noteBarrier = Completer<void>();
    final provider = HealthProvider(
      repository: repo,
      personalImportEnabled: true,
    );
    await provider.open();
    final first = provider.saveNote(DateTime(2026), 'Synthetic context');
    await provider.saveNote(DateTime(2026), 'Should not run concurrently');
    expect(repo.saveCount, 1);
    await provider.lock();
    repo.noteBarrier!.complete();
    await first;
    expect(provider.notes, isEmpty);
    expect(repo.opened, isFalse);
    provider.dispose();
  });
  test('invalid notes never reach repository', () async {
    final repo = FakeHealthRepository();
    final provider = HealthProvider(
      repository: repo,
      personalImportEnabled: true,
    );
    await provider.open();
    await provider.saveNote(DateTime(2026), ' ');
    await provider.saveNote(DateTime(2026), 'x' * 4001);
    expect(repo.saveCount, 0);
    provider.dispose();
  });
  test('personal notes cannot be saved before native validation', () async {
    final repo = FakeHealthRepository();
    final provider = HealthProvider(repository: repo);
    await provider.open();
    await provider.saveNote(DateTime(2026), 'Synthetic gate probe');
    expect(repo.saveCount, 0);
    expect(provider.error, contains('awaiting native device validation'));
    provider.dispose();
  });
  test(
    'deleting last import clears disappeared selected source before querying',
    () async {
      final repo = FakeHealthRepository()
        ..rows.add(syntheticWeight(1))
        ..clearOnDelete = true;
      final provider = HealthProvider(repository: repo)
        ..week = DateTime(2026, 1, 1);
      await provider.open();
      await provider.setFilter(selectedSource: 'Synthetic source');
      await provider.deleteImport('synthetic');
      expect(provider.source, isNull);
      expect(provider.sources, isEmpty);
      expect(provider.summaries, isEmpty);
      provider.dispose();
    },
  );
  test(
    'refresh after whole-vault replacement clears stale source selection',
    () async {
      final repo = FakeHealthRepository()..rows.add(syntheticWeight(1));
      final provider = HealthProvider(repository: repo)
        ..week = DateTime(2026, 1, 1);
      await provider.open();
      await provider.setFilter(selectedSource: 'Synthetic source');
      repo.rows.clear();
      await provider.refresh();
      expect(provider.source, isNull);
      expect(provider.sources, isEmpty);
      provider.dispose();
    },
  );
}
