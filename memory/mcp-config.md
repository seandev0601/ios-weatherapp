## MCP 伺服器記憶體匯入配置

### 6種核心 MCP 伺服器設定

#### XcodeBuildMCP
- **官方來源**：[cameroncooke/XcodeBuildMCP](https://github.com/cameroncooke/XcodeBuildMCP)
- **核心作用**：iOS 專案建置和模擬器管理
- **安裝指令**：`claude mcp add xcodebuild npx xcodebuildmcp@latest`
- **主要功能**：
  - 專案管理：發現專案、建置操作、專案資訊檢索
  - 模擬器控制：管理 iOS 模擬器、安裝和啟動應用、截圖和日誌
  - 裝置管理：發現和管理實體 Apple 裝置
  - 自動化工作流程：支援增量建置、UI 自動化

#### Figma MCP
- **官方來源**：[modelcontextprotocol/server-figma](https://github.com/modelcontextprotocol/server-figma)
- **核心作用**：UI 設計協作整合和設計系統同步
- **安裝指令**：`claude mcp add figma npx @modelcontextprotocol/server-figma`
- **環境變數**：`export FIGMA_ACCESS_TOKEN=figd_your_figma_token`
- **主要功能**：
  - 設計提取：從 Figma 檔案提取顏色、字體、間距規範
  - 元件同步：將設計元件轉換為程式碼元件
  - 樣式生成：自動生成 SwiftUI 樣式和主題檔案

#### GitHub MCP
- **官方來源**：[github/github-mcp-server](https://github.com/github/github-mcp-server)
- **核心作用**：GitHub 平台 AI 整合工具
- **安裝指令**：`claude mcp add github npx github/github-mcp-server`
- **環境變數**：`export GITHUB_TOKEN=ghp_your_github_token`
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
- **核心作用**：智慧程式碼分析與編輯工具箱
- **安裝指令**：`claude mcp add serena npx @oraios/serena`
- **主要功能**：
  - 語意程式碼檢索：使用 LSP 進行精確的程式碼搜尋
  - 符號層級編輯：在程式碼符號層級進行精確的修改和重構
  - 多語言支援：支援 20+ 種程式語言的深度分析

### MCP 記憶體匯入策略
每個 MCP 都會自動讀取這個記憶體配置，確保：
- 使用一致的開發標準
- 理解專案特定的技術棧
- 遵循階段性 GitHub workflow

### MCP 協同工作原則
- **自動選擇**：讓 Claude 根據任務自動選擇最適合的 MCP
- **自然語言**：用描述需求的方式，而非指定工具
- **工具整合**：相信 MCP 生態系統的智慧協調

### .mcp.json 完整配置範例
```json
{
  "servers": {
    "xcodebuild": {
      "command": "npx",
      "args": ["xcodebuildmcp@latest"]
    },
    "figma": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-figma"],
      "env": {
        "FIGMA_ACCESS_TOKEN": "${FIGMA_TOKEN}"
      }
    },
    "github": {
      "command": "npx",
      "args": ["github/github-mcp-server"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
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
      "command": "npx",
      "args": ["@oraios/serena"]
    }
  }
}
```