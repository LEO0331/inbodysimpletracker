import 'dart:async';
import '../models/health_observation.dart';
import 'health_repository.dart';
import 'health_xml_parser.dart';
import 'health_import_source_web.dart'
    if (dart.library.io) 'health_import_source_mobile.dart'
    as source;

class HealthImportProgress {
  const HealthImportProgress({
    required this.processed,
    required this.imported,
    required this.skipped,
  });
  final int processed, imported, skipped;
}

class HealthImportResult extends HealthImportProgress {
  const HealthImportResult({
    required this.batchId,
    required super.processed,
    required super.imported,
    required super.skipped,
  });
  final String batchId;
}

class HealthImportException implements Exception {
  const HealthImportException(this.message);
  final String message;
  @override
  String toString() => message;
}

class HealthImportService {
  HealthImportService(this.repository);
  final HealthRepository repository;
  bool _running = false, _cancelled = false;
  Completer<void>? _cancelSignal;
  void Function()? _cancelSource;
  void cancel() {
    _cancelled = true;
    final signal = _cancelSignal;
    if (signal != null && !signal.isCompleted) signal.complete();
    _cancelSource?.call();
  }

  void _registerCancel(void Function() cancelSource) {
    _cancelSource = cancelSource;
    if (_cancelled) cancelSource();
  }

  Future<HealthImportResult> importFile(
    String path, {
    void Function(HealthImportProgress)? onProgress,
  }) => _import(
    source.parseHealthFile(path, onCancelReady: _registerCancel),
    onProgress,
  );
  Future<HealthImportResult> importStream(
    Stream<List<int>> bytes, {
    void Function(HealthImportProgress)? onProgress,
  }) {
    StreamSubscription<List<int>>? input;
    late final StreamController<List<int>> controller;
    controller = StreamController<List<int>>(
      onListen: () {
        input = bytes.listen(
          controller.add,
          onError: controller.addError,
          onDone: controller.close,
        );
        _registerCancel(() {
          // Closing the parser's input is necessary: cancelling an async*
          // subscription alone cannot interrupt its outstanding await-for.
          final cancelled = input!.cancel();
          unawaited(
            cancelled.then(
              (_) => controller.close(),
              onError: (_) => controller.close(),
            ),
          );
        });
      },
      onCancel: () => input?.cancel(),
    );
    return _import(parseHealthXml(controller.stream), onProgress);
  }

  Future<HealthImportResult> _import(
    Stream<Map<String, Object>> batches,
    void Function(HealthImportProgress)? onProgress,
  ) async {
    if (_running) {
      throw const HealthImportException('An import is already running.');
    }
    _running = true;
    _cancelled = false;
    _cancelSource = null;
    final cancelSignal = _cancelSignal = Completer<void>();
    final iterator = StreamIterator(batches);
    String? batchId;
    var processed = 0, imported = 0, skipped = 0;
    final clock = Stopwatch()..start();
    var lastProgress = -500;
    try {
      batchId = await repository.beginImport();
      while (await Future.any([
        iterator.moveNext(),
        cancelSignal.future.then((_) => false),
      ])) {
        if (_cancelled) throw const HealthImportException('Import cancelled.');
        final batch = iterator.current;
        final rows = (batch['rows'] as List)
            .map(
              (r) => HealthObservation.fromMap(
                Map<String, Object?>.from(r as Map),
              ),
            )
            .toList();
        if (rows.isNotEmpty) {
          imported += await repository.appendObservations(batchId, rows);
        }
        processed = batch['processed'] as int;
        skipped = batch['skipped'] as int;
        if (clock.elapsedMilliseconds - lastProgress >= 500) {
          onProgress?.call(
            HealthImportProgress(
              processed: processed,
              imported: imported,
              skipped: skipped,
            ),
          );
          lastProgress = clock.elapsedMilliseconds;
        }
      }
      if (_cancelled) throw const HealthImportException('Import cancelled.');
      await repository.finishImport(batchId, skippedCount: skipped);
      final result = HealthImportResult(
        batchId: batchId,
        processed: processed,
        imported: imported,
        skipped: skipped,
      );
      onProgress?.call(result);
      return result;
    } catch (error) {
      if (batchId != null) {
        try {
          await repository.abortImport(batchId);
        } catch (_) {
          throw const HealthImportException(
            'Import failed. Reopen the local vault to recover the pending import.',
          );
        }
      }
      if (error is HealthImportException) rethrow;
      throw const HealthImportException(
        'Import could not be completed. Check the export format and available storage.',
      );
    } finally {
      try {
        await iterator.cancel();
      } catch (_) {
        // Closing a cancelled, incomplete XML stream can fail parser final
        // validation. Never replace the sanitized import error with XML text.
      }
      _cancelSource = null;
      _cancelSignal = null;
      _running = false;
    }
  }
}
