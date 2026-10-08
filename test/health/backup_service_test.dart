import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inbodysimpletracker/data/services/health_backup_service.dart';
import 'package:inbodysimpletracker/data/services/health_repository.dart';

class _Repository extends HealthRepository {
  List<Map<String, Object?>> rows = [];
  int restoreCalls = 0;
  bool failRestore = false;
  bool failExport = false;
  bool batchExport = false;

  @override
  Stream<List<Map<String, Object?>>> exportChunks({
    int chunkSize = 500,
  }) async* {
    if (batchExport) {
      yield rows;
      return;
    }
    for (final row in rows) {
      yield [row];
    }
    if (failExport) throw StateError('Synthetic export failure');
  }

  @override
  Future<void> restoreChunks(Stream<List<Map<String, Object?>>> chunks) async {
    restoreCalls++;
    final replacement = <Map<String, Object?>>[];
    await for (final chunk in chunks) {
      replacement.addAll(chunk);
    }
    if (failRestore) throw StateError('Synthetic transaction failure');
    rows = replacement;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> _writeFixture(
  String path,
  int version,
  List<Map<String, Object?>> rows,
  SecretKey key,
) async {
  final prefix = List<int>.filled(8, 7);
  final header = jsonEncode({
    'format': 'private-health',
    'version': version,
    'kdf': 'PBKDF2-HMAC-SHA256',
    'iterations': 600000,
    'salt': base64Encode(List<int>.filled(16, 3)),
    'noncePrefix': base64Encode(prefix),
  });
  final lines = [header];
  final payloads = [
    {'kind': 'data', 'rows': rows},
    {'kind': 'end', 'count': 1},
  ];
  for (var index = 0; index < payloads.length; index++) {
    final box = await AesGcm.with256bits().encrypt(
      utf8.encode(jsonEncode(payloads[index])),
      secretKey: key,
      nonce: [...prefix, 0, 0, 0, index],
      aad: utf8.encode('$header\n$index'),
    );
    lines.add(
      jsonEncode({
        'index': index,
        'ciphertext': base64Encode(box.cipherText),
        'mac': base64Encode(box.mac.bytes),
      }),
    );
  }
  await File(path).writeAsString('${lines.join('\n')}\n');
}

void main() {
  const password = 'synthetic backup passphrase';
  late Directory directory;
  late String original;
  late List<String> encryptedLines;
  late SecretKey fixtureKey;
  final cursor = <String, Object?>{
    'table': 'healthkit_cursors',
    'metric': 'steps',
    'anchor': base64Encode([1, 2, 3]),
    'batch_id': 'healthkit_live:steps',
    'updated_ms': 123456,
  };
  final records = <Map<String, Object?>>[
    {
      'table': 'notes',
      'id': 'synthetic-note',
      'text': 'PRIVATE_SYNTHETIC_MARKER',
    },
    {'table': 'batches', 'id': 'synthetic-batch'},
  ];

  setUpAll(() async {
    directory = await Directory.systemTemp.createTemp('health-backup-test-');
    original = '${directory.path}/original.healthbackup';
    final repository = _Repository()..rows = records;
    await HealthBackupService(repository).exportToFile(original, password);
    encryptedLines = await File(original).readAsLines();
    fixtureKey =
        await Pbkdf2(
          macAlgorithm: Hmac.sha256(),
          iterations: 600000,
          bits: 256,
        ).deriveKey(
          secretKey: SecretKey(utf8.encode(password)),
          nonce: List<int>.filled(16, 3),
        );
  });

  tearDownAll(() async => directory.delete(recursive: true));

  test('writes version 2 and restores encrypted HealthKit cursors', () async {
    expect((jsonDecode(encryptedLines.first) as Map)['version'], 2);
    final rows = [...records, cursor];
    final path = '${directory.path}/cursors.healthbackup';
    await HealthBackupService(
      _Repository()..rows = rows,
    ).exportToFile(path, password);
    expect(
      await File(path).readAsString(),
      isNot(contains('healthkit_live:steps')),
    );
    final restored = _Repository();
    await HealthBackupService(restored).restoreFromFile(path, password);
    expect(restored.rows, rows);
  });

  test('reads existing version 1 backups', () async {
    final path = '${directory.path}/legacy.healthbackup';
    await _writeFixture(path, 1, records, fixtureKey);
    final restored = _Repository();
    await HealthBackupService(restored).restoreFromFile(path, password);
    expect(restored.rows, records);
  });

  test('rejects cursors in version 1 before replacing the vault', () async {
    final path = '${directory.path}/legacy-cursor.healthbackup';
    await _writeFixture(path, 1, [cursor], fixtureKey);
    final restored = _Repository()..rows = records;
    await expectLater(
      HealthBackupService(restored).restoreFromFile(path, password),
      throwsA(isA<HealthBackupException>()),
    );
    expect(restored.restoreCalls, 0);
    expect(restored.rows, records);
  });

  test('invalid version 2 cursor fields never reach replacement', () async {
    final invalid = [
      {...cursor, 'extra': true},
      {...cursor, 'metric': 'clinical'},
      {...cursor, 'batch_id': 'xml-batch'},
      {...cursor, 'updated_ms': -1},
      {...cursor, 'anchor': 'not-base64'},
      {...cursor, 'anchor': base64Encode(List<int>.filled(49153, 1))},
    ];
    for (var index = 0; index < invalid.length; index++) {
      final path = '${directory.path}/bad-cursor-$index.healthbackup';
      await _writeFixture(path, 2, [invalid[index]], fixtureKey);
      final restored = _Repository()..rows = records;
      await expectLater(
        HealthBackupService(restored).restoreFromFile(path, password),
        throwsA(isA<HealthBackupException>()),
      );
      expect(restored.restoreCalls, 0);
      expect(restored.rows, records);
    }
  });

  test(
    'encrypted backup restores rows and notes without exposing markers',
    () async {
      expect(
        await File(original).readAsString(),
        isNot(contains('PRIVATE_SYNTHETIC_MARKER')),
      );
      final repository = _Repository()
        ..rows = [
          {'table': 'notes', 'id': 'previous'},
        ];
      await HealthBackupService(repository).restoreFromFile(original, password);
      expect(repository.rows, records);
      expect(repository.restoreCalls, 1);
    },
  );

  test(
    'wrong password authenticates before touching the previous vault',
    () async {
      final repository = _Repository()
        ..rows = [
          {'table': 'notes', 'id': 'previous'},
        ];
      await expectLater(
        HealthBackupService(
          repository,
        ).restoreFromFile(original, 'wrong but sufficiently long'),
        throwsA(isA<HealthBackupException>()),
      );
      expect(repository.restoreCalls, 0);
      expect(repository.rows.single['id'], 'previous');
    },
  );

  test(
    'tampering, truncation and reordering all preserve previous vault',
    () async {
      final tampered = List<String>.from(encryptedLines);
      final payload = jsonDecode(tampered[1]) as Map<String, dynamic>;
      final ciphertext = base64Decode(payload['ciphertext'] as String);
      ciphertext[0] ^= 1;
      payload['ciphertext'] = base64Encode(ciphertext);
      tampered[1] = jsonEncode(payload);
      final reordered = List<String>.from(encryptedLines);
      reordered[1] = encryptedLines[2];
      reordered[2] = encryptedLines[1];
      final variants = [
        tampered,
        encryptedLines.sublist(0, encryptedLines.length - 1),
        reordered,
      ];
      for (var index = 0; index < variants.length; index++) {
        final path = '${directory.path}/invalid-$index.healthbackup';
        await File(path).writeAsString('${variants[index].join('\n')}\n');
        final repository = _Repository()
          ..rows = [
            {'table': 'notes', 'id': 'previous'},
          ];
        await expectLater(
          HealthBackupService(repository).restoreFromFile(path, password),
          throwsA(isA<HealthBackupException>()),
        );
        expect(repository.restoreCalls, 0);
        expect(repository.rows.single['id'], 'previous');
      }
    },
  );

  test(
    'unsafe KDF parameters rejected before expensive password derivation',
    () async {
      final header = jsonDecode(encryptedLines.first) as Map<String, dynamic>;
      header['iterations'] = 999999999999;
      final path = '${directory.path}/kdf.healthbackup';
      await File(path).writeAsString('${jsonEncode(header)}\n');
      final repository = _Repository();
      await expectLater(
        HealthBackupService(repository).restoreFromFile(path, password),
        throwsA(isA<HealthBackupException>()),
      );
      expect(repository.restoreCalls, 0);
    },
  );

  test('existing destination is not overwritten or removed', () async {
    final before = await File(original).readAsBytes();
    await expectLater(
      HealthBackupService(_Repository()).exportToFile(original, password),
      throwsA(isA<HealthBackupException>()),
    );
    expect(await File(original).readAsBytes(), before);
  });

  test('export failure deletes only its owned partial file', () async {
    final path = '${directory.path}/partial.healthbackup';
    final repository = _Repository()..failExport = true;
    await expectLater(
      HealthBackupService(repository).exportToFile(path, password),
      throwsA(isA<HealthBackupException>()),
    );
    expect(await File(path).exists(), false);
    expect(await File(original).exists(), true);
  });

  test('restore transaction failure preserves prior records', () async {
    final repository = _Repository()
      ..rows = [
        {'table': 'notes', 'id': 'previous'},
      ]
      ..failRestore = true;
    await expectLater(
      HealthBackupService(repository).restoreFromFile(original, password),
      throwsA(isA<HealthBackupException>()),
    );
    expect(repository.rows.single['id'], 'previous');
  });

  test('requires a meaningful passphrase and backup extension', () async {
    final service = HealthBackupService(_Repository());
    await expectLater(
      service.exportToFile('${directory.path}/unsafe.xml', password),
      throwsA(isA<HealthBackupException>()),
    );
    await expectLater(
      service.exportToFile('${directory.path}/weak.healthbackup', 'short'),
      throwsA(isA<HealthBackupException>()),
    );
  });

  test(
    'large valid Unicode notes split by UTF-8 bytes and round trip in order',
    () async {
      // 350 notes at 4000 three-byte characters exceed both a single 1 MiB
      // plaintext frame and the outer 2 MiB line cap without splitting.
      final text = List.filled(4000, '漢').join();
      final rows = List<Map<String, Object?>>.generate(
        350,
        (index) => {
          'table': 'notes',
          'id': 'synthetic-large-$index',
          'text': text,
        },
      );
      final repository = _Repository()
        ..rows = rows
        ..batchExport = true;
      final path = '${directory.path}/unicode.healthbackup';
      await HealthBackupService(repository).exportToFile(path, password);
      var lineCount = 0;
      await for (final line in File(
        path,
      ).openRead().transform(utf8.decoder).transform(const LineSplitter())) {
        expect(utf8.encode(line).length, lessThanOrEqualTo(2 * 1024 * 1024));
        lineCount++;
      }
      expect(lineCount, greaterThan(3));
      final restored = _Repository();
      await HealthBackupService(restored).restoreFromFile(path, password);
      expect(restored.rows, rows);
    },
  );
}
