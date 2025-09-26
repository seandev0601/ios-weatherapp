## Swift/SwiftUI 編碼規範

### Swift 語言規範
- **命名規範**：
  - 類別使用 PascalCase：`WeatherViewModel`
  - 變數和函數使用 camelCase：`getCurrentWeather()`
  - 常數使用 camelCase：`defaultTemperature`
  - 私有變數前綴使用 underscore：`private var _temperature`

- **程式碼組織**：
  - 使用 `// MARK: -` 分組相關功能
  - 按照存取層級排序：public → internal → private
  - 複雜邏輯必須有清楚的註解說明

### SwiftUI 最佳實踐
- **View 組織**：
  - 單一 View 不超過 100 行程式碼
  - 複雜 View 拆解為子 View
  - 使用 `@ViewBuilder` 建構複雜佈局

- **狀態管理**：
  - 優先使用 `@StateObject` 而非 `@ObservedObject`
  - 避免在 View 中直接處理業務邏輯
  - 使用 `@Environment` 傳遞共享資料

### MVVM 架構規範
- **ViewModel 設計**：
  - 繼承 `ObservableObject`
  - 使用 `@Published` 發布狀態變更
  - 所有網路請求都要有錯誤處理
  - 使用 `@MainActor` 確保 UI 更新在主執行緒

- **Model 設計**：
  - 實作 `Codable` 協議
  - 使用 computed properties 處理資料轉換
  - 保持 Model 的純粹性，不包含業務邏輯

### 錯誤處理標準
- **錯誤類型**：
  - 使用 enum 定義錯誤類型
  - 提供使用者友善的錯誤訊息
  - 記錄詳細的錯誤資訊用於除錯

- **異步處理**：
  - 優先使用 async/await
  - 適當使用 Combine 處理複雜的資料流
  - 所有異步操作都要有 timeout 設定

### 測試撰寫規範
- **單元測試**：
  - 每個 public 方法都要有測試
  - 使用 Given-When-Then 模式
  - Mock 外部依賴（網路、資料庫等）

- **UI 測試**：
  - 測試主要使用者流程
  - 使用 accessibility identifier
  - 包含錯誤情境的測試

### 註解和文檔
- **程式碼註解**：
  - 複雜邏輯必須有註解說明
  - 使用 Swift Documentation 格式
  - 避免無意義的註解

- **API 文檔**：
  - Public 介面必須有完整文檔
  - 包含使用範例
  - 說明參數和回傳值