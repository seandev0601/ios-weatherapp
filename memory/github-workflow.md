## WeatherApp 階段性 GitHub Workflow

### 核心原則：每個小階段完成後都要做 workflow

這是專業團隊開發的真實流程，通過 AI 輔助實現高效協作。

### 7 階段完整工作流程

#### 階段 1：記憶體系統設定
- **分支**：`feature/memory-system-setup` → `develop`
- **內容**：建立模組化記憶體系統，實踐第六章 2.4 匯入機制
- **檢核點**：
  - ✅ CLAUDE.md 主記憶體檔案已建立
  - ✅ 6 個 memory 模組檔案已完成
  - ✅ @memory/ 匯入語法正確運作
- **Commit 格式**：`feat: setup modular memory system with import mechanism`

#### 階段 2：MCP 伺服器配置
- **分支**：`feature/mcp-servers-config` → `develop`
- **內容**：安裝並配置 6 種 MCP 伺服器
- **檢核點**：
  - ✅ 6 種 MCP 伺服器安裝成功
  - ✅ .mcp.json 配置檔案已建立
  - ✅ 所有 MCP 連線測試通過
- **Commit 格式**：`feat: configure 6 MCP servers with memory integration`

#### 階段 3：專案初始化
- **分支**：`feature/project-setup` → `develop`
- **內容**：建立 Xcode 專案和 MVVM 基礎架構
- **檢核點**：
  - ✅ Xcode 專案建立完成
  - ✅ WeatherKit 權限設定完成
  - ✅ MVVM 資料夾結構建立
  - ✅ 基礎測試 target 設定完成
- **Commit 格式**：`feat: setup Xcode project with MVVM architecture`

#### 階段 4：當日天氣功能 (TDD)
- **分支**：`feature/current-weather-tdd` → `develop`
- **內容**：使用 TDD 方式實作當日天氣顯示功能
- **檢核點**：
  - ✅ 單元測試先行編寫
  - ✅ CurrentWeatherView 實作完成
  - ✅ WeatherViewModel 基礎功能完成
  - ✅ 所有測試通過
- **Commit 格式**：`feat: implement current weather display with TDD`

#### 階段 5：週間預報功能 (TDD)
- **分支**：`feature/weekly-forecast-tdd` → `develop`
- **內容**：實作 7 天天氣預報列表功能
- **檢核點**：
  - ✅ WeeklyForecastView 實作完成
  - ✅ DailyWeatherRow 子元件完成
  - ✅ SwiftUI List 性能最佳化
  - ✅ 測試覆蓋率達標
- **Commit 格式**：`feat: implement weekly forecast with TDD`

#### 階段 6：設計系統同步
- **分支**：`feature/design-system-sync` → `develop`
- **內容**：使用 Figma MCP 同步設計系統
- **檢核點**：
  - ✅ Figma 設計 tokens 提取完成
  - ✅ DesignSystem.swift 檔案建立
  - ✅ 所有 UI 元件套用設計規範
  - ✅ Light/Dark Mode 支援完成
- **Commit 格式**：`feat: integrate Figma design system with SwiftUI`

#### 階段 7：品質保證測試
- **分支**：`feature/quality-assurance` → `develop`
- **內容**：執行完整測試和品質檢查
- **檢核點**：
  - ✅ 單元測試覆蓋率 ≥ 80%
  - ✅ UI 測試全部通過
  - ✅ 效能基準測試通過
  - ✅ Accessibility 驗證完成
- **Commit 格式**：`test: comprehensive quality assurance and performance testing`

### 最終發布流程
- **分支**：`release/v1.0.0` → `main`
- **內容**：整合所有功能，準備發布
- **檢核點**：
  - ✅ 所有 feature 分支已 merge 到 develop
  - ✅ 整合測試全部通過
  - ✅ App Store 發布準備完成
  - ✅ 文檔和 CHANGELOG 更新完成

### Commit 訊息標準
遵循 [Conventional Commits](https://www.conventionalcommits.org/) 規範：

```bash
# 功能新增
feat: add weather chart visualization
feat(ui): implement dark mode support

# Bug 修復
fix: resolve memory leak in weather service
fix(api): handle network timeout properly

# 測試相關
test: add unit tests for WeatherViewModel
test(ui): implement accessibility tests

# 重構
refactor: optimize WeatherData model structure
refactor(view): simplify weather card layout

# 文檔更新
docs: update API documentation
docs(readme): add installation instructions

# 建置相關
build: update Xcode project settings
ci: add GitHub Actions workflow
```

### Pull Request 標準

#### PR 標題格式
- `feat: [功能描述]`
- `fix: [問題描述]`
- `test: [測試內容]`
- `refactor: [重構內容]`

#### PR 描述模板
```markdown
## 📱 功能概述
簡要描述這個 PR 的主要變更和目的

## 🚀 主要變更
- ✅ [具體變更 1]
- ✅ [具體變更 2]
- ✅ [具體變更 3]

## 🧪 測試結果
- 單元測試：X/X 通過
- UI 測試：X/X 通過
- 測試覆蓋率：X%

## 📸 截圖
[如果有 UI 變更，請附上截圖]

## 🔗 相關 Issues
- Closes #[issue number]
- Related to #[issue number]

## ✅ 檢查清單
- [ ] 程式碼遵循專案編碼規範
- [ ] 所有測試通過
- [ ] 文檔已更新（如需要）
- [ ] UI 變更已在多種裝置測試
```

### 分支保護規則
- **main 分支**：
  - 需要 PR review
  - 必須通過所有檢查
  - 不允許 force push
  - 需要 branch up-to-date

- **develop 分支**：
  - 需要 PR review
  - 必須通過 CI 檢查
  - 允許 squash merge

### 記憶體匯入的優勢
透過記憶體匯入機制，每個階段的 workflow 都能自動：
- **理解專案脈絡**：自動載入技術棧和開發規範
- **遵循一致標準**：確保每個 commit 和 PR 符合標準
- **維持程式碼品質**：自動應用測試和品質要求
- **協調 MCP 工具**：根據階段選擇適當的 MCP 協助

### GitHub Actions 整合 (可選)
```yaml
name: WeatherApp CI
on:
  pull_request:
    branches: [develop, main]

jobs:
  test:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run Tests
        run: xcodebuild test -scheme WeatherApp
      - name: Check Coverage
        run: xcrun xccov view --report
```

### 階段性開發的優勢
1. **降低風險**：小步快跑，問題容易定位
2. **持續整合**：及時發現衝突和問題
3. **品質保證**：每個階段都有明確的檢核標準
4. **團隊協作**：清楚的分工和進度追蹤
5. **記憶體驅動**：AI 透過記憶體理解每個階段的目標