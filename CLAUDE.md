# WeatherApp 專案記憶體 - 模組化架構

@memory/tech-stack.md
@memory/coding-standards.md
@memory/mcp-config.md
@memory/testing-strategy.md
@memory/github-workflow.md
@memory/weatherkit-config.md

## 專案概述
- **類型**：iOS 天氣應用 + AI 輔助開發實踐
- **架構**：SwiftUI + MVVM + TDD
- **API**：Apple WeatherKit
- **AI 工具**：Claude Code + 5種 MCP 整合
- **記憶體系統**：基於第六章 2.4 記憶體匯入機制

## 記憶體匯入機制特點
- **最大匯入深度**：5層 (官方限制)
- **模組化管理**：使用 @memory/ 語法組織
- **自動載入**：Claude 啟動時自動遞迴載入
- **優先順序**：專案記憶體 > 使用者記憶體

## 開發原則
- 使用自然語言驅動開發流程
- MCP 工具協同工作優先
- 每個階段完成後都要經過 GitHub workflow
- 保持 80%+ 測試覆蓋率
- Git Flow: feature → develop → main

## 專案目標
展示專業 iOS 開發 + AI 輔助最佳實踐，讓中階工程師在 90 分鐘內掌握：
- 完整的記憶體驅動開發流程
- MCP 生態系統的實際應用
- 階段性 GitHub workflow 管理
- TDD + MVVM + SwiftUI 專業架構

## 回應
使用正體中文回覆