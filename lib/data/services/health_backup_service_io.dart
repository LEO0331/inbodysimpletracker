import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

import 'health_backup_exception.dart';
import 'health_repository.dart';

/// Portable backup of the private Health vault and notes only.
/// Videos and Firestore records are deliberately outside this format.
class HealthBackupService {
  HealthBackupService(this._repository);
  final HealthRepository _repository;
  static const _iterations = 600000;
  static const _maxLine = 2 * 1024 * 1024;
  static const _maxChunks = 100000;
  static const _maxBytes = 8 * 1024 * 1024 * 1024;
  final _cipher = AesGcm.with256bits();

  Future<void> exportToFile(String path, String passphrase) async {
    _validate(path, passphrase);
    final file = File(path);
    var created = false;
    RandomAccessFile? output;
    try {
      final salt = _random(16);
      final prefix = _random(8);
      final header = jsonEncode({
        'format': 'private-health',
        'version': 1,
        'kdf': 'PBKDF2-HMAC-SHA256',
        'iterations': _iterations,
        'salt': base64Encode(salt),
        'noncePrefix': base64Encode(prefix),
      });
      final key = await _derive(passphrase, salt);
      await file.create(exclusive: true);
      created = true;
      output = await file.open(mode: FileMode.writeOnly);
      var bytesWritten = 0;
      Future<void> writeLine(String line) async {
        final bytes = utf8.encode('$line\n');
        bytesWritten += bytes.length;
        if (bytes.length > _maxLine || bytesWritten > _maxBytes) {
          throw const FormatException('Backup size limit');
        }
        await output!.writeFrom(bytes);
      }

      await writeLine(header);
      var index = 0;
      Future<void> writePayload(Map<String, Object?> payload) async {
        if (index > _maxChunks) throw const FormatException('Chunk limit');
        final plain = utf8.encode(jsonEncode(payload));
        if (plain.length > _maxLine ~/ 2) {
          throw const FormatException('Chunk size');
        }
        final box = await _cipher.encrypt(
          plain,
          secretKey: key,
          nonce: _nonce(prefix, index),
          aad: utf8.encode('$header\n$index'),
        );
        await writeLine(
          jsonEncode({
            'index': index,
            'ciphertext': base64Encode(box.cipherText),
            'mac': base64Encode(box.mac.bytes),
          }),
        );
        index++;
      }

      await for (final rows in _repository.exportChunks(chunkSize: 500)) {
        if (rows.length > 500) throw const FormatException('Chunk size');
        // The repository bounds row count; encrypted framing also bounds bytes.
        // A valid note can occupy many UTF-8 bytes, so split by encoded size.
        const plainLimit = _maxLine ~/ 2;
        final framingBytes = utf8
            .encode(jsonEncode({'kind': 'data', 'rows': []}))
            .length;
        var buffered = <Map<String, Object?>>[];
        var bufferedBytes = framingBytes;
        for (final row in rows) {
          final rowBytes = utf8.encode(jsonEncode(row)).length;
          if (rowBytes + framingBytes > plainLimit) {
            throw const HealthBackupException(
              'A Health record exceeds the backup size limit. No backup was created.',
            );
          }
          final separatorBytes = buffered.isEmpty ? 0 : 1;
          if (bufferedBytes + separatorBytes + rowBytes > plainLimit) {
            await writePayload({'kind': 'data', 'rows': buffered});
            buffered = [];
            bufferedBytes = framingBytes;
          }
          bufferedBytes += (buffered.isEmpty ? 0 : 1) + rowBytes;
          buffered.add(row);
        }
        if (buffered.isNotEmpty) {
          await writePayload({'kind': 'data', 'rows': buffered});
        }
      }
      await writePayload({'kind': 'end', 'count': index});
      await output.flush();
      await output.close();
      output = null;
    } catch (error) {
      if (output != null) {
        try {
          await output.close();
        } catch (_) {
          /* Preserve original failure. */
        }
      }
      if (created) {
        try {
          await file.delete();
        } catch (_) {
          /* Owned partial file only. */
        }
      }
      if (error is HealthBackupException) rethrow;
      throw const HealthBackupException(
        'Unable to create the encrypted Health backup. Check the destination and try again.',
      );
    }
  }

  Future<void> restoreFromFile(String path, String passphrase) async {
    _validate(path, passphrase);
    try {
      final file = File(path);
      final stat = await file.stat();
      if (stat.type != FileSystemEntityType.file || stat.size > _maxBytes) {
        throw const FormatException('Invalid file');
      }
      // Fully authenticate before starting the destructive replacement transaction.
      // The second pass also authenticates every record: changes during restore
      // abort the repository transaction and preserve the previous vault.
      final first = await _readHeader(file);
      final key = await _derive(passphrase, first.salt);
      await for (final _ in _decrypt(file, first.header, first.prefix, key)) {}
      final nextStat = await file.stat();
      if (nextStat.size != stat.size || nextStat.modified != stat.modified) {
        throw const FormatException('Changed file');
      }
      await _repository.restoreChunks(
        _decrypt(file, first.header, first.prefix, key),
      );
    } catch (_) {
      throw const HealthBackupException(
        'Unable to restore this Health backup. The passphrase may be incorrect or the file damaged. Your previous vault was preserved.',
      );
    }
  }

