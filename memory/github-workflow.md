## WeatherApp 階段性 Git Workflow (個人練習版)

### 核心原則：每個小階段完成後都要提交到 Git

這是簡化的個人學習流程，專注於版本控制最佳實踐，略過團隊協作的 PR 流程。

### 7 階段完整工作流程

#### 階段 1：記憶體系統設定
- **Git 操作**：直接在 `main` 分支工作
- **內容**：建立模組化記憶體系統，實踐第六章 2.4 匯入機制
- **檢核點**：
  - ✅ CLAUDE.md 主記憶體檔案已建立
  - ✅ 6 個 memory 模組檔案已完成
  - ✅ @memory/ 匯入語法正確運作
- **提交操作**：
  ```bash
  git add .
  git commit -m "feat: setup modular memory system with import mechanism"
  git push origin main
  ```

#### 階段 2：MCP 伺服器配置
- **Git 操作**：直接在 `main` 分支工作
- **內容**：安裝並配置 5 種 MCP 伺服器
- **檢核點**：
  - ✅ 5 種 MCP 伺服器安裝成功
  - ✅ .mcp.json 配置檔案已建立
  - ✅ 所有 MCP 連線測試通過
- **提交操作**：
  ```bash
  git add .mcp.json .env
  git commit -m "feat: configure 5 MCP servers with memory integration"
  git push origin main
  ```

#### 階段 3：Xcode 專案初始化
- **Git 操作**：直接在 `main` 分支工作
- **內容**：建立 Xcode 專案和基礎架構
- **檢核點**：
  - ✅ Xcode 專案建立完成
  - ✅ MVVM 資料夾結構建立
  - ✅ 基礎測試 target 設定完成
- **提交操作**：
  ```bash
  git add WeatherApp.xcodeproj/ WeatherApp/
  git commit -m "feat: setup Xcode project with basic MVVM structure"
  git push origin main
  ```

#### 階段 4：產品設計文檔
- **Git 操作**：直接在 `main` 分支工作
- **內容**：建立 PRD、Spec、UI 設計文檔
- **檢核點**：
  - ✅ PRD.md 產品需求完成
  - ✅ SPEC.md 技術規格完成
  - ✅ UI_DESIGN.md 設計規範完成
- **提交操作**：
  ```bash
  git add PRD.md SPEC.md UI_DESIGN.md
  git commit -m "docs: add product requirements and technical specifications"
  git push origin main
  ```

#### 階段 5：WeatherKit 權限設定
- **Git 操作**：直接在 `main` 分支工作
- **內容**：完成 Apple Developer 和 WeatherKit 權限配置
- **檢核點**：
  - ✅ WeatherKit capability 已啟用
  - ✅ 專案權限設定完成
  - ✅ 專案可正常建置
- **提交操作**：
  ```bash
  git add WeatherApp.xcodeproj/ WeatherApp/Info.plist
  git commit -m "feat: configure WeatherKit permissions and capabilities"
  git push origin main
  ```

#### 階段 6：MVVM 架構實作
- **Git 操作**：直接在 `main` 分支工作
- **內容**：建立完整的 MVVM 架構和基礎程式碼
- **檢核點**：
  - ✅ Models、ViewModels、Services 檔案建立
  - ✅ 基礎架構可正常編譯
  - ✅ 架構符合編碼規範
- **提交操作**：
  ```bash
  git add WeatherApp/Models/ WeatherApp/ViewModels/ WeatherApp/Services/
  git commit -m "feat: implement MVVM architecture foundation"
  git push origin main
  ```

#### 階段 7：核心功能實作
- **Git 操作**：直接在 `main` 分支工作
- **內容**：實作天氣查詢和 UI 顯示功能
- **檢核點**：
  - ✅ 當日天氣功能完成
  - ✅ 7天預報功能完成
  - ✅ 所有測試通過
- **提交操作**：
  ```bash
  git add .
  git commit -m "feat: implement weather display and forecast features"
  git push origin main
  ```

### 最終發布流程
- **Git 操作**：建立 release tag
- **內容**：標記專案完成版本
- **提交操作**：
  ```bash
  git add .
  git commit -m "feat: complete WeatherApp v1.0.0 implementation"
  git tag -a v1.0.0 -m "WeatherApp version 1.0.0 - AI輔助開發實踐完成"
  git push origin main --tags
  ```

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
chore: update .gitignore for iOS development
```

### 個人學習 Git 最佳實踐

#### 📝 **提交頻率建議**
- **小步提交**：每完成一個小功能就提交
- **描述清楚**：commit message 要明確說明變更內容
- **定期推送**：避免本地累積太多未推送的 commit

#### 🔍 **版本追蹤建議**
- **使用 tags**：在重要里程碑建立 tag
- **保持 main 分支穩定**：每次推送前確保程式碼可以正常運行
- **備份重要版本**：GitHub 自動提供雲端備份

#### 📚 **學習記錄建議**
- **README 更新**：記錄學習進度和心得
- **CHANGELOG 維護**：記錄每個階段的主要變更
- **問題記錄**：將遇到的問題和解決方案記錄在 commit message 或文檔中

### 記憶體匯入的優勢
透過記憶體匯入機制，每個階段的 Git workflow 都能自動：
- **理解專案脈絡**：自動載入技術棧和開發規範
- **遵循一致標準**：確保每個 commit 符合規範
- **維持程式碼品質**：自動應用測試和品質要求
- **協調 MCP 工具**：根據階段選擇適當的 MCP 協助

### 階段性開發的學習優勢
1. **降低風險**：小步快跑，問題容易定位和解決
2. **進度可視化**：透過 Git history 清楚看到學習進展
3. **品質保證**：每個階段都有明確的檢核標準
4. **經驗累積**：逐步建立 AI 輔助開發的最佳實踐
5. **記憶體驅動**：Claude 透過記憶體理解每個階段的目標

### 個人練習的額外建議
- **建立學習筆記分支**：可以考慮建立 `notes` 分支記錄學習心得
- **定期檢視 Git log**：使用 `git log --oneline` 回顧學習歷程
- **善用 Git tags**：在重要學習里程碑建立 tag，方便日後回顧