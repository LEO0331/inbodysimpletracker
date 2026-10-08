import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inbodysimpletracker/data/models/health_observation.dart';
import 'package:inbodysimpletracker/data/services/health_import_service.dart';
import 'package:inbodysimpletracker/data/services/health_repository.dart';
import 'package:inbodysimpletracker/core/utils/health_units.dart';
import 'package:inbodysimpletracker/data/services/health_xml_parser.dart';

class _Repository extends HealthRepository {
  final committed = <String, HealthObservation>{};
  final staged = <HealthObservation>[];
  bool aborted = false;
  int batch = 0;
  void Function()? afterAppend;
  @override
  Future<String> beginImport() async {
    staged.clear();
    return '${++batch}';
  }

  @override
  Future<int> appendObservations(
    String id,
    List<HealthObservation> rows,
  ) async {
    staged.addAll(rows);
    afterAppend?.call();
    return rows.where((r) => !committed.containsKey(r.id)).length;
  }

  @override
  Future<void> finishImport(String id, {required int skippedCount}) async {
    for (final row in staged) {
      committed.putIfAbsent(row.id, () => row);
    }
    staged.clear();
  }

  @override
  Future<void> abortImport(String id) async {
    aborted = true;
    staged.clear();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

String _record({
  String type = 'HKQuantityTypeIdentifierBodyMass',
  String value = '70',
  String unit = 'kg',
  String source = 'Synthetic',
  String children = '',
}) =>
    '<Record type="$type" sourceName="$source" sourceVersion="1" device="Synthetic device" unit="$unit" value="$value" creationDate="2025-01-01 08:00:00 +0800" startDate="2025-01-01 08:00:00 +0800" endDate="2025-01-01 08:00:00 +0800">$children</Record>';
Stream<List<int>> _chunks(String text, {int chunkSize = 7}) async* {
  final bytes = utf8.encode(text);
  for (var i = 0; i < bytes.length; i += chunkSize) {
    yield bytes.sublist(
      i,
      i + chunkSize > bytes.length ? bytes.length : i + chunkSize,
    );
  }
}

void main() {
  test(
    'equivalent original timestamps canonicalize to the same sample identity',
    () async {
      final repo = _Repository();
      final importer = HealthImportService(repo);
      final first = '<HealthData>${_record()}</HealthData>';
      expect((await importer.importStream(_chunks(first))).imported, 1);
      final creationOnly = first.replaceAll(
        'creationDate="2025-01-01 08:00:00 +0800"',
        'creationDate="2025-01-01 00:00:00 +0000"',
      );
      expect((await importer.importStream(_chunks(creationOnly))).imported, 0);
      final allUtc = first.replaceAll(
        '2025-01-01 08:00:00 +0800',
        '2025-01-01 00:00:00 +0000',
      );
      expect((await importer.importStream(_chunks(allUtc))).imported, 0);
      expect(repo.committed.length, 1);
      expect(repo.committed.values.single.offsetMinutes, 480);
    },
  );
  test(
    'volatile HKDevice pointers and source app versions never change identity',
    () async {
      for (final metadata in [
        '',
        '<MetadataEntry key="HKMetadataKeySyncIdentifier" value="synthetic-id"/>',
      ]) {
        final repo = _Repository();
        final importer = HealthImportService(repo);
        String xml(String pointer, String model, {String version = '1'}) =>
            '<HealthData>${_record(children: metadata).replaceAll('Synthetic device', '&lt;HKDevice: $pointer, name:Synthetic, model:$model&gt;').replaceAll('sourceVersion="1"', 'sourceVersion="$version"')}</HealthData>';
        expect(
          (await importer.importStream(
            _chunks(xml('0x123AB', 'Synthetic A')),
          )).imported,
          1,
        );
        final first = repo.committed.values.single;
        expect(
          (await importer.importStream(
            _chunks(xml('0x987CD', 'Synthetic A', version: '2')),
          )).imported,
          0,
        );
        expect(repo.committed.values.single.id, first.id);
        expect(repo.committed.values.single.logicalId, first.logicalId);
        expect(
          (await importer.importStream(
            _chunks(xml('0x987CD', 'Synthetic B')),
          )).imported,
          1,
        );
        expect(repo.committed.values.map((s) => s.id).toSet().length, 2);
        expect(
          repo.committed.values.map((s) => s.logicalId).toSet().length,
          metadata.isEmpty ? 2 : 1,
        );
      }
    },
  );
  test('timestamps require explicit offset and a real calendar date', () async {
    final repo = _Repository();
    final record = _record().replaceAll('2025-01-01', '2025-02-31');
    final result = await HealthImportService(
      repo,
    ).importStream(_chunks('<HealthData>$record</HealthData>'));
    expect(result.skipped, 1);
    expect(repo.committed, isEmpty);
    final missing = _record().replaceAll(' +0800', '');
    expect(
      (await HealthImportService(
        repo,
      ).importStream(_chunks('<HealthData>$missing</HealthData>'))).skipped,
      1,
    );
  });
  test('bounded parser rejects deep nesting and giant quoted tokens', () async {
    final importer = HealthImportService(_Repository());
    final nested =
        '<HealthData>${List.filled(40, '<x>').join()}${List.filled(40, '</x>').join()}</HealthData>';
    await expectLater(
      importer.importStream(_chunks(nested)),
      throwsA(isA<HealthImportException>()),
    );
    final huge =
        '<HealthData><Record sourceName="${List.filled(1024 * 1024 + 1, '>').join()}"/></HealthData>';
    await expectLater(
      importer.importStream(_chunks(huge, chunkSize: 65536)),
      throwsA(isA<HealthImportException>()),
    );
  });
  test(
    'incremental UTF8, standard Apple DTD, units and metadata identity',
    () async {
      final repo = _Repository();
      final importer = HealthImportService(repo);
      final xml =
          '<!DOCTYPE HealthData [<!ELEMENT HealthData ANY>]><HealthData><Me age="ignored"/>${_record(value: '154.3235835294143', unit: 'lb', source: '測試', children: '<MetadataEntry key="HKMetadataKeySyncIdentifier" value="synthetic-key"/><MetadataEntry key="HKMetadataKeySyncVersion" value="1"/><MetadataEntry key="HKTimeZone" value="Asia/Taipei"/>')}</HealthData>';
      final first = await importer.importStream(_chunks(xml, chunkSize: 1));
      expect(first.imported, 1);
      final sample = repo.committed.values.single;
      expect(sample.value, closeTo(70, .0001));
      expect(sample.originalUnit, 'lb');
      expect(sample.start, DateTime.utc(2025, 1, 1));
      expect(sample.offsetMinutes, 480);
      expect(sample.timeZone, 'Asia/Taipei');
      expect(sample.syncVersion, 1);
      expect((await importer.importStream(_chunks(xml))).imported, 0);
      await importer.importStream(
        _chunks(
          xml
              .replaceAll('value="1"', 'value="2"')
              .replaceAll('154.3235835294143', '155'),
        ),
      );
      expect(repo.committed.length, 2);
      expect(repo.committed.values.map((s) => s.logicalId).toSet().length, 1);
    },
  );
  test(
    'unknown types/units and invalid values skipped, legitimate zero retained',
    () async {
      final repo = _Repository();
      final result = await HealthImportService(repo).importStream(
        _chunks(
          '<HealthData>${_record(unit: 'mystery')}${_record(value: 'NaN')}${_record(type: 'unsupported')}${_record(type: 'HKQuantityTypeIdentifierStepCount', unit: 'count', value: '0')}</HealthData>',
        ),
      );
      expect(result.processed, 4);
      expect(result.skipped, 3);
      expect(result.imported, 1);
      expect(repo.committed.values.single.value, 0);
    },
  );
  test(
    'malformed XML and entity/CDA attacks abort without altering prior history',
    () async {
      final repo = _Repository();
      final importer = HealthImportService(repo);
      await importer.importStream(
        _chunks('<HealthData>${_record()}</HealthData>'),
      );
      for (final xml in [
        '<ClinicalDocument/>',
        '<HealthData>${_record()}',
        '<!DOCTYPE HealthData SYSTEM "https://invalid.test/private"><HealthData/>',
        '<!DOCTYPE HealthData [<!ENTITY secret "sensitive-marker">]><HealthData/>',
        '<HealthData><Record></HealthData>',
      ]) {
        await expectLater(
          importer.importStream(_chunks(xml)),
          throwsA(
            isA<HealthImportException>().having(
              (e) => e.message,
              'sanitized',
              isNot(contains('sensitive-marker')),
            ),
          ),
        );
        expect(repo.committed.length, 1);
        expect(repo.staged, isEmpty);
      }
    },
  );
  test('cancel aborts staged rows and permits subsequent import', () async {
    final repo = _Repository();
    final importer = HealthImportService(repo);
    repo.afterAppend = importer.cancel;
    await expectLater(
      importer.importStream(_chunks('<HealthData>${_record()}</HealthData>')),
      throwsA(isA<HealthImportException>()),
    );
    expect(repo.aborted, true);
    expect(repo.committed, isEmpty);
    repo.afterAppend = null;
    expect(
      (await importer.importStream(
        _chunks('<HealthData>${_record()}</HealthData>'),
      )).imported,
      1,
    );
  });
  test(
    'cancel interrupts a stream that has not emitted a single byte',
    () async {
      final repo = _Repository();
      final importer = HealthImportService(repo);
      var sourceCancelled = false;
      final controller = StreamController<List<int>>(
        onCancel: () {
          sourceCancelled = true;
        },
      );
      final result = importer.importStream(controller.stream);
      Timer(const Duration(milliseconds: 20), importer.cancel);
      await expectLater(
        result.timeout(const Duration(seconds: 2)),
        throwsA(isA<HealthImportException>()),
      );
      expect(sourceCancelled, true);
      expect(repo.aborted, true);
      await controller.close();
    },
  );
  test(
    'excluded-only XML emits bounded batches and accepts cancellation',
    () async {
      final xml =
          '<HealthData>${List.filled(2000, '<ActivitySummary/>').join()}</HealthData>';
      final batches = await parseHealthXml(
        _chunks(xml, chunkSize: 65536),
      ).toList();
      expect(batches.length, greaterThanOrEqualTo(4));
      expect(
        batches.every(
          (b) => (b['rows'] as List).isEmpty && b['processed'] == 0,
        ),
        true,
      );
      final repo = _Repository();
      final importer = HealthImportService(repo);
      await expectLater(
        importer.importStream(
          _chunks(xml),
          onProgress: (_) => importer.cancel(),
        ),
        throwsA(isA<HealthImportException>()),
      );
      expect(repo.aborted, true);
    },
  );
  test(
    'file worker streams ZIP primary only and rejects traversal/duplicate exports',
    () async {
      final temp = await Directory.systemTemp.createTemp(
        'synthetic-health-test-',
      );
      try {
        Future<File> zip(List<String> names) async {
          final archive = Archive();
          final bytes = utf8.encode('<HealthData>${_record()}</HealthData>');
          for (final name in names) {
            archive.add(ArchiveFile(name, bytes.length, bytes));
          }
          return File('${temp.path}/synthetic.zip')
            ..writeAsBytesSync(ZipEncoder().encode(archive));
        }

        final repo = _Repository();
        final importer = HealthImportService(repo);
        expect(
          (await importer.importFile(
            (await zip([
              'apple_health_export/export.xml',
              'apple_health_export/export_cda.xml',
            ])).path,
          )).imported,
          1,
        );
        for (final names in [
          ['../export.xml'],
          ['export.xml', 'apple_health_export/export.xml'],
          ['export_cda.xml'],
        ]) {
          await expectLater(
            importer.importFile((await zip(names)).path),
            throwsA(isA<HealthImportException>()),
          );
          expect(repo.committed.length, 1);
        }
        // Mutations affect only a temporary synthetic archive: reject central
        // symlink modes, expanded-size bombs and checksum mismatch.
        for (final mutation in ['symlink', 'oversize', 'crc']) {
          final fixture = await zip(['export.xml']);
          final data = await fixture.readAsBytes();
          final view = ByteData.sublistView(data);
          for (var i = 0; i < data.length - 46; i++) {
            if (view.getUint32(i, Endian.little) != 0x02014b50) continue;
            if (mutation == 'symlink') {
              view.setUint32(i + 38, 0xa0000000, Endian.little);
            }
            if (mutation == 'oversize') {
              view.setUint32(i + 24, 0xffffffff, Endian.little);
            }
            if (mutation == 'crc') view.setUint32(i + 16, 0, Endian.little);
            break;
          }
          await fixture.writeAsBytes(data);
          await expectLater(
            importer.importFile(fixture.path),
            throwsA(isA<HealthImportException>()),
            reason: mutation,
          );
          expect(repo.committed.length, 1);
        }
        for (final mutation in [
          'zip64Locator',
          'fakeEocdComment',
          'countMismatch',
          'directoryOutOfBounds',
        ]) {
          final fixture = await zip(['export.xml']);
          final data = await fixture.readAsBytes();
          final view = ByteData.sublistView(data);
          final eocd = data.length - 22;
          if (mutation == 'zip64Locator') {
            // The 20 bytes directly preceding EOCD can override its bounds
            // even when no legacy field carries a ZIP64 sentinel.
            view.setUint32(
              eocd - 20,
              ZipDirectory.zip64EocdLocatorSignature,
              Endian.little,
            );
            await fixture.writeAsBytes(data);
          } else if (mutation == 'fakeEocdComment') {
            view.setUint16(eocd + 20, 24, Endian.little);
            final comment = Uint8List(24);
            final fake = ByteData.sublistView(comment);
            fake.setUint32(0, ZipDirectory.eocdSignature, Endian.little);
            // This fake's comment length intentionally fails the strict check.
            // The archive library nevertheless selects this last signature.
            await fixture.writeAsBytes([...data, ...comment]);
          } else {
            if (mutation == 'countMismatch') {
              view.setUint16(eocd + 8, 0, Endian.little);
              view.setUint16(eocd + 10, 0, Endian.little);
            } else {
              view.setUint32(eocd + 16, data.length - 1, Endian.little);
            }
            await fixture.writeAsBytes(data);
          }
          await expectLater(
            importer.importFile(fixture.path),
            throwsA(isA<HealthImportException>()),
            reason: mutation,
          );
          expect(repo.committed.length, 1);
        }
        for (final mutation in [
          'duplicateLocalOffset',
          'localPathMismatch',
          'localNameOversized',
          'localExtraOutOfBounds',
          'compressedDataOutOfBounds',
        ]) {
          final fixture = await zip(
            mutation == 'duplicateLocalOffset'
                ? ['export.xml', 'other.xml']
                : ['export.xml'],
          );
          final data = await fixture.readAsBytes();
          final view = ByteData.sublistView(data);
          final centralOffset = view.getUint32(
            data.length - 22 + 16,
            Endian.little,
          );
          final localOffset = view.getUint32(centralOffset + 42, Endian.little);
          if (mutation == 'duplicateLocalOffset') {
            final next =
                centralOffset +
                46 +
                view.getUint16(centralOffset + 28, Endian.little) +
                view.getUint16(centralOffset + 30, Endian.little) +
                view.getUint16(centralOffset + 32, Endian.little);
            view.setUint32(next + 42, localOffset, Endian.little);
          } else if (mutation == 'localPathMismatch') {
            data[localOffset + 30] = 'x'.codeUnitAt(0);
          } else if (mutation == 'localNameOversized') {
            view.setUint16(localOffset + 26, 65535, Endian.little);
          } else if (mutation == 'localExtraOutOfBounds') {
            view.setUint16(localOffset + 28, 65535, Endian.little);
          } else {
            view.setUint32(centralOffset + 20, data.length, Endian.little);
            view.setUint32(localOffset + 18, data.length, Endian.little);
          }
          await fixture.writeAsBytes(data);
          await expectLater(
            importer.importFile(fixture.path),
            throwsA(isA<HealthImportException>()),
            reason: mutation,
          );
          expect(repo.committed.length, 1);
        }
        // A legitimate bit-3 archive stores CRC/sizes in a data descriptor,
        // with zero values in the local header. Keep accepting that form.
        final descriptorFile = await zip(['export.xml']);
        final original = await descriptorFile.readAsBytes();
        final originalView = ByteData.sublistView(original);
        final centralOffset = originalView.getUint32(
          original.length - 22 + 16,
          Endian.little,
        );
        final localOffset = originalView.getUint32(
          centralOffset + 42,
          Endian.little,
        );
        final descriptor = Uint8List(16);
        final descriptorView = ByteData.sublistView(descriptor);
        descriptorView.setUint32(0, 0x08074b50, Endian.little);
        for (var i = 0; i < 3; i++) {
          descriptorView.setUint32(
            4 + i * 4,
            originalView.getUint32(localOffset + 14 + i * 4, Endian.little),
            Endian.little,
          );
        }
        final expanded = Uint8List.fromList([
          ...original.sublist(0, centralOffset),
          ...descriptor,
          ...original.sublist(centralOffset),
        ]);
        final expandedView = ByteData.sublistView(expanded);
        expandedView.setUint16(
          localOffset + 6,
          expandedView.getUint16(localOffset + 6, Endian.little) | 8,
          Endian.little,
        );
        expandedView.setUint16(
          centralOffset + 16 + 8,
          expandedView.getUint16(centralOffset + 16 + 8, Endian.little) | 8,
          Endian.little,
        );
        expandedView.setUint32(
          expanded.length - 22 + 16,
          centralOffset + 16,
          Endian.little,
        );
        for (var i = 0; i < 3; i++) {
          expandedView.setUint32(localOffset + 14 + i * 4, 0, Endian.little);
        }
        await descriptorFile.writeAsBytes(expanded);
        expect((await importer.importFile(descriptorFile.path)).imported, 0);
        final plain = File('${temp.path}/synthetic.xml')
          ..writeAsStringSync('<HealthData>${_record()}</HealthData>');
        final excluded = File('${temp.path}/excluded.xml')
          ..writeAsStringSync(
            '<HealthData>${List.filled(2000, '<ActivitySummary/>').join()}</HealthData>',
          );
        await expectLater(
          importer.importFile(
            excluded.path,
            onProgress: (_) => importer.cancel(),
          ),
          throwsA(isA<HealthImportException>()),
        );
        expect(repo.staged, isEmpty);
        expect((await importer.importFile(plain.path)).imported, 0);
        expect(await plain.exists(), true);
      } finally {
        await temp.delete(recursive: true);
      }
    },
  );
  test('strict verified unit conversion', () {
    expect(
      normalizeHealthUnit(HealthMetric.distance, 'mi', '1')?.value,
      1.609344,
    );
    expect(normalizeHealthUnit(HealthMetric.hrvSdnn, 's', '.04')?.value, 40);
    expect(
      normalizeHealthUnit(
        HealthMetric.restingHeartRate,
        'count/min',
        '60',
      )?.unit,
      'count/min',
    );
    expect(normalizeHealthUnit(HealthMetric.steps, 'kg', '1'), isNull);
    expect(normalizeHealthUnit(HealthMetric.weight, 'kg', '-1'), isNull);
    expect(normalizeHealthUnit(HealthMetric.weight, 'kg', 'Infinity'), isNull);
  });
}
