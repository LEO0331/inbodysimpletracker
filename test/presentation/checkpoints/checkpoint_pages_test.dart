import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:inbodysimpletracker/data/models/training_checkpoint.dart';
import 'package:inbodysimpletracker/core/utils/checkpoint_validation.dart';
import 'package:inbodysimpletracker/data/services/checkpoint_service.dart';
import 'package:inbodysimpletracker/data/services/local_video_service.dart';
import 'package:inbodysimpletracker/logic/providers/checkpoint_provider.dart';
import 'package:inbodysimpletracker/presentation/checkpoints/checkpoint_list_page.dart';

class _Metadata extends Mock implements CheckpointService {}

class _Videos extends Mock implements LocalVideoService {}

class _Picker extends FilePicker {
  _Picker({this.file, this.cancel = false});
  final PlatformFile? file;
  final bool cancel;
  @override
  Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    bool allowCompression = true,
    int compressionQuality = 30,
    bool allowMultiple = false,
    bool withData = false,
    bool withReadStream = false,
    bool lockParentWindow = false,
    bool readSequential = false,
  }) async {
    expect(type, FileType.custom);
    expect(allowedExtensions, containsAll(['mp4', 'mov']));
    expect(withData, isFalse);
    expect(allowCompression, isFalse);
    if (cancel) return null;
    return FilePickerResult([
      file ??
          PlatformFile(
            name: 'runtime.mov',
            size: 1024,
            path: '/runtime/selection.mov',
          ),
    ]);
  }
}

TrainingCheckpoint _checkpoint(
  String id,
  String exercise,
  DateTime date, {
  CheckpointSide side = CheckpointSide.right,
}) => TrainingCheckpoint(
  id: id,
  checkpointDate: date,
  exerciseName: exercise,
  side: side,
  cameraAngle: CameraAngle.side,
  localVideoPath: 'training_videos/$id/runtime.mov',
  originalFileName: 'runtime.mov',
  createdAt: date,
  updatedAt: date,
);

