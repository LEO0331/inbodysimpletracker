# InBody Simple Tracker - 系統設計審查（繁體中文）

## 1. 範圍與目的
本文件針對目前 repo 內實作進行系統設計審查，重點包含：
- 架構設計
- 主要取捨（tradeoff）
- 資料結構選型原因與替代方案
- 深度追問（deep dive）準備題

本文件僅為設計審查，不改動執行行為。

## 2. 高階架構
目前是輕量分層 Flutter 架構：

- Presentation 層（`lib/presentation/*`）
  - Auth/Home/Upload/Dashboard/Admin 頁面與元件。
- State 層（`lib/logic/providers/*`）
  - `AuthProvider`、`ReportProvider`、`MqttProvider`（`ChangeNotifier`）。
- Service 層（`lib/data/services/*`, `lib/core/services/*`）
  - `AuthService`、`FirestoreService`、`FileService`（OCR/PDF 擷取）。
- Domain Model（`lib/data/models/*`）
  - `InbodyReport` 作為核心資料模型。
- 外部系統
  - Firebase Auth
  - Cloud Firestore
  - MQTT broker（`broker.emqx.io`）
  - OCR 引擎（原生 ML Kit + Web Tesseract.js）

## 3. 主要執行流程（Data Flow）
### 3.1 驗證流程
1. 啟動時初始化 Firebase 與 Web persistence。
2. `AuthProvider` 監聽 auth state。
3. `AuthService` 讀取 `users/{uid}` 的 role。
4. UI 依登入狀態切換入口與功能。

### 3.2 報告匯入流程（上傳/OCR/PDF）
1. 使用者選檔（圖片/PDF）。
2. `FileService` 擷取文字：
   - Web：JS interop OCR
   - Native：ML Kit OCR
   - PDF：Syncfusion 抽字
3. `InbodyParser` 用 regex 轉換為指標。
4. 轉成 `InbodyReport`。
5. 寫入 Firestore `users/{uid}/reports`。

### 3.3 Dashboard 流程
1. 訂閱 Firestore snapshot stream。
2. map 成 `List<InbodyReport>`。
3. Client 端日期篩選（All/3M/6M）。
4. 圖表與歷史清單渲染。

### 3.4 MQTT 即時流程
1. Dashboard 以 user topic 初始化 MQTT。
2. 收到 JSON 後轉為 `InbodyReport`。
3. 先進記憶體 `mqttReports`。
4. 同步持久化到 Firestore。

## 4. 架構審查與取捨
## 優點
- UI / Provider / Service / Model 分層清楚，落地速度快。
- 多處支援 DI，測試可控度高。
- Firestore stream + MQTT 提供即時體驗。
- OCR 跨平台策略明確且可維護。

## 取捨與限制
- `ChangeNotifier` 簡單但擴張性有限：
  - 現階段足夠
  - 非同步互動變複雜時可讀性下降
- 狀態來源混合：
  - 有 `ReportProvider`，但 Dashboard 直接接 Firestore stream
  - 造成兩種 state 風格並存
- 一致性風險：
  - MQTT 與手動上傳可能同時寫入，可能重複
  - At-least-once 語意下缺 dedup 會放大問題
- 解析穩健性：
  - Regex 快且透明，但對 OCR 噪聲/版型變化敏感
- 運維耦合：
  - 公共 MQTT broker 上手快，但資料信任邊界較弱

## 5. 為何選這些資料結構？替代方案是什麼？
| 現行選擇 | 為何現在適合 | 代價 | 替代方案 | 何時切換 |
|---|---|---|---|---|
| Firestore 路徑 `users/{uid}/reports/{reportId}` | 租戶隔離直觀、單使用者查詢簡單 | 跨使用者分析不易 | 全域 `reports` + `uid` 欄位；事件流儲存 | 需要跨使用者營運分析時 |
| `InbodyReport` 不可變模型 | DB/UI 邊界型別清楚 | 手寫 mapping 成本 | `freezed/json_serializable` codegen | 模型數量擴大、演進頻繁時 |
| 解析中介用 `Map<String,dynamic>` | 彈性高、開發快 | 型別安全弱、key typo 風險 | `ParsedMetrics` typed DTO | Parser 複雜度提高時 |
| `List<InbodyReport>` 歷史資料容器 | 小中量資料下渲染直覺 | 大量資料時記憶體與篩選成本上升 | 分頁、cursor、區間載入 | 單使用者報告量大幅成長時 |
| `Stream<List<InbodyReport>>` 即時訂閱 | Realtime UX 成本低 | 讀取費用與 UI churn 可能增加 | 批次查詢 + 手動刷新；cache-first | 需嚴控成本/離線策略時 |
| Regex (`RegExp`) 解析 OCR 文本 | 可解釋、可快速調整 | 對版型/語言變化脆弱 | 規則引擎（含 confidence）、模板匹配、ML parser | OCR 來源多樣化後 |
| MQTT topic `inbody/users/{uid}/data` | 路由模型簡單 | 安全性依賴 broker ACL | 私有 broker、簽章訊息、IAM pub/sub | 進入正式高信任需求時 |

## 6. 深度追問（Deep Dive）準備題
## 架構與邊界
1. 為什麼這個專案用 Provider/ChangeNotifier，而不是 Riverpod/BLoC？
2. UI、Provider、Service 的邊界如何避免耦合？
3. 為什麼 Dashboard 直接用 StreamBuilder 而不是統一走 `ReportProvider`？

## 一致性與正確性
4. MQTT 與手動上傳同時發生時，如何避免重複報告？
5. 目前的 idempotency 策略是什麼？
6. 如何處理 MQTT 訊息延遲/亂序？

## 資料模型與儲存
7. 為什麼採用 user 子集合，而不是全域 reports？
8. 若要做全站分析，怎麼不破壞現有熱路徑？
9. Firestore index 與查詢模式要如何隨需求擴充？

## 可靠性與失敗情境
10. OCR 失敗或部分解析時，降級策略是什麼？
11. MQTT broker 不可用時，UX 與資料流如何退化？
12. 目前是否有重試/backoff 策略？

## 安全與信任
13. 使用公共 MQTT broker 的信任假設是什麼？
14. Firebase Security Rules 應如何保證讀寫隔離？
15. 如何驗證 MQTT payload 的來源可信度？

## 效能與成本
16. Firestore 成本主因在哪些讀寫路徑？
17. 如何抑制高頻更新造成的畫面 churn？
18. 何時要導入分頁與圖表視窗化？

## 演進與維運
19. 若要轉 offline-first，第一步會改哪層？
20. 若新增更多生理指標，schema 與 parser 如何安全演進？

## 7. 回答框架建議（面對深挖時）
- 先講需求壓力（時程、團隊規模、上市速度）。
- 說明當前設計是「刻意簡化 + 可測試」。
- 明講已知限制（重複寫入風險、parser 脆弱性、broker 信任）。
- 再給遷移路線而非純批評：
  - 統一報告 state 取得模式
  - 寫入加 idempotency key
  - parser 加 confidence + 人工覆核流程
  - MQTT 遷移到私有且有驗證的 broker
  - 導入分頁與成本保護欄位

## 8. 優先建議（設計層）
1. 報告資料流統一一種狀態編排策略（Provider 或封裝 stream abstraction）。
2. 增加 dedup/idempotency key（例如內容 hash + source + 時間桶）。
3. MQTT JSON 寫入前加 schema 驗證。
4. parser 回傳 confidence，避免低品質資料默默入庫。
5. 定義 ingestion latency / dashboard freshness 的 SLO/SLA。

