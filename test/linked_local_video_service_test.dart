import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:inbodysimpletracker/data/services/linked_local_video_service.dart';
import 'package:inbodysimpletracker/data/services/local_video_service.dart';

void main() {
  late Directory directory;
  setUp(
    () async =>
        directory = await Directory.systemTemp.createTemp('linked_clip_'),
  );
  tearDown(() async => directory.delete(recursive: true));

  test(
    'linking stores no copy; deleting a checkpoint preserves original bytes',
    () async {
      final source = File('${directory.path}/original.mp4');
      await source.writeAsBytes([1, 2, 3, 4]);
      final root = Directory('${directory.path}/store');
      final service = LinkedLocalVideoService(
        documentsDirectory: () async => root,
      );
      final reference = await service.copyVideo(
        checkpointId: 'clip',
        sourcePath: source.path,
        originalFileName: 'original.mp4',
      );
      expect(reference, startsWith(LinkedLocalVideoService.prefix));
      expect(
        await service.resolvePath(reference, checkpointId: 'clip'),
        source.absolute.path,
      );
      expect(await root.exists(), isFalse);
      await service.deleteVideo(reference, checkpointId: 'clip');
      expect(await source.readAsBytes(), [1, 2, 3, 4]);
      // Cloud-backed managed-video services must never resolve local links.
      expect(
        await LocalVideoService(
          documentsDirectory: () async => root,
        ).resolvePath(reference),
        isNull,
      );
    },
  );

  test(
    'moving or deleting an original makes a link unavailable without changing it',
    () async {
      final source = File('${directory.path}/original.mp4');
      await source.writeAsBytes([1]);
      final service = LinkedLocalVideoService();
      final reference = await service.copyVideo(
        checkpointId: 'clip',
        sourcePath: source.path,
        originalFileName: 'original.mp4',
      );
      final moved = await source.rename('${directory.path}/moved.mp4');
      expect(await service.resolvePath(reference), isNull);
      expect(await moved.exists(), isTrue);
      await service.deleteVideo(reference);
      expect(await moved.readAsBytes(), [1]);
    },
  );

  test('nonvideo and missing local references are unavailable', () async {
    final service = LinkedLocalVideoService();
    final text = File('${directory.path}/note.txt');
    await text.writeAsString('synthetic');
    expect(
      await service.resolvePath(
        '${LinkedLocalVideoService.prefix}${text.path}',
      ),
      isNull,
    );
    expect(
      await service.resolvePath(
        '${LinkedLocalVideoService.prefix}${directory.path}/missing.mp4',
      ),
      isNull,
    );
    await expectLater(
      service.copyVideo(
        checkpointId: 'clip',
        sourcePath: text.path,
        originalFileName: 'note.txt',
      ),
      throwsArgumentError,
    );
  });
}
