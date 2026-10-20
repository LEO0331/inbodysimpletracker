# InBody Simple Tracker - 系統設計審查（繁體中文）

審查日期：2026-10-20。本文件描述儲存庫內程式碼，不代表已部署服務或原生裝置驗證已通過認證。

## 1. 範圍與審查狀態

本應用程式包含三個獨立資料領域：雲端 InBody 報告、依平台採不同儲存方式的訓練檢查點，以及獨立且僅支援行動裝置的私人 Health 資料庫。描述儲存與驗證行為時，必須指明資料領域與平台。

本審查的早期版本以報告匯入為主，並假設每次啟動都初始化 Firebase；此假設已不適用於 Windows。早期關於 MQTT 一致性與 broker 信任的討論保留為設計背景，不能用來證明公共 broker 已啟用，或部署環境已完成稽核。

## 2. 架構與邊界

- 頁面位於 `lib/presentation/`；`lib/logic/providers/` 內的 Provider 使用 `ChangeNotifier`。
- 報告服務涵蓋身分驗證、Firestore、OCR/PDF 文字擷取、解析與選用的 MQTT 整合。
- `TrainingCheckpoint` 儲存選定的訓練日期、動作、側別、拍攝角度、選填重量與單位、組數、次數、RPE、備註、本機影片參照、原始檔名、檔案資訊、選填 SHA-256 指紋及紀錄時間。
- `CheckpointProvider` 可使用儲存 Firestore 中繼資料的 `CheckpointService`，或僅儲存本機 JSON 的 `LocalCheckpointService`。
- Windows 注入 `LinkedLocalVideoService`；行動裝置使用受應用程式管理的本機影片副本。兩種檢查點流程都不會將影片內容上傳至 Firestore。
- `HealthProvider` 與 `EncryptedHealthRepository` 構成獨立的本機 Health 領域，不依賴雲端帳號或雲端 UID。

## 3. 執行資料流程

### 3.1 Windows 本機檢查點

1. Windows 上的 `BootstrapApp` 直接開啟 `LocalCheckpointEntryPage`。此入口不初始化 Firebase，也不要求登入。
2. `LocalCheckpointService` 讀寫 `checkpoints.json`。目錄可透過編譯期 `LOCAL_CHECKPOINT_DIRECTORY` 定義指定；未指定時使用 `%APPDATA%/InBodySimpleTracker/checkpoints`，若無 `APPDATA`，則以目前目錄作為基底。
3. 選擇影片後，以 `linked-file:` 記錄原始檔案的本機絕對路徑。新匯入不複製影片；來源可位於任何支援的本機資料夾，不要求固定的 gym 資料夾。
4. 播放時開啟 Windows 預設影片播放器。移動、重新命名或刪除原始檔案會使播放不可用，但檢查點中繼資料仍保留。
5. 刪除連結式檢查點只移除其中繼資料，保留原始影片。舊的受管理影片參照仍可讀取；其副本刪除行為與連結原始檔案不同。
6. Windows 檢查點中繼資料保留於本機 JSON，不會透過此流程同步至 Firestore。

### 3.2 行動裝置檢查點與 Web 限制

雲端檢查點流程將中繼資料儲存於 `users/{uid}/checkpoints/{checkpointId}`。iOS/Android 匯入時，會將影片複製至應用程式文件目錄內的 `training_videos/{checkpointId}/{filename}`，並於中繼資料中儲存本機參照。影片內容留在該裝置；其他裝置取得中繼資料時，不會自動取得影片。Web 不支援影片匯入。

匯入與覆核表單僅收集欄位，不會自動分析動作技術、計算次數或評分姿勢。備註是人工觀察；SHA-256 指紋用於重複匯入偵測，不是動作分析。

### 3.3 雲端報告

Windows 入口以外的雲端啟動流程會初始化 Firebase；Web 使用工作階段身分驗證持續性。報告流程依序選取圖片/PDF、擷取文字、解析為 `InbodyReport`，再寫入 Firestore 使用者報告。Dashboard 的報告訂閱與選用 MQTT 整合屬於此雲端領域，不屬於 Windows 檢查點儲存區或私人 Health 資料庫。