void main() {
  late _Metadata metadata;
  late _Videos videos;
  late CheckpointProvider provider;
  final now = DateTime.now();
  final recent = _checkpoint('recent', 'Hip Abduction', now);
  final old = _checkpoint(
    'old',
    'Old Squat',
    DateTime(now.year, now.month - 8, now.day),
    side: CheckpointSide.bilateral,
  );

  setUpAll(() => registerFallbackValue(recent));
  setUp(() {
    metadata = _Metadata();
    videos = _Videos();
    when(
      () => metadata.getCheckpoints('user'),
    ).thenAnswer((_) => Stream.value([old, recent]));
    when(() => metadata.createId('user')).thenReturn('new');
    when(() => metadata.saveCheckpoint('user', any())).thenAnswer((_) async {});
    when(
      () => metadata.deleteCheckpoint('user', any()),
    ).thenAnswer((_) async {});
    when(() => videos.isSupported).thenReturn(true);
    when(
      () => videos.resolvePath(any(), checkpointId: any(named: 'checkpointId')),
    ).thenAnswer((_) async => null);
    when(
      () => videos.deleteVideo(any(), checkpointId: any(named: 'checkpointId')),
    ).thenAnswer((_) async {});
    when(
      () => videos.copyVideo(
        checkpointId: 'new',
        sourcePath: '/runtime/selection.mov',
        originalFileName: 'runtime.mov',
        maxSizeBytes: defaultMaxVideoBytes,
      ),
    ).thenAnswer((_) async => 'training_videos/new/runtime.mov');
    provider = CheckpointProvider(
      uid: 'user',
      checkpointService: metadata,
      localVideoService: videos,
    );
  });
  tearDown(() => provider.dispose());

  Future<void> showHistory(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(900, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: provider,
          child: const CheckpointListPage(uid: 'user'),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'selects runtime Files video and saves metadata without uploading',
    (tester) async {
      FilePicker.platform = _Picker();
      await showHistory(tester);
      await tester.tap(find.text('Add Checkpoint'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Exercise name'),
        'Hip Abduction',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Load (optional)'),
        '10',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Sets (optional)'),
        '3',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Reps (optional)'),
        '12',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'RPE (1–10, optional)'),
        '6',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Notes (optional)'),
        'Baseline',
      );
      await tester.tap(find.text('Select video from Files'));
      await tester.pumpAndSettle();
      expect(find.textContaining('runtime.mov •'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Save'));
      await tester.pumpAndSettle();
      final saved =
          verify(
                () => metadata.saveCheckpoint('user', captureAny()),
              ).captured.single
              as TrainingCheckpoint;
      expect(saved.load, 10);
      expect(saved.sets, 3);
      expect(saved.reps, 12);
      expect(saved.rpe, 6);
      expect(saved.notes, 'Baseline');
      expect(saved.localVideoPath, 'training_videos/new/runtime.mov');
      expect(
        find.text('Checkpoint saved. Video stored locally.'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'invalid selection reports size limit and cancellation preserves video',
    (tester) async {
      await showHistory(tester);
      await tester.tap(find.text('Add Checkpoint'));
      await tester.pumpAndSettle();
      FilePicker.platform = _Picker(
        file: PlatformFile(
          name: 'huge.mov',
          size: defaultMaxVideoBytes + 1,
          path: '/runtime/huge.mov',
        ),
      );
      await tester.tap(find.text('Select video from Files'));
      await tester.pumpAndSettle();
      expect(find.textContaining('size limit'), findsOneWidget);
      expect(find.textContaining('huge.mov •'), findsNothing);
      FilePicker.platform = _Picker();
      await tester.tap(find.text('Select video from Files'));
      await tester.pumpAndSettle();
      FilePicker.platform = _Picker(cancel: true);
      await tester.tap(find.text('Select video from Files'));
      await tester.pumpAndSettle();
      expect(find.textContaining('runtime.mov •'), findsOneWidget);
      verifyNever(() => metadata.saveCheckpoint('user', any()));
    },
  );

  testWidgets(
    'failed metadata deletion refreshes video path and allows retry',
    (tester) async {
      when(
        () => metadata.deleteCheckpoint('user', recent.id),
      ).thenThrow(StateError('denied'));
      await showHistory(tester);
      await tester.tap(find.text('Hip Abduction'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Delete checkpoint'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();
      expect(find.textContaining('video was removed'), findsOneWidget);
      expect(
        find.text('Video is not available on this device.'),
        findsOneWidget,
      );
      verify(
        () =>
            videos.resolvePath(recent.localVideoPath, checkpointId: recent.id),
      ).called(2);
      when(
        () => metadata.deleteCheckpoint('user', recent.id),
      ).thenAnswer((_) async {});
      await tester.tap(find.byTooltip('Delete checkpoint'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();
      expect(find.text('Hip Abduction'), findsNothing);
    },
  );
  testWidgets('detail handles missing local video and confirms deletion', (
    tester,
  ) async {
    await showHistory(tester);
    await tester.tap(find.text('Hip Abduction'));
    await tester.pumpAndSettle();
    expect(find.text('Video is not available on this device.'), findsOneWidget);
    await tester.tap(find.byTooltip('Delete checkpoint'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    verifyNever(
      () => videos.deleteVideo(any(), checkpointId: any(named: 'checkpointId')),
    );
    await tester.tap(find.byTooltip('Delete checkpoint'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();
    verify(
      () => videos.deleteVideo(recent.localVideoPath, checkpointId: recent.id),
    ).called(1);
    verify(() => metadata.deleteCheckpoint('user', recent.id)).called(1);
    expect(find.text('Video is not available on this device.'), findsNothing);
    expect(find.text('Hip Abduction'), findsNothing);
  });

  testWidgets(
    'invalid offscreen load prevents copying or saving a selected video',
    (tester) async {
      FilePicker.platform = _Picker();
      await showHistory(tester);
      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.tap(find.text('Add Checkpoint'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Exercise name'),
        'Hip Abduction',
      );
      final load = find.widgetWithText(TextFormField, 'Load (optional)');
      await tester.ensureVisible(load);
      await tester.enterText(load, 'invalid');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      final picker = find.text('Select video from Files');
      await tester.ensureVisible(picker);
      await tester.pumpAndSettle();
      await tester.tap(picker);
      await tester.pumpAndSettle();
      expect(find.textContaining('runtime.mov •'), findsOneWidget);
      final save = find.widgetWithText(FilledButton, 'Save');
      await tester.ensureVisible(save);
      await tester.pumpAndSettle();
      await tester.tap(save);
      await tester.pumpAndSettle();
      verifyNever(() => metadata.saveCheckpoint('user', any()));
      verifyNever(
        () => videos.copyVideo(
          checkpointId: 'new',
          sourcePath: '/runtime/selection.mov',
          originalFileName: 'runtime.mov',
          maxSizeBytes: defaultMaxVideoBytes,
        ),
      );
      await tester.ensureVisible(load);
      expect(find.text('Enter a valid number.'), findsOneWidget);
    },
  );

  testWidgets('history filters exercise, side and recent calendar months', (
    tester,
  ) async {
    await showHistory(tester);
    expect(find.text('Hip Abduction'), findsOneWidget);
    expect(find.text('Old Squat'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'hip');
    await tester.pumpAndSettle();
    expect(find.text('Old Squat'), findsNothing);
    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();
    await tester.tap(find.text('All sides'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bilateral').last);
    await tester.pumpAndSettle();
    expect(find.text('Hip Abduction'), findsNothing);
    expect(find.text('Old Squat'), findsOneWidget);
    await tester.tap(find.text('Bilateral').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('All sides').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Last 3 months').last);
    await tester.pumpAndSettle();
    expect(find.text('Hip Abduction'), findsOneWidget);
    expect(find.text('Old Squat'), findsNothing);
    await tester.tap(find.text('Last 3 months').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Last 6 months').last);
    await tester.pumpAndSettle();
    expect(find.text('Hip Abduction'), findsOneWidget);
    expect(find.text('Old Squat'), findsNothing);
  });
}
