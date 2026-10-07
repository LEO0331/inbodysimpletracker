# Training checkpoint hardening review

Reviewed implementation commit `a683f704da18777ec7d80b9fa0c51d1a24ee2dd9`
against its parent before making repairs. Scope: reliability of the existing
checkpoint feature; no new recording, analysis, upload, or comparison features.

## Architecture and initial review

The previous commit changed 33 files: 16 checkpoint source files and six test
files were added; navigation, dependencies, documentation, ignore/analyzer
configuration, and generated plugin registrations were modified. It added
`path_provider` and `video_player`, reusing the installed `file_picker`.

Metadata remains in `users/{uid}/checkpoints/{checkpointId}` in Firestore. Existing
InBody reports remain at `users/{uid}/reports/{reportId}`. Video bytes never enter
Firestore or Firebase Storage. Videos are copied into application Documents under
`training_videos/{checkpointId}/{sanitizedFilename}`. Metadata contains only that
relative managed reference, resolved against the current Documents directory.

Persistent Documents storage was already appropriate: the original file is
copied, not moved or deleted, and picker/cache/Downloads paths are only import
sources. No path migration was needed. Valid existing references are preserved.
Tests now recreate the storage service and relocate the simulated Documents root
to prove references do not depend on the original absolute app-container path.
Actual phone restart behavior still requires the physical-device checklist.

The history uses a lazy list of metadata cards. Only detail instantiates a local
file `VideoPlayerController`; loading, error, aspect ratio, play/pause, seek, and
disposal are handled there. iOS/Android use filesystem implementations; Web uses
conditional stubs and a mobile-only add message while retaining metadata viewing.

Initial findings:

- High: a malformed checkpoint could reference another checkpoint's managed file
  and delete it because directory ID and record ID were not compared.
- Medium: existence-check followed by overwriting copy was unsafe under concurrent
  imports targeting the same destination.
- Medium: Firestore ordering excluded records without a date before defensive
  parsing could provide its fallback.
- Medium: partial deletion and failed cleanup were only generic or hidden errors.
- Medium: input lengths, positive values, allowed file types, and configurable
  size limits were not consistently enforced.
- Missing evidence: controller failure/disposal races, restart resolution,
  concurrent filenames, pending metadata events, and partial failure tests.

No tracked MP4/MOV/M4V/AVI/MKV/WebM files or large video fixtures were found. No
legitimate project assets were removed.

## Reliability repairs

1. Resolution and deletion now bind managed references to the checkpoint ID.
   Traversal, unsafe references, symlinks, and foreign IDs are unavailable; they
   cannot delete another checkpoint's file or files outside managed storage.
2. Each destination is reserved with exclusive creation before native file copy.
   Only its owner performs failure cleanup. Same filenames in different ID
   directories remain independent; simultaneous collisions preserve the winner.
3. Actual source length is checked before copy. Copied length is checked afterward
   against the original length and configured cap, catching incomplete or changed
   sources. Copying does not load complete videos into Dart memory.
4. Save/delete failures report their stage, including failed local cleanup and
   metadata deletion after local video removal. File-delete failure keeps metadata.
   Missing files/directories are tolerated. UI refreshes local availability after
   failure and initiates player disposal before deleting its file.
5. Save is guarded while processing; deletion is guarded per checkpoint. Successful
   save/delete updates history immediately without requiring another stream event.
   Pending Firestore creations remain hidden until acknowledgment, and optimistic
   deletion cannot prematurely remove the active provider's pending record.
6. Queries include missing-date historical records, then sort parsed metadata
   locally. Filters preserve that ordering; redundant UI sorting was removed.
7. UI and provider reuse shared pure validation. New exercise/notes/unit lengths
   are capped at 120/4,000/20 characters. Optional load/sets/reps must be positive,
   RPE permits decimals from 1–10, and MP4/MOV/M4V extensions are case-insensitive.
   The default cap is 2 GiB, configurable with `CheckpointProvider.maxVideoBytes`.
   Historical zero-valued metadata remains readable.
8. Model parsing rejects nonfinite/unsafe numbers and fractional count strings
   that could round to integers. Invalid dates, enums, and missing fields fall
   back safely without hiding the remaining history.
9. Player construction, initialization, decoder, play/seek, and asynchronous
   disposal errors are contained. Failed controllers are released; generation
   checks prevent stale initialization results from affecting replacement players.
10. Git ignore patterns protect mixed-case video extensions. No dependencies or
    permissions were added. Picker compression is explicitly disabled.

