# InBody Simple Tracker - System Design Review (English)

## 1. Scope and intent
This review covers the current Flutter app design as implemented in the repository, focused on:
- architecture
- major design tradeoffs
- data structure choices and alternatives
- deep-dive questions you should prepare for

This is a design review document only. It does not change runtime behavior.

## 2. High-level architecture
Current architecture is a lightweight layered Flutter app:

- Presentation layer (`lib/presentation/*`)
  - Pages/widgets for auth, home, upload, dashboard, admin.
- State layer (`lib/logic/providers/*`)
  - `AuthProvider`, `ReportProvider`, `MqttProvider` based on `ChangeNotifier`.
- Service layer (`lib/data/services/*`, `lib/core/services/*`)
  - `AuthService`, `FirestoreService`, `FileService` (OCR/PDF extract).
- Domain model (`lib/data/models/*`)
  - `InbodyReport` as core record object.
- External systems
  - Firebase Auth
  - Cloud Firestore
  - MQTT broker (`broker.emqx.io`)
  - OCR engines (ML Kit native, Tesseract.js web)

## 3. Runtime data flow (key paths)
### 3.1 Authentication path
1. App boot initializes Firebase and web auth persistence.
2. `AuthProvider` listens to auth state changes.
3. `AuthService` reads user role from `users/{uid}`.
4. UI renders authenticated vs unauthenticated entry points.

### 3.2 Report ingestion path (upload/OCR/PDF)
1. User picks image/PDF.
2. `FileService` extracts text:
   - web: JS interop OCR
   - native: ML Kit OCR
   - PDF: Syncfusion extraction
3. `InbodyParser` parses metrics via regex.
4. Parsed metrics converted to `InbodyReport`.
5. Firestore write to `users/{uid}/reports`.

### 3.3 Dashboard path
1. Dashboard subscribes to Firestore snapshot stream.
2. Snapshot docs mapped to `List<InbodyReport>`.
3. Client-side filtering (All / 3 months / 6 months).
4. Chart and history list render from filtered list.

### 3.4 Live MQTT path
1. Dashboard initializes MQTT per user/topic.
2. Incoming JSON payload parsed into `InbodyReport`.
3. Record appended to in-memory `mqttReports`.
4. Same record persisted into Firestore.

## 4. Architecture review and tradeoffs
## Strengths
- Clean practical separation: UI vs providers vs services vs model.
- Easy testing through dependency injection points in services/providers/widgets.
- Realtime UX with Firestore streams and MQTT channel.
- Cross-platform OCR strategy is explicit and workable.

## Tradeoffs / constraints
- `ChangeNotifier` simplicity vs scalability:
  - Good for current app size.
  - Becomes harder to reason about as async interactions increase.
- Mixed data orchestration:
  - `ReportProvider` exists, but dashboard directly uses `StreamBuilder` + Firestore.
  - This creates two patterns for state access.
- Event consistency:
  - MQTT writes to Firestore can race with direct uploads.
  - At-least-once semantics can produce duplicates unless dedup rules exist.
- Parsing fragility:
  - Regex parser is simple and fast but sensitive to OCR noise and format drift.
- Operational coupling:
  - Public MQTT broker simplifies setup but weakens data trust and isolation.

## 5. Why these data structures were chosen, and alternatives
| Current choice | Why it fits now | Tradeoff | Alternative(s) | When to switch |
|---|---|---|---|---|
| Firestore path `users/{uid}/reports/{reportId}` | Natural tenant isolation and easy per-user query | Harder global analytics without extra index pipelines | Flat `reports` collection with `uid` field; event-store append log | Need cross-user analytics/ops queries at scale |
| `InbodyReport` immutable model object | Strong typed boundary from DB/UI | Manual mapping overhead | Codegen (`freezed`/`json_serializable`) | Need larger model graph and safer schema evolution |
| `Map<String,dynamic>` for intermediate parsed metrics | Fast for flexible parse stage | Weak type safety; key typo risk | Typed DTO (`ParsedMetrics` class) | Parser logic grows or multiple parsers added |
| `List<InbodyReport>` for ordered history | Efficient for small-medium report volumes and chart input | In-memory filtering becomes heavy on large histories | Paginated list, cursor-based loading, local cache index | Users can have large (>thousands) report history |
| Firestore stream (`Stream<List<InbodyReport>>`) | Realtime UI with minimal polling complexity | Cost/read volume and UI churn if stream scope is broad | Batched query + manual refresh; cache-first sync layer | Need tighter read-cost control or offline-first behavior |
| Regex extraction (`RegExp`) from OCR text | Transparent, easy to tune quickly | Brittle to template/language variance | Rule engine with confidence, template matching, ML-based parser | OCR sources become diverse and less standardized |
| MQTT topic string `inbody/users/{uid}/data` | Simple routing and mental model | Security depends on broker auth/topic ACL | Signed message bus, private broker, pub/sub service with IAM | Production-grade trust/isolation requirement |

## 6. Deep-dive questions to prepare for
## Architecture and boundaries
1. Why use Provider/ChangeNotifier instead of Riverpod/BLoC in this app?
2. Where are the strict boundaries between presentation, provider, and services?
3. Why is Dashboard using direct Firestore stream instead of `ReportProvider`?

## Consistency and correctness
4. How do you prevent duplicate reports when MQTT and manual upload happen close together?
5. What is your idempotency strategy for report writes?
6. How do you handle late/out-of-order MQTT messages?

## Data model and storage
7. Why did you choose per-user subcollection over a global reports collection?
8. How would you support global analytics without changing hot user flows?
9. How do Firestore indexes and query patterns evolve as filters grow?

## Reliability and failure modes
10. What happens when OCR fails or parser returns partial data?
11. How does the app degrade when MQTT broker is unavailable?
12. What retry/backoff strategy exists for writes and subscriptions?

## Security and trust
13. What trust assumptions are made with a public MQTT broker?
14. How are Firebase security rules expected to protect user report writes/reads?
15. How do you validate incoming MQTT payload authenticity?

## Performance and cost
16. Where are the primary read/write cost drivers in Firestore?
17. How do you cap realtime update churn for heavy users?
18. At what point do you need pagination and incremental chart windows?

## Evolution and maintainability
19. If you had to move to offline-first, what layer changes first?
20. If adding more biometrics, how do schema and parser evolve safely?

## 7. Suggested answers framework for deep dives
- Start from requirement pressure (speed, team size, time-to-market).
- Explain why current design is intentionally simple and testable.
- State known constraints explicitly (duplication risk, parser brittleness, broker trust).
- Give a migration path, not only a critique:
  - unify state access strategy
  - add write idempotency key
  - add parser confidence and review queue
  - move MQTT to private authenticated broker
  - introduce paginated history and cost guardrails

## 8. Priority recommendations (design-level)
1. Choose one state orchestration pattern for reports (provider or direct stream abstraction) to reduce cognitive overhead.
2. Add report dedup/idempotency key (e.g., content hash + source + timestamp bucket).
3. Add payload validation schema for MQTT JSON before persist.
4. Introduce parser confidence signal to reduce silent bad data writes.
5. Define explicit SLO/SLA targets for ingestion latency and dashboard freshness.

