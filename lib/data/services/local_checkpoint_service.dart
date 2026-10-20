import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/training_checkpoint.dart';
import 'checkpoint_service.dart';

/// Device-only records. This service never accesses Firebase.
class LocalCheckpointService extends CheckpointService {
  LocalCheckpointService(this.directory);

  final Directory directory;
  final _changes = StreamController<void>.broadcast(sync: true);
  Future<void> _writes = Future<void>.value();

  File get _file => File('${directory.path}/checkpoints.json');

  static Directory defaultDirectory() {
    const configured = String.fromEnvironment('LOCAL_CHECKPOINT_DIRECTORY');
    return Directory(
      configured.isNotEmpty
          ? configured
          : '${Platform.environment['APPDATA'] ?? Directory.current.path}/InBodySimpleTracker/checkpoints',
    );
  }

  Future<List<TrainingCheckpoint>> readAll() async {
    if (!await _file.exists()) return [];
    final decoded = jsonDecode(await _file.readAsString());
    if (decoded is! Map<String, dynamic> ||
        decoded['version'] != 1 ||
        decoded['records'] is! List) {
      throw const FormatException('Unsupported local checkpoint file.');
    }
    final records = (decoded['records'] as List).map((raw) {
      final map = Map<String, dynamic>.from(raw as Map);
      final id = map.remove('id');
      if (id is! String || !RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(id)) {
        throw const FormatException('Invalid local checkpoint ID.');
      }
      return TrainingCheckpoint.fromMap(id, map);
    }).toList();
    records.sort((a, b) {
      final order = b.checkpointDate.compareTo(a.checkpointDate);
      return order != 0 ? order : a.id.compareTo(b.id);
    });
    return records;
  }

  @override
  Stream<List<TrainingCheckpoint>> getCheckpoints(String uid) =>
      Stream<void>.multi((sink) {
        final subscription = _changes.stream.listen(
          sink.add,
          onError: sink.addError,
        );
        sink.onCancel = subscription.cancel;
        sink.add(null);
      }).asyncMap((_) => readAll());

  @override
  String createId(String uid) {
    final random = Random.secure();
    return List.generate(
      16,
      (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
  }

  Future<void> _mutate(void Function(List<TrainingCheckpoint>) update) {
    final operation = _writes.then((_) async {
      final records = await readAll();
      update(records);
      await directory.create(recursive: true);
      final temporary = File('${_file.path}.tmp');
      final encoded = {
        'version': 1,
        'records': records
            .map(
              (record) => {
                'id': record.id,
                ...record.toMap().map(
                  (key, value) => MapEntry(
                    key,
                    value is Timestamp
                        ? value.toDate().toIso8601String()
                        : value,
                  ),
                ),
              },
            )
            .toList(),
      };
      await temporary.writeAsString(
        const JsonEncoder.withIndent('  ').convert(encoded),
        flush: true,
      );
      await temporary.rename(_file.path);
      _changes.add(null);
    });
    _writes = operation.then<void>(
      (_) {},
      onError: (Object error, StackTrace stack) {},
    );
    return operation;
  }

  @override
  Future<void> saveCheckpoint(String uid, TrainingCheckpoint checkpoint) =>
      _mutate((records) {
        records.removeWhere((record) => record.id == checkpoint.id);
        records.add(checkpoint);
      });

  @override
  Future<void> deleteCheckpoint(String uid, String id) =>
      _mutate((records) => records.removeWhere((record) => record.id == id));
}
