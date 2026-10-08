# Local Health implementation and native release gates

The implementation is an experimental native recorder, developed with synthetic
records only. No personal Apple Health exports are source assets or test fixtures.
The private planning notes stay in ignored `.omx/plans/`.

## Implementation sequence

1. **Privacy foundation:** default MQTT ingestion disabled; dashboard auto-connect
   removed. Tracked-file/Web-asset guards added. A cloud-independent Health entry
   stays accessible during pending/failed Firebase bootstrap.
2. **Local storage:** SQLCipher, a device-only Keychain/Keystore key, persistent app
   support location, mandatory native protection, staged batches/revisions/lineage,
   idempotent imports, safe undo, and interrupted-import cleanup. No plaintext or
   cloud fallback is permitted.
3. **Import and review:** bounded XML/ZIP parsing with worker backpressure,
   cancellation and defensive archive/entity guards; known unit conversions,
   source-separated summaries, missing-data gaps and overlap warnings. Weekly
   daily summaries and source inventories are cached inside SQLCipher. Warm views
   avoid raw-record scans; cold views page observations with per-day quality caps.
4. **Personal context and portable recovery:** local notes, encrypted streaming
   backups, full authentication before transactional restore, and user-selected
   native Files export. Current backup scope is the local vault only.
5. **Read-only HealthKit:** explicit iPhone refresh for selected supported types,
   bounded anchored pages, atomic sample/deletion/cursor updates, cancellation,
   and separate HealthKit sources. No write or background permissions are requested.
6. **Later scope:** longer-range review views and optional full-recorder backups including opt-in videos and
   cloud-metadata snapshots. These are not implemented or represented as ready.

The current native implementation uses `sqflite_sqlcipher` 3.4.x and
`flutter_secure_storage` 10.3.x. Version 11 of secure storage conflicts with the
existing file picker's Windows dependency, so 10.3.x was chosen to preserve the
existing app. Parsing/archive/cryptography dependencies are explicit direct
dependencies. SQLCipher presence and a valid secure key are checked before opening.

## Reproducible automated checks

```sh
flutter pub get
flutter analyze
flutter test
flutter build web --release
python3 -m unittest discover -s .github/scripts -p 'test_*.py'
python3 .github/scripts/check_private_assets.py
python3 .github/scripts/check_private_assets.py --web-dir build/web
```

Host tests cover models/units, stream chunking, malicious/malformed archives/XML,
idle/excluded-record cancellation, staged imports and lineage, SQLite SQL/schema
semantics, backup passphrase/MAC/order/truncation/large-note handling, rollback,
vault locking, Files lifecycle queues, filters, notes gating and offline entry.
Host SQL tests and fake repositories do **not** prove native SQLCipher encryption.

Latest local verification: 209 Flutter tests and four Python privacy-guard tests
passed, with successful Web release and Android ARM64 Dart-bundle compilation.
These counts include the existing InBody/checkpoint suite. Native integration,
packaging, file-protection policy and physical-device measurements remain unrun;
the personal-data release gate therefore stays disabled.

Cache update verification: the full suite of 224 Flutter tests passed, plus the
added timeline regression showing a valid date beside a withheld date. Cache tests
cover warm reads without raw scans, source/offset separation, empty days, malformed
payload recovery and atomic invalidation. Analysis and the Web build passed. The
native integration fixture now checks v1-to-v2 migration and cache rebuilding;
that physical-device check remains unrun.

HealthKit/backup update verification: 257 Flutter tests passed with zero analyzer
issues. Synthetic tests cover cursor/sample transaction boundaries, namespace
isolation, malformed pages, cancellation/partial-error projections, withholding
incomplete refreshes, empty terminal pages, and version 1/2 backup authentication.
Host SQLite staging/recovery/cascade checks and four privacy-guard tests passed.
Web release and Android ARM64 Dart-bundle compilation succeeded. iOS plist/PBX
structure checks passed, but these are not an Xcode build. The native fixture
adds v3 migration, staged refresh/reopen and restore checks; those remain unrun
on a physical device. The personal-data release gate stays disabled.

On a configured iOS/Android simulator or physical device, run:

```sh
flutter test integration_test/health_vault_native_test.dart -d DEVICE_ID
```

That test uses a separate synthetic database and never opens `health.sqlite` or a
personal export. It checks the real SQLCipher version, staged visibility, replay,
shared import undo, revision fallback, restart recovery, corrupt restore rollback,
database/WAL marker absence, wrong-key rejection and correct-key reopening.

## Required native checks before enabling personal records

- Build the actual iOS and Android applications with their required Firebase/native
  project configuration. Configure iOS signing/Keychain entitlements; do not
  substitute another user's records or credentials in test assets.
- Open the empty production vault and verify the protected key persists through
  force-close and phone restart. Check iOS complete file protection and backup
  exclusion; check Android cloud backup/device-transfer exclusion on the device.
- Test native Files import and export cancellation, backgrounding/lock/reopen,
  delayed picker completion and lost-access paths. Originals must stay untouched.
  Imported source copies must be in the app-owned picker cache. The native hook
  applies iOS complete file protection/backup exclusion to those copies and checks
  Android credential-protected cache/backup policy before parsing. Shared picker
  cache cleanup is SDK-managed; the app never deletes the original source path.
- Verify Health entry enables Android secure-window protection and iOS app-switcher
  cover views, then clears them on leaving the feature. iOS does not offer a general
  guarantee against a user deliberately taking screenshots; preview protection
  and lifecycle locking are distinct from that capability.
- Use a synthetic large XML workload to measure full-process memory, Dart heap,
  import time and cancel responsiveness. Target a million-record / roughly 600 MiB
  workload with under 150 MiB extra resident memory, under 64 MiB extra Dart heap,
  progress within two seconds and completion within five minutes on the nominated
  iPhone. Record actual measurements; do not infer them from small host tests.
- Test Unicode/unknown units, multiple devices, same-source overlapping activity,
  source replacement, sleep stage conflicts, naps, midnight and offset/DST edges.
  Unknown/conflicting/incomplete data must not be presented as authoritative totals.
- If using optional backups, prove portable encrypted backup/restore on another installation using synthetic
  observations/notes. Wrong passwords, altered or truncated files and malformed
  records must preserve the existing vault. Confirm excluded videos/cloud metadata
  are explicitly disclosed rather than expected to restore.
- Verify no Health payloads, identifiers or XML excerpts appear in network traffic,
  logs, CI artifacts, Git-tracked files or published Web assets. Verify deployed
  owner-access rules separately for existing cloud reports and checkpoints.

Only after those checks succeed, enable the local feature in a native build:

```sh
flutter run --dart-define=HEALTH_VAULT_VERIFIED=true
```

This flag is a build-time release gate, not an encryption switch: protection is
always required. It does not enable uploads. Do not flip it merely to bypass an
unverified native storage or recovery test. Backup destinations are selected by
the user; the app can export to a Files provider, including an encrypted copy in a
user-chosen cloud location, but never automatically syncs Health records.

## Explicit limitations

Native packaging, OS backup policy and the large-device workload cannot be proved
by Windows-host Flutter unit tests. The personal-data gate stays off until those
checks are performed. Source detail is retained in canonical sample identities
and stored source/time/unit provenance; richer device/creation metadata browsing
is future work. Original-offset/fixed-offset grouping is explicit and does not
claim IANA timezone reconstruction or exact Apple Health source-priority totals.
The native vault uses schema v3; migrations add derived cache tables and encrypted
HealthKit cursor state while retaining
canonical observations, import lineage, notes and protected keys. Caches are not
included in backups and rebuild after restore. Per-day safety limits may require
narrowing the selected source. No diagnostic score or causal inference is
produced. Real clinical/CDA records are intentionally outside this iteration.

## iCloud and refresh scope

Apple Health's own iCloud sync is separate from this application. It can supply
records for reimport when enabled, but it does not sync the local vault, cache,
context notes, or training video copies. Encrypted vault backups are available
through Files; full-recorder backups remain future work. Do not remove native
encryption/protection gates.

HealthKit refresh requests read access to selected types on iPhone, uses an
incremental anchor to receive new/deleted samples, and updates the encrypted local
repository. The permission sheet completing does not establish that any read
permission was granted: an empty response can also mean no accessible records.
Refresh is explicit and stops when the vault locks; no background delivery is used.
XML imports and HealthKit data are separate sources and are not summed together.
Paginated refreshes retain committed pages and cursors in encrypted storage, but
withhold that category's HealthKit summaries until the last page completes. Cancel
or restart preserves progress; refresh again to resume. This prevents partially
loaded dates from appearing as complete totals.

Version 2 encrypted backups include canonical observations, notes, import lineage
and refresh state; version 1 backups remain readable. Restore authenticates the
entire file before replacement and resets HealthKit cursors because they belong to
the queried store. The next successful first page replaces that metric's restored
HealthKit snapshot and continues paging. XML observations and notes remain intact.
Derived caches rebuild after restore. The Files destination may be private iCloud
Drive; remember the passphrase, which this app does not retain or recover. These
backups exclude training videos and existing cloud report/checkpoint metadata.

Before enabling personal records, build/sign iOS with the HealthKit entitlement
and test authorization completion, denied/limited reads, repeat refresh, paginated
history, deletions, interrupted-page restart, vault locking/cancellation and
restoring on another installation. Windows-host tests cannot verify these native
behaviors or Apple provisioning.
