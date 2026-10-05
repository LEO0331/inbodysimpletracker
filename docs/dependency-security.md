# Dependency security review — 2026-10-05

Reviewed the 14 open repository Dependabot alerts against both npm lockfiles.
Run audits with network access: an offline/cached audit returned a misleading
zero-vulnerability result during this review.

## Addressed alerts

| Package | Alerts | Resolution |
| --- | --- | --- |
| basic-ftp | #108, #109, #111, #114, #223 | Override to ^6.2.2 in the Firebase CLI tree. |
| qs | #194, #70, #193, #132, #69, #35 | Resolve qs to 6.16.0 in both trees, using Express 4.22.3 in the CLI and 5.2.1 in Functions. |
| uuid | #131, #34 | Override to ^11.1.1 in both trees; version 11 retains CommonJS support. |

The basic-ftp 6 upgrade rejects separate transfer hosts by default, protecting
against FTP bounce attacks. Standard FTP clients retain the APIs used by get-uri.
Remove overrides when upstream packages declare patched dependency ranges.

The Functions SDK was upgraded to 7.4.0 to support the existing Admin SDK 14.5.0.
The signup handler explicitly imports firebase-functions/v1, retaining the
first-generation Authentication trigger. Removed the unused
firebase-functions-test package, whose Admin SDK peer range was incompatible and
whose dependency tree introduced ts-deepmerge and Jest/braces vulnerabilities.
The replacement regression test uses Node's built-in test runner, the real
Functions SDK, and a stub Admin SDK; it makes no remote writes.

## Remaining findings

- **#145, @opentelemetry/core:** Firebase CLI 15.32.1 depends on Pub/Sub 5, which
  requires OpenTelemetry Core 1.30.1. The fix is in Core 2.8.0+. Pub/Sub 6.1.0
  supports the fix but requires Node 22 and upgrades several other Google Cloud
  packages. Leave this CLI-only dependency pending an upstream Firebase CLI
  update rather than force a cross-major override without emulator integration
  coverage. This is absent from the deployed Functions tree.
- **New braces advisory (GHSA-vfj7-8cjw-p6xm):** No patched version is published.
  It remains through Firebase CLI's chokidar 3 dependency. Avoid untrusted deeply
  nested glob patterns. This is absent from the deployed Functions tree.

Sources:
- https://github.com/advisories/GHSA-8988-4f7v-96qf
- https://github.com/advisories/GHSA-vfj7-8cjw-p6xm
- https://github.com/patrickjuchli/basic-ftp/blob/master/CHANGELOG.md

## Verification

- Clean npm installs with both lockfiles, without legacy peer dependency bypasses.
- Functions lint, syntax checks, and signup regression test, including failed
  Firestore writes preventing custom claims; verifies gcfv1 trigger metadata.
- Firebase CLI startup, get-uri data URL, FTP CRLF rejection, and CommonJS UUID
  consumer smoke checks.
- Live audits: Functions has zero vulnerabilities. Root has five affected
  packages from two underlying advisories (OpenTelemetry and braces).

Flutter source and dependencies were unchanged. Flutter checks and live Firebase
deployment/emulator integration were not run. GitHub alerts will be re-evaluated
after these changes reach the default branch; none were dismissed manually.
