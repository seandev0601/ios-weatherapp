## WeatherApp 技術棧配置

### 核心技術架構
- **平台**：iOS 17.0+
- **語言**：Swift 5.9+
- **UI 框架**：SwiftUI
- **架構模式**：MVVM + Combine
- **測試框架**：XCTest + XCUITest
- **天氣 API**：Apple WeatherKit
- **AI 整合**：Claude Code + 6種 MCP

### 開發工具鏈
- **IDE**：Xcode 15.0+
- **版本控制**：Git + GitHub
- **依賴管理**：Swift Package Manager
- **CI/CD**：GitHub Actions (可選)
- **記憶體系統**：Claude Code Memory Import

### MCP 生態系統
- **XcodeBuildMCP**：專案建置和模擬器管理
- **Figma MCP**：UI 設計同步和規範提取
- **GitHub MCP**：版本控制和協作管理
- **filesystem MCP**：專案結構最佳化
- **context7 MCP**：即時程式碼文檔參考
- **Serena MCP**：智慧程式碼分析工具

### 資料層架構
- **本地儲存**：Core Data
- **網路層**：URLSession + Combine
- **資料模型**：Codable + ObservableObject
- **狀態管理**：@StateObject, @ObservedObject, @Published

### 品質保證
- **測試覆蓋率**：目標 80%+
- **程式碼品質**：SwiftLint (可選)
- **效能監控**：Instruments
- **無障礙支援**：Accessibility Guidelines

### 部署需求
- **最低支援**：iOS 17.0
- **目標裝置**：iPhone, iPad
- **App Store**：準備發布設定
- **TestFlight**：Beta 測試配置