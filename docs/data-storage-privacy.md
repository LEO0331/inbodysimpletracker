# Data storage, privacy and publication

Reviewed: **2026-10-20**. This document describes code and the repository audit
performed on that date. It does not certify all GitHub data or deployed services.

## Where data lives

| Data | Windows | iOS/Android | Web |
| --- | --- | --- | --- |
| Training checkpoint details | Device-only plaintext `checkpoints.json` | Owner-scoped Firestore metadata | Reads cloud metadata |
| Training video | Link to the original local file; no new copy | Managed copy in app Documents | Mobile video files unavailable |
| Private Health observations and notes | No Health UI in the local Windows runner | Separate SQLCipher vault, with protected device key and validation gate | Native-only notice |
| InBody reports and account data | No cloud UI in local Windows mode | Existing Firebase services | Existing Firebase services |

Videos are not uploaded to Firebase, source control or the web app by checkpoint
services. Mobile workout metadata and InBody/account data are cloud-backed;
"videos stay local" does not mean every feature stores all data locally.

## Windows records and original videos

The default record directory is `%APPDATA%/InBodySimpleTracker/checkpoints`.
Build/run with `--dart-define=LOCAL_CHECKPOINT_DIRECTORY=<absolute-private-directory>`
to select another location, such as an ignored workspace `.local/checkpoints`.
The same setting must be used by the app and the opt-in import command.

Records contain the workout date, exercise, side, camera angle, optional load/unit,
sets, reps, RPE, notes, original filename/size, hash when imported, and a
`linked-file:` reference to the absolute original path. Blank optional fields do
not imply zero. Exercise names and dates are user-entered; file timestamps are
not workout dates. No exercise recognition, form analysis or automatic scoring
is performed. The Windows provider checks content hashes to reject duplicates.

Playback opens the linked source in the default Windows video player. Moving,
renaming or deleting that source makes playback unavailable while keeping the
record. Deleting a linked checkpoint never removes the original file. Relinking
and automatic backup are not implemented. There is no requirement that the folder
be named `gym`; any accessible local MP4/MOV/M4V source can be selected.

Local Windows JSON is **not encrypted by the app** and has no account isolation.
It relies on Windows account/disk protection. Back up the JSON store and any
originals you want to retain separately. Checkpoint files are excluded from the
encrypted Health backup format. Missing originals cannot be recovered from JSON.

## Mobile videos and Health

Mobile checkpoint saves copy the original into app Documents at
`training_videos/{checkpointId}/{sanitizedFilename}`. The source remains untouched.
Deleting a checkpoint removes its managed copy and attempts metadata deletion;
partial failures are reported. Missing device-local videos do not remove cloud
metadata. Uninstalling may remove managed files; metadata sync does not sync videos.

The private Health vault is independent of checkpoint storage. Its optional
passphrase-encrypted backups contain Health records and notes, not checkpoint
metadata or videos. Personal Health operations remain disabled unless native
validation is completed and the build gate is enabled. See
[native release gates](local-health-validation.md).

## Publication controls

- `.local/`, `.omx/`, `checkpoints.json`, managed training directories, supported
  video extensions, Health exports, backups and databases are Git-ignored.
- The publication guard checks tracked files before building and web assets before
  publishing. It rejects private stores, runtime directories and video files.
- Pages deployment uploads only the verified `build/web` directory as a short-lived
  artifact, then deploys it with the official Pages action. It does not commit build
  output to a deployment branch. See [deployment details](github-pages-deployment.md).
- Personal files must never be added as Flutter assets, test fixtures, screenshots
  or CI artifacts. Use synthetic test data. Ignore rules can be overridden and do
  not erase history; the guard is an additional check, not a complete secret scanner.
- Existing demo screenshots use test account labels; the sample report is labeled
  Jane Doe. These historical assets do not contain the newly imported video records.

## Repository audit evidence and limits

The audit fetched remote refs, including `main` and `gh-pages`, and inspected
1,374 reachable Git objects, including 734 blobs. It compared the current local
video blob identities, original filenames, record IDs, absolute source paths and
content hashes against reachable contents. No matches for those four records or
videos were found. No video/export/database file paths were found in reachable
history. The existing demo images were visually reviewed.

A text-pattern scan found no matches for private-key blocks, GitHub/OpenAI access
tokens, AWS access-key IDs, Google OAuth access tokens, credentialed HTTP URLs or
service-account JSON. This is a bounded pattern audit, not proof that every secret
format, binary, remote artifact or earlier deleted server object is absent.
It did not access private Firestore contents, provider backups, Actions artifacts,
releases, forks, GitHub caches or an account-wide secret-scanning dashboard.

**Historical privacy finding:** runtime logs and state had already been tracked
despite the ignore rule. Some older blobs contain local paths and chat previews.
The accompanying change removes eight runtime files from the current source tree
while retaining the local files and blocks future publication of `.omx/`.
Those older commits remain reachable. Removing files in a new commit does not
purge previously pushed history. A coordinated history rewrite and, if needed,
GitHub cache/fork cleanup would be a separate explicitly approved operation.
Git commit authorship also remains public repository metadata.

Firebase client configuration remains public in source and compiled clients.
It is distinct from privileged service-account credentials. Firebase explains
that Firebase-only API keys generally are not secrets, while other Google API
uses require additional restrictions: [Firebase API key guidance](https://firebase.google.com/docs/projects/api-keys).
The audit did not verify live key restrictions, IAM, App Check or Firestore rules,
so public configuration must not be interpreted as evidence those controls are correct.

## Verification

The Windows feature had 62 affected Flutter tests, static analysis, Windows/Web
builds, repeated-import validation and a native playback spot check. This documentation
and guard update adds synthetic publication checks and reruns the privacy guard.
Historical test counts elsewhere are retained with their original scope. No
physical mobile or native Health validation is inferred from Windows checks.