### 3.4 私人 Health

私人 Health 透過 SQLCipher、裝置保護金鑰、原生目錄保護與加密備份，在 iOS/Android 儲存資料。Windows/Web 不提供此資料庫後端。`HEALTH_VAULT_VERIFIED` 預設為 false；個人資料匯入、HealthKit 更新、備註寫入及還原仍受原生裝置驗證開關限制。此開關與檢查點可用性獨立，不能僅因程式碼存在或桌面測試通過就宣稱驗證完成。

## 4. 儲存與隱私取捨

| 資料領域 | 儲存位置 | 主要限制 |
|---|---|---|
| Windows 檢查點中繼資料 | 本機 JSON | 明文本機檔案，含檔名、來源絕對路徑、備註與指紋；不是 Health 類型的加密資料庫 |
| Windows 檢查點影片 | 原始本機檔案 | 新增儲存量小，但播放依賴來源檔案可存取 |
| 行動裝置檢查點中繼資料 | 使用者 Firestore 子集合 | 中繼資料同步屬雲端操作；影片留在本機不代表所有中繼資料也只在本機 |
| 行動裝置檢查點影片 | 應用程式文件目錄內的受管理副本 | 額外占用裝置空間；影片不會隨中繼資料傳至另一裝置 |
| 私人 Health | 獨立加密行動資料庫與明確建立的加密備份 | 需要原生驗證與保護金鑰可用；不自動同步雲端 |
| InBody 報告 | 雲端 Firestore | 具有獨立的雲端資料與存取控制考量 |

Git 隱私與執行時隱私是不同邊界。個人紀錄、匯入影片、Health 匯出、備份及本機執行檔案應排除於受追蹤原始碼之外。忽略規則可避免新增檔案遭意外加入，但不會刪除過去已提交的歷史。儲存庫與隱私稽核結果須另附實際證據；本設計審查本身無法證明 GitHub 沒有敏感資料。

## 5. 設計選擇與待釐清事項

- Provider/Service 注入讓本機與雲端儲存重用檢查點表單，不需第二套檢查點模型。
- 本機 JSON 讓 Windows 部署保持輕量，但沒有帳號隔離、加密或自動跨裝置同步。寫入僅於服務實例內序列化，不是多程序資料庫。
- 連結原始檔案避免重複儲存，但明確依賴來源可用性。未來若加入重新連結功能，應保留紀錄並重新確認檔案身分。
- SHA-256 去重適用於檢查點匯入，不代表報告/MQTT 匯入已有冪等機制。
- 既有報告議題仍值得審查：OCR 變化下的解析容錯、報告狀態編排、MQTT 內容驗證與信任、寫入冪等性，以及分頁與讀取成本。這些是審查問題，不代表已觀察到特定故障。

## 6. 審查優先事項

1. 在介面與文件中明確說明各平台的儲存與刪除行為。
2. 發布前檢查儲存庫內容與可達歷史；範例不可提交個人測試資料或真實來源路徑。
3. 新增匯出、備份或同步時，維持 Windows 檢查點與私人 Health 的資料邊界。
4. 啟用私人 Health 驗證開關前，完成原生裝置驗證證據。
5. 報告匯入與 MQTT 可靠性應獨立於檢查點儲存變更評估。

程式碼參照：`lib/main.dart`、`lib/data/models/training_checkpoint.dart`、`lib/data/services/local_checkpoint_service.dart`、`lib/data/services/linked_local_video_service.dart`、`lib/data/services/checkpoint_service.dart`、`lib/data/services/local_video_service_mobile.dart`、`lib/presentation/checkpoints/widgets/checkpoint_video_player_mobile.dart`、`lib/logic/providers/health_provider.dart` 與 `lib/data/services/health_store_mobile.dart`。此次文件更新不宣稱另有執行測試、部署或裝置驗證。

