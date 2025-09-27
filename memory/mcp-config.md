## MCP 伺服器記憶體匯入配置

### 5種核心 MCP 伺服器設定

#### XcodeBuildMCP
- **官方來源**：[cameroncooke/XcodeBuildMCP](https://github.com/cameroncooke/XcodeBuildMCP)
- **核心作用**：iOS 專案建置和模擬器管理
- **安裝指令**：`claude mcp add xcodebuild npx xcodebuildmcp@latest`
- **主要功能**：
  - 專案管理：發現專案、建置操作、專案資訊檢索
  - 模擬器控制：管理 iOS 模擬器、安裝和啟動應用、截圖和日誌
  - 裝置管理：發現和管理實體 Apple 裝置
  - 自動化工作流程：支援增量建置、UI 自動化


#### GitHub MCP
- **官方來源**：[GitHub Copilot MCP](https://api.githubcopilot.com/mcp)
- **核心作用**：GitHub 平台 AI 整合工具
- **安裝指令**：`claude mcp add github --scope project --transport http https://api.githubcopilot.com/mcp -H "Authorization: Bearer YOUR_GITHUB_PAT"`
- **環境變數**：`export GITHUB_TOKEN=your_github_pat`
- **主要功能**：
  - 儲存庫管理：讀取和分析 GitHub 儲存庫內容
  - Issues 和 PR：管理 Issues、Pull Requests 和程式碼審查
  - 程式碼操作：直接讀取、分析和修改儲存庫中的程式碼

#### filesystem MCP
- **官方來源**：[modelcontextprotocol/server-filesystem](https://github.com/modelcontextprotocol/server-filesystem)
- **核心作用**：智能檔案系統管理和專案結構最佳化
- **安裝指令**：`claude mcp add filesystem npx @modelcontextprotocol/server-filesystem`
- **主要功能**：
  - 結構分析：分析專案檔案和目錄結構
  - 重構建議：建議更好的檔案組織方式
  - 批量操作：安全地移動、重新命名檔案和目錄

#### context7 MCP
- **官方來源**：[upstash/context7](https://github.com/upstash/context7)
- **核心作用**：即時程式碼文檔和 API 參考工具
- **安裝指令**：`claude mcp add context7 npx @upstash/context7-mcp`
- **使用語法**：在提示詞前加上 "use context7"
- **主要功能**：
  - 即時文檔：提供最新版本的程式庫和框架文檔
  - 精確範例：獲取正確的、可運行的程式碼範例
  - 版本一致：確保程式碼範例與實際使用的程式庫版本一致

#### Serena MCP
- **官方來源**：[oraios/serena](https://github.com/oraios/serena)
- **核心作用**：強大的開源編碼代理工具包，提供 IDE 級語義程式碼理解
- **前置需求**：需要安裝 `uv` (Python 套件管理工具)
- **安裝方式**：提供兩種運行方式

  **方式 1：使用 uvx (推薦，無需本地安裝)**
  ```bash
  # 1. 安裝 uv
  brew install uv

  # 2. 使用 uvx 直接運行最新版本
  claude mcp add-json "serena" '{"command":"uvx","args":["--from","git+https://github.com/oraios/serena","serena","start-mcp-server"]}'
  ```

  **方式 2：本地安裝 (適合需要自定義配置)**
  ```bash
  # 1. 安裝 uv
  brew install uv

  # 2. 克隆儲存庫
  git clone https://github.com/oraios/serena
  cd serena

  # 3. (可選) 編輯配置
  uv run serena config edit

  # 4. 添加到 Claude Code
  claude mcp add-json "serena" '{"command":"uv","args":["run","serena","start-mcp-server"],"cwd":"/absolute/path/to/serena"}'
  ```
- **重要特性**：
  - **自動 Dashboard**：啟動時會在 localhost 開啟 web-based dashboard，顯示日誌並允許關閉伺服器
  - **stdio 通信**：使用標準輸入/輸出與客戶端通信
  - **可配置**：支援命令列參數和配置檔案自訂行為

- **主要功能**：
  - **語義程式碼理解**：使用 LSP 進行符號級分析、AST 和引用圖
  - **精確程式碼檢索**：`find_symbol`、`find_referencing_symbols` 等精確定位工具
  - **符號層級編輯**：`insert_after_symbol` 等精確編輯工具
  - **Token 效益優化**：減少上下文需求，大幅降低 API 成本
  - **大型專案支援**：維持全局專案上下文，適合複雜程式碼庫

### MCP 記憶體匯入策略
每個 MCP 都會自動讀取這個記憶體配置，確保：
- 使用一致的開發標準
- 理解專案特定的技術棧
- 遵循階段性 GitHub workflow

### MCP 協同工作原則
- **自動選擇**：讓 Claude 根據任務自動選擇最適合的 MCP
- **自然語言**：用描述需求的方式，而非指定工具
- **工具整合**：相信 MCP 生態系統的智慧協調

### 專案 MCP 配置範例 (.mcp.json)
```json
{
  "mcp": {
    "servers": {
      "xcodebuild": {
        "command": "npx",
        "args": ["xcodebuildmcp@latest"]
      },
      "github": {
        "transport": "http",
        "url": "https://api.githubcopilot.com/mcp",
        "headers": {
          "Authorization": "Bearer ${GITHUB_TOKEN}"
        }
      },
      "filesystem": {
        "command": "npx",
        "args": ["@modelcontextprotocol/server-filesystem"],
        "env": {
          "ALLOWED_PATHS": "./WeatherApp,./Tests,./Resources"
        }
      },
      "context7": {
        "command": "npx",
        "args": ["@upstash/context7-mcp"],
        "env": {
          "PROJECT_ROOT": "."
        }
      },
      "serena": {
        "command": "uvx",
        "args": [
          "--from",
          "git+https://github.com/oraios/serena",
          "serena",
          "start-mcp-server"
        ]
      }
    }
  }
}
```