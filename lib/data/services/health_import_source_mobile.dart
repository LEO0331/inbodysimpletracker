import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:flutter/services.dart';
import 'health_xml_parser.dart';

/// One outstanding batch per worker: database writes acknowledge before parsing
/// resumes. No entire file, expanded archive, or complete observation list loads.
Stream<Map<String, Object>> parseHealthFile(
  String path, {
  void Function(void Function())? onCancelReady,
}) async* {
  if (Platform.isIOS || Platform.isAndroid) {
    if (await FileSystemEntity.type(path, followLinks: false) !=
        FileSystemEntityType.file) {
      throw const FormatException('Protected import unavailable.');
    }
    const privacy = MethodChannel('inbodysimpletracker/private_health');
    final protected = await privacy.invokeMethod<bool>('protectImportFile', {
      'path': path,
    });
    if (protected != true) {
      throw const FormatException('Protected import unavailable.');
    }
  }
  final output = ReceivePort();
  final exited = ReceivePort();
  Isolate? worker;
  SendPort? control;
  var cancelled = false;
  onCancelReady?.call(() {
    cancelled = true;
    control?.send('cancel');
    if (control != null) output.close();
  });
  try {
    worker = await Isolate.spawn(
      _worker,
      [path, output.sendPort],
      onError: output.sendPort,
      onExit: exited.sendPort,
    );
    await for (final message in output) {
      if (message is! Map || message['error'] == true) {
        throw const FormatException();
      }
      if (message['control'] case final SendPort workerControl) {
        control = workerControl;
        if (cancelled) {
          control.send('cancel');
          output.close();
        }
        continue;
      }
      if (message['done'] == true) break;
      yield Map<String, Object>.from(message['batch'] as Map);
      (message['ack'] as SendPort).send(true);
    }
  } finally {
    // Let the worker close its original file handles before reporting exit.
    // Killing an isolate can leave native file IO cleanup pending on Windows.
    control?.send('cancel');
    output.close();
    if (worker != null) await exited.first;
    exited.close();
  }
}

Future<void> _worker(List<Object> args) async {
  final port = args[1] as SendPort;
  final acknowledgements = ReceivePort();
  final control = ReceivePort();
  final cancelledSignal = Completer<void>();
  var cancelled = false;
  control.listen((_) {
    cancelled = true;
    if (!cancelledSignal.isCompleted) cancelledSignal.complete();
  });
  port.send({'control': control.sendPort});
  final iterator = StreamIterator(acknowledgements);
  try {
    await for (final batch in parseHealthXml(
      _fileBytes(args[0] as String, () => cancelled),
    )) {
      if (cancelled) break;
      port.send({'batch': batch, 'ack': acknowledgements.sendPort});
      if (!await Future.any([
        iterator.moveNext(),
        cancelledSignal.future.then((_) => false),
      ])) {
        break;
      }
    }
    port.send({'done': true});
  } catch (_) {
    // Never transmit native errors, file paths, XML excerpts or source values.
    port.send({'error': true});
  } finally {
    await iterator.cancel();
    acknowledgements.close();
    control.close();
  }
}

Stream<List<int>> _fileBytes(String path, bool Function() isCancelled) async* {
  final file = File(path);
  if (await file.length() > healthImportMaxBytes) throw const FormatException();
  if (path.toLowerCase().endsWith('.xml')) {
    final input = InputFileStream(path);
    try {
      while (!input.isEOS) {
        if (isCancelled()) throw const FormatException();
        yield input.readBytes(65536).toUint8List();
        await Future<void>.delayed(Duration.zero);
      }
    } finally {
      input.closeSync();
    }
    return;
  }
  if (!path.toLowerCase().endsWith('.zip')) throw const FormatException();
  // Bound central-directory metadata before the archive library reads entries.
  final handle = await file.open();
  var verifiedEocd = -1;
  var verifiedCount = 0;
  var verifiedDirectorySize = 0;
  var verifiedDirectoryOffset = 0;
  try {
    final size = await handle.length();
    final tailSize = size < 65557 ? size : 65557;
    await handle.setPosition(size - tailSize);
    final tail = await handle.read(tailSize);
    final bytes = ByteData.sublistView(tail);
    var found = false;
    for (var i = tail.length - 22; i >= 0; i--) {
      if (bytes.getUint32(i, Endian.little) != ZipDirectory.eocdSignature) {
        continue;
      }
      if (i + 22 + bytes.getUint16(i + 20, Endian.little) != tail.length) {
        // Match the library's *last signature* choice. It does not validate
        // comment length, so silently trying an earlier signature is unsafe.
        throw const FormatException();
      }
      verifiedEocd = size - tailSize + i;
      verifiedCount = bytes.getUint16(i + 10, Endian.little);
      verifiedDirectorySize = bytes.getUint32(i + 12, Endian.little);
      verifiedDirectoryOffset = bytes.getUint32(i + 16, Endian.little);
      if (bytes.getUint16(i + 4, Endian.little) != 0 ||
          bytes.getUint16(i + 6, Endian.little) != 0 ||
          bytes.getUint16(i + 8, Endian.little) != verifiedCount ||
          verifiedCount > 10000 ||
          verifiedDirectorySize > 16 * 1024 * 1024 ||
          verifiedDirectoryOffset + verifiedDirectorySize > verifiedEocd) {
        throw const FormatException();
      }
      found = true;
      break;
    }
    if (!found) throw const FormatException();
    if (verifiedEocd >= ZipDirectory.zip64EocdLocatorSize) {
      await handle.setPosition(
        verifiedEocd - ZipDirectory.zip64EocdLocatorSize,
      );
      final locator = ByteData.sublistView(await handle.read(4));
      if (locator.getUint32(0, Endian.little) ==
          ZipDirectory.zip64EocdLocatorSignature) {
        // ZIP64 may override otherwise valid EOCD size/count/offset bounds.
        // The 2 GiB import cap does not require ZIP64 support.
        throw const FormatException();
      }
    }
    await handle.setPosition(verifiedDirectoryOffset);
    final metadata = await handle.read(verifiedDirectorySize);
    if (metadata.length != verifiedDirectorySize) throw const FormatException();
    final central = ByteData.sublistView(metadata);
    var offset = 0, actualCount = 0;
    var localMetadataBytes = 0;
    final localOffsets = <int>{};
    while (offset < metadata.length) {
      if (++actualCount > 10000 ||
          offset + 46 > metadata.length ||
          central.getUint32(offset, Endian.little) != ZipFileHeader.signature) {
        throw const FormatException();
      }
      final nameLength = central.getUint16(offset + 28, Endian.little);
      final extraLength = central.getUint16(offset + 30, Endian.little);
      final commentLength = central.getUint16(offset + 32, Endian.little);
      final localOffset = central.getUint32(offset + 42, Endian.little);
      final compressedSize = central.getUint32(offset + 20, Endian.little);
      final uncompressedSize = central.getUint32(offset + 24, Endian.little);
      final flags = central.getUint16(offset + 8, Endian.little);
      final next = offset + 46 + nameLength + extraLength + commentLength;
      if (next > metadata.length ||
          nameLength > 4096 ||
          compressedSize > healthImportMaxBytes ||
          uncompressedSize > healthImportMaxBytes ||
          localOffset + 30 > verifiedDirectoryOffset ||
          !localOffsets.add(localOffset) ||
          (flags & 1) != 0 ||
          central.getUint16(offset + 34, Endian.little) != 0) {
        throw const FormatException();
      }
      final extraOffset = offset + 46 + nameLength;
      final extraEnd = extraOffset + extraLength;
      _validateZipExtra(central, extraOffset, extraEnd);
      // The library eagerly reads *local* names/extras for every central entry.
      // Validate and cap that separate allocation before invoking it.
      await handle.setPosition(localOffset);
      final localHeader = await handle.read(30);
      if (localHeader.length != 30) throw const FormatException();
      final local = ByteData.sublistView(localHeader);
      final localNameLength = local.getUint16(26, Endian.little);
      final localExtraLength = local.getUint16(28, Endian.little);
      localMetadataBytes += localNameLength + localExtraLength;
      final dataEnd =
          localOffset +
          30 +
          localNameLength +
          localExtraLength +
          compressedSize;
      if (local.getUint32(0, Endian.little) != ZipFile.zipSignature ||
          localNameLength != nameLength ||
          localNameLength > 4096 ||
          localMetadataBytes > 16 * 1024 * 1024 ||
          local.getUint16(6, Endian.little) != flags ||
          local.getUint16(8, Endian.little) !=
              central.getUint16(offset + 10, Endian.little) ||
          dataEnd > verifiedDirectoryOffset) {
        throw const FormatException();
      }
      final localMetadata = await handle.read(
        localNameLength + localExtraLength,
      );
      if (localMetadata.length != localNameLength + localExtraLength) {
        throw const FormatException();
      }
      for (var i = 0; i < nameLength; i++) {
        if (localMetadata[i] != metadata[offset + 46 + i]) {
          throw const FormatException();
        }
      }
      _validateZipExtra(
        ByteData.sublistView(localMetadata),
        localNameLength,
        localMetadata.length,
      );
      final expectedCrc = central.getUint32(offset + 16, Endian.little);
      if ((flags & 8) == 0) {
        if (local.getUint32(14, Endian.little) != expectedCrc ||
            local.getUint32(18, Endian.little) != compressedSize ||
            local.getUint32(22, Endian.little) != uncompressedSize) {
          throw const FormatException();
        }
      } else {
        // Descriptor entries legitimately use zero CRC/sizes in the local
        // header. Validate their bounded descriptor instead.
        if (dataEnd + 12 > verifiedDirectoryOffset) {
          throw const FormatException();
        }
        await handle.setPosition(dataEnd);
        final signature = ByteData.sublistView(await handle.read(4));
        final hasSignature =
            signature.getUint32(0, Endian.little) == 0x08074b50;
        if (dataEnd + (hasSignature ? 16 : 12) > verifiedDirectoryOffset) {
          throw const FormatException();
        }
        await handle.setPosition(dataEnd + (hasSignature ? 4 : 0));
        final descriptor = ByteData.sublistView(await handle.read(12));
        if (descriptor.lengthInBytes != 12 ||
            descriptor.getUint32(0, Endian.little) != expectedCrc ||
            descriptor.getUint32(4, Endian.little) != compressedSize ||
            descriptor.getUint32(8, Endian.little) != uncompressedSize) {
          throw const FormatException();
        }
      }
      offset = next;
    }
    if (actualCount != verifiedCount) throw const FormatException();
  } finally {
    await handle.close();
  }
  final input = InputFileStream(path);
  try {
    final directory = ZipDirectory()..read(input);
    if (directory.filePosition != verifiedEocd ||
        directory.centralDirectoryOffset != verifiedDirectoryOffset ||
        directory.centralDirectorySize != verifiedDirectorySize ||
        directory.fileHeaders.length != verifiedCount) {
      throw const FormatException();
    }
    ZipFile? primary;
    final names = <String>{};
    for (final header in directory.fileHeaders) {
      final entry = header.file;
      if (entry == null) throw const FormatException();
      final name = entry.filename;
      if (name.contains('\\') ||
          name.startsWith('/') ||
          name.contains(':') ||
          name.split('/').contains('..') ||
          !names.add(name) ||
          (header.externalFileAttributes >> 16) & 0xf000 == 0xa000) {
        throw const FormatException();
      }
      if (entry.uncompressedSize > healthImportMaxBytes ||
          entry.compressedSize > healthImportMaxBytes) {
        throw const FormatException();
      }
      if (name == 'export.xml' || name == 'apple_health_export/export.xml') {
        if (primary != null ||
            entry.crc32 != header.crc32 ||
            (entry.flags & 1) != 0 ||
            !const {
              CompressionType.none,
              CompressionType.deflate,
            }.contains(entry.compressionMethod)) {
          throw const FormatException();
        }
        if (entry.uncompressedSize > (entry.compressedSize + 1) * 1000) {
          throw const FormatException();
        }
        primary = entry;
      }
    }
    if (primary == null) throw const FormatException();
    final content = primary.getStream(decompress: false);
    Stream<List<int>> compressed() async* {
      while (!content.isEOS) {
        if (isCancelled()) throw const FormatException();
        yield content.readBytes(4096).toUint8List();
        await Future<void>.delayed(Duration.zero);
      }
    }

    final expanded = primary.compressionMethod == CompressionType.deflate
        ? compressed().transform(ZLibCodec(raw: true).decoder)
        : compressed();
    var count = 0, crc = 0;
    await for (final chunk in expanded) {
      count += chunk.length;
      if (count > primary.uncompressedSize || count > healthImportMaxBytes) {
        throw const FormatException();
      }
      crc = getCrc32(chunk, crc);
      yield chunk;
    }
    if (count != primary.uncompressedSize || crc != primary.crc32) {
      throw const FormatException();
    }
  } finally {
    await input.close();
  }
}

void _validateZipExtra(ByteData bytes, int start, int end) {
  var offset = start;
  while (offset < end) {
    if (offset + 4 > end) throw const FormatException();
    final tag = bytes.getUint16(offset, Endian.little);
    final length = bytes.getUint16(offset + 2, Endian.little);
    if (tag == 1 || offset + 4 + length > end) throw const FormatException();
    offset += 4 + length;
  }
}
