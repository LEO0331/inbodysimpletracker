import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

const _channel = MethodChannel('inbodysimpletracker/private_health');

Future<Directory> _backupDirectory() async {
  final temporary = await getTemporaryDirectory();
  final directory = Directory(
    '${temporary.path}${Platform.pathSeparator}health_backups',
  );
  await directory.create(recursive: true);
  return directory;
}

Future<String> createHealthBackupPath() async {
  final directory = await _backupDirectory();
  final random = Random.secure();
  final id = List.generate(
    16,
    (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ).join();
  return '${directory.path}${Platform.pathSeparator}$id.healthbackup';
}

Future<File> _ownedFile(String path) async {
  final directory = await _backupDirectory();
  final file = File(path).absolute;
  final parent = await file.parent.resolveSymbolicLinks();
  if (parent != await directory.resolveSymbolicLinks() ||
      !RegExp(
        r'^[a-f0-9]{32}\.healthbackup$',
      ).hasMatch(file.uri.pathSegments.last) ||
      await FileSystemEntity.type(path, followLinks: false) !=
          FileSystemEntityType.file) {
    throw const FileSystemException('Not an owned encrypted Health backup');
  }
  return file;
}

Future<bool> exportHealthBackupFile(String path) async {
  final file = await _ownedFile(path);
  return await _channel.invokeMethod<bool>('exportBackup', {
        'path': file.path,
      }) ??
      false;
}

Future<void> removeHealthBackupFile(String path) async {
  if (!await File(path).exists()) return;
  final file = await _ownedFile(path);
  await file.delete();
}