## Files in this hardening pass

Added:

- `lib/core/utils/checkpoint_validation.dart`
- `lib/data/services/local_video_copy_exception.dart`
- `test/checkpoint_service_test.dart`
- `test/presentation/checkpoints/checkpoint_video_player_test.dart`
- `docs/training-checkpoint-hardening.md`

Modified:

- `.gitignore`, `README.md`
- `lib/data/models/training_checkpoint.dart`
- `lib/data/services/checkpoint_service.dart`
- `lib/data/services/local_video_service.dart`
- `lib/data/services/local_video_service_mobile.dart`
- `lib/data/services/local_video_service_web.dart`
- `lib/logic/providers/checkpoint_provider.dart`
- `lib/presentation/checkpoints/add_checkpoint_page.dart`
- `lib/presentation/checkpoints/checkpoint_detail_page.dart`
- `lib/presentation/checkpoints/checkpoint_list_page.dart`
- `lib/presentation/checkpoints/widgets/checkpoint_form_validation.dart`
- `lib/presentation/checkpoints/widgets/checkpoint_video_player_mobile.dart`
- `test/checkpoint_provider_test.dart`
- `test/local_video_service_test.dart`
- `test/training_checkpoint_test.dart`
- `test/presentation/checkpoints/checkpoint_form_test.dart`
- `test/presentation/checkpoints/checkpoint_pages_test.dart`

No dependency manifests, lockfile, analyzer settings, auth, InBody, OCR, MQTT, or
chart logic changed. Repository-wide formatting was run, then its verified
formatting-only changes to unrelated files were restored. Existing unrelated
`.omx` runtime modifications were left untouched.

## Validation

- Baseline: all 117 tests passed before hardening.
- `flutter pub get`: passed; no dependencies added or upgraded.
- `dart format .`: completed; final changed sources were formatted again.
- `flutter analyze --no-pub`: zero issues; no new warning suppressions.
- `flutter test --no-pub`: all 143 tests passed, including current InBody tests.
- `flutter build web --release --no-pub`: passed, including Wasm dry run.
- `flutter build bundle --no-pub --target-platform android-arm64`: passed.
- `git diff --check`: passed; tracked video inspection and mixed-case ignore checks
  passed. Tests use temporary tiny byte files and fake player controllers.

On this Windows host, validation commands temporarily disabled desktop plugin
generation using `FLUTTER_WINDOWS=false` and `FLUTTER_LINUX=false` to avoid its
missing symlink privilege. No persistent Flutter settings were changed.

An Android debug APK build was attempted, but Gradle distribution download stalled
with a zero-byte partial archive. Only that verified build process was stopped
after roughly four minutes. The host also lacks Android SDK command-line tools.
APK/native plugin packaging therefore remains unverified; a successful Dart
bundle is not an APK build. Automatic unrelated Gradle migration was reverted.
iOS packaging requires macOS/Xcode and was not run on this Windows host.

## iPhone checklist and remaining debt

The [README's manual iPhone checklist](../README.md#manual-iphone-verification)
covers Files/Downloads MP4 and MOV selection, untouched originals, playback,
page reopening, force-close/relaunch, phone restart, duplicate names, filters,
missing local files, deletion/cancellation, limits, and offline/denied writes.

Files selection uses the document import picker in the installed iOS plugin;
Photos permissions were not added. Codec support depends on the platform player,
including the device's support for H.264/HEVC. See the
[video_player documentation](https://pub.dev/packages/video_player) and
[persistent directory API](https://pub.dev/packages/path_provider).

Remaining constraints and technical debt:

- Physical iPhone Files-provider, codec, persistence, and deletion acceptance
  checks remain manual; fake controllers cannot prove native behavior.
- Firestore owner rules are deployed separately and were not changed or verified.
- Metadata is synced; videos stay local and uninstall may remove them. Another
  device cannot play or remove the original device's local copy.
- Offline writes may remain pending. No timeout discards a queued write that
  Firestore could later commit.
- Abrupt termination between copy and metadata acknowledgment can leave an orphan
  file. Cleanup failures are now reported, but automatic orphan recovery was kept
  outside this task's scope.
- Duration remains optional. There is no transcoding or automatic codec repair.
- History currently loads the user's metadata collection; pagination may be worth
  considering if usage grows beyond the intended hundreds of checkpoints.

The independent final storage/provider/model review found no unresolved material
finding in the repaired scope.