  Future<({String header, List<int> salt, List<int> prefix})> _readHeader(
    File file,
  ) async {
    final lines = _lines(file);
    final header = await lines.first;
    if (header.length > 1024) throw const FormatException('Header size');
    final map = jsonDecode(header) as Map<String, dynamic>;
    if (map.length != 6 ||
        map['format'] != 'private-health' ||
        map['version'] != 1 ||
        map['kdf'] != 'PBKDF2-HMAC-SHA256' ||
        map['iterations'] != _iterations) {
      throw const FormatException('Unsupported format');
    }
    final salt = base64Decode(map['salt'] as String);
    final prefix = base64Decode(map['noncePrefix'] as String);
    if (salt.length != 16 || prefix.length != 8) {
      throw const FormatException('Invalid header');
    }
    return (header: header, salt: salt, prefix: prefix);
  }

  Stream<List<Map<String, Object?>>> _decrypt(
    File file,
    String header,
    List<int> prefix,
    SecretKey key,
  ) async* {
    var lineIndex = 0;
    var index = 0;
    var ended = false;
    await for (final line in _lines(file)) {
      if (lineIndex++ == 0) {
        if (line != header) throw const FormatException('Changed header');
        continue;
      }
      if (ended || index > _maxChunks) {
        throw const FormatException('Unexpected record');
      }
      final map = jsonDecode(line) as Map<String, dynamic>;
      if (map.length != 3 || map['index'] != index) {
        throw const FormatException('Chunk order');
      }
      final mac = base64Decode(map['mac'] as String);
      if (mac.length != 16) throw const FormatException('Invalid MAC');
      final plain = await _cipher.decrypt(
        SecretBox(
          base64Decode(map['ciphertext'] as String),
          nonce: _nonce(prefix, index),
          mac: Mac(mac),
        ),
        secretKey: key,
        aad: utf8.encode('$header\n$index'),
      );
      final payload = jsonDecode(utf8.decode(plain)) as Map<String, dynamic>;
      if (payload['kind'] == 'end') {
        if (payload.length != 2 || payload['count'] != index) {
          throw const FormatException('Invalid end');
        }
        ended = true;
      } else if (payload['kind'] == 'data' && payload.length == 2) {
        final rows = payload['rows'] as List<dynamic>;
        if (rows.length > 500) throw const FormatException('Chunk size');
        yield rows.map((row) => Map<String, Object?>.from(row as Map)).toList();
      } else {
        throw const FormatException('Invalid payload');
      }
      index++;
    }
    if (!ended) throw const FormatException('Truncated backup');
  }

  // Bound bytes before UTF-8 decoding/JSON parsing. LineSplitter alone retains
  // an arbitrarily long malicious line in memory.
  Stream<String> _lines(File file) async* {
    final line = BytesBuilder(copy: false);
    var total = 0;
    await for (final bytes in file.openRead()) {
      total += bytes.length;
      if (total > _maxBytes) throw const FormatException('File size');
      var start = 0;
      for (var i = 0; i < bytes.length; i++) {
        if (bytes[i] != 10) continue;
        if (line.length + i - start > _maxLine) {
          throw const FormatException('Line size');
        }
        line.add(bytes.sublist(start, i));
        yield utf8.decode(line.takeBytes());
        start = i + 1;
      }
      if (line.length + bytes.length - start > _maxLine) {
        throw const FormatException('Line size');
      }
      line.add(bytes.sublist(start));
    }
    if (line.length != 0) throw const FormatException('Incomplete line');
  }

  Future<SecretKey> _derive(String passphrase, List<int> salt) async {
    // Password stretching must not freeze the mobile UI.
    final bytes = await Isolate.run(() async {
      final key = await Pbkdf2(
        macAlgorithm: Hmac.sha256(),
        iterations: _iterations,
        bits: 256,
      ).deriveKey(secretKey: SecretKey(utf8.encode(passphrase)), nonce: salt);
      return key.extractBytes();
    });
    return SecretKey(bytes);
  }

  List<int> _random(int length) {
    final random = Random.secure();
    return List<int>.generate(length, (_) => random.nextInt(256));
  }

  List<int> _nonce(List<int> prefix, int index) => [
    ...prefix,
    (index >> 24) & 255,
    (index >> 16) & 255,
    (index >> 8) & 255,
    index & 255,
  ];

  void _validate(String path, String passphrase) {
    if (!path.toLowerCase().endsWith('.healthbackup')) {
      throw const HealthBackupException('Choose a .healthbackup file.');
    }
    if (passphrase.trim().length < 12 || passphrase.length > 1024) {
      throw const HealthBackupException(
        'Use a passphrase of at least 12 characters (maximum 1024).',
      );
    }
  }
}
