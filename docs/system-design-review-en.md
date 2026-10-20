# InBody Simple Tracker - System Design Review (English)

Review date: 2026-10-20. This document describes repository code, not a certification of deployed services or native-device validation.

## 1. Scope and review status

The app has three distinct data domains: cloud-backed InBody reports, training checkpoints with platform-specific storage, and a separate mobile-only private Health vault. Storage and authentication claims must identify the domain and platform.

Earlier versions of this review focused on report ingestion and assumed Firebase initialization for every launch. That assumption no longer describes Windows. Earlier MQTT consistency and broker-trust discussion remains design background; it is not evidence that a public broker is enabled or that a deployment has been audited.

## 2. Architecture and boundaries

- Presentation pages live under `lib/presentation/`; providers under `lib/logic/providers/` use `ChangeNotifier`.
- Report services cover authentication, Firestore, OCR/PDF extraction, parsing, and optional MQTT integration.
- `TrainingCheckpoint` stores the selected workout date, exercise, side, camera angle, optional load/unit, sets, reps, RPE, notes, local video reference, original filename, file metadata, optional SHA-256 fingerprint, and record timestamps.
- `CheckpointProvider` supports either `CheckpointService` for Firestore metadata or `LocalCheckpointService` for device-only JSON metadata.
- Windows injects `LinkedLocalVideoService`; mobile uses managed local video copies. Neither checkpoint path uploads video bytes to Firestore.
- `HealthProvider` and `EncryptedHealthRepository` form an independent local Health domain without a cloud account or cloud UID.

## 3. Runtime data flows

### 3.1 Windows local checkpoints

1. `BootstrapApp` opens `LocalCheckpointEntryPage` directly on Windows. This entry does not initialize Firebase or require sign-in.
2. `LocalCheckpointService` reads/writes `checkpoints.json`. The directory is set by the compile-time `LOCAL_CHECKPOINT_DIRECTORY` define; otherwise it uses `%APPDATA%/InBodySimpleTracker/checkpoints`, falling back to the current directory as the base when `APPDATA` is unavailable.
3. Selecting a video records a `linked-file:` reference to the original absolute local path. New imports do not copy the video. The source can be in any supported local folder; no fixed gym folder is required.
4. Playback opens the default Windows video player. Moving, renaming, or deleting the source makes playback unavailable while the checkpoint metadata remains.
5. Deleting a linked checkpoint removes its metadata and preserves the original video. Older managed references remain readable; their managed-copy deletion behavior is distinct from linked originals.
6. Windows checkpoint metadata stays in the local JSON store. This flow does not synchronize it to Firestore.

### 3.2 Mobile checkpoints and web limits

The cloud-backed checkpoint flow saves metadata under `users/{uid}/checkpoints/{checkpointId}`. On iOS/Android, imports copy video into the app documents directory under `training_videos/{checkpointId}/{filename}` and save its local reference in the metadata. Video bytes remain on that device; another device receiving metadata does not automatically receive the clip. Web video imports are unavailable.

The import/review form collects fields; it does not perform automatic technique assessment, rep counting, or form scoring. Notes are manual observations. SHA-256 fingerprints support duplicate detection, not exercise analysis.

### 3.3 Cloud reports

Outside the Windows entry, cloud bootstrap initializes Firebase; web uses session authentication persistence. The report flow picks an image/PDF, extracts text, parses metrics into `InbodyReport`, and writes user reports to Firestore. Dashboard report subscriptions and optional MQTT integration belong to this cloud domain, not to the Windows checkpoint store or private Health vault.

### 3.4 Private Health

Private Health supports iOS/Android storage through SQLCipher, a device-protected key, native directory protection, and encrypted backups. Windows/web do not provide this vault backend. The `HEALTH_VAULT_VERIFIED` define defaults to false; personal imports, HealthKit refresh, notes writes, and restores are gated pending native-device validation. This gate is separate from checkpoint availability and must not be described as passed merely because code or desktop tests exist.

## 4. Storage and privacy tradeoffs

| Domain | Storage | Principal limitation |
|---|---|---|
| Windows checkpoint metadata | Local JSON | Plaintext local file; includes filenames, absolute source references, notes, and fingerprints; not a Health-style encrypted vault |
| Windows checkpoint videos | Original local files | Minimal added storage, but playback depends on the source remaining accessible |
| Mobile checkpoint metadata | User Firestore subcollection | Metadata sync is a cloud operation; local-only video storage does not make all metadata local |
| Mobile checkpoint videos | Managed app documents copies | Uses additional device storage; videos do not follow metadata to another device |
| Private Health | Separate encrypted mobile database and explicit encrypted backups | Native validation and protected-key availability are required; no automatic cloud sync |
| InBody reports | Cloud Firestore | Separate cloud data and access-control concerns |

Git privacy and runtime privacy are different boundaries. Personal records, imported videos, Health exports, backups, and local runtime files must remain outside tracked source. Ignore rules prevent accidental new additions but do not remove previously committed history. Repository/privacy audit results must be recorded separately with actual evidence; this design review alone does not establish that GitHub is free of sensitive data.

## 5. Design choices and open questions

- Provider/service injection reuses checkpoint forms across local and cloud stores without introducing a second checkpoint model.
- Local JSON keeps Windows deployment light, but it has no account isolation, encryption, or automatic cross-device sync. Writes are serialized within the service; this is not a multi-process database.
- Original-file linking avoids duplicate storage but creates an explicit availability dependency. Future relinking support should preserve the record and recheck file identity.
- SHA-256 deduplication applies to checkpoint imports. It does not establish idempotency for report/MQTT ingestion.
- Existing report questions remain relevant: parser tolerance of OCR changes, report state orchestration, MQTT payload validation and trust, write idempotency, and pagination/read costs. They are review questions, not claims that particular failures are currently observed.

## 6. Review priorities

1. Keep platform-specific storage and deletion behavior explicit in UI and documentation.
2. Verify repository contents and reachable history before publishing; never commit personal fixtures or real source paths as examples.
3. Keep Windows checkpoints and private Health boundaries distinct when adding exports, backups, or sync.
4. Complete native-device evidence before enabling the private Health validation gate.
5. Evaluate report ingestion and MQTT reliability separately from checkpoint storage changes.

Source references: `lib/main.dart`, `lib/data/models/training_checkpoint.dart`, `lib/data/services/local_checkpoint_service.dart`, `lib/data/services/linked_local_video_service.dart`, `lib/data/services/checkpoint_service.dart`, `lib/data/services/local_video_service_mobile.dart`, `lib/presentation/checkpoints/widgets/checkpoint_video_player_mobile.dart`, `lib/logic/providers/health_provider.dart`, and `lib/data/services/health_store_mobile.dart`. This documentation update does not claim a new test, deployment, or device-validation run.
