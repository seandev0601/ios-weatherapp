import SwiftUI
import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// WeatherApp 設計系統
/// 提供一致的顏色、字體、間距和動畫規範
/// 支援 Light/Dark Mode 自動切換
public struct DesignSystem {

    // MARK: - Colors

    /// 顏色系統 - 支援明暗模式
    public struct Colors {

        // MARK: - Primary Colors

        /// 主要藍色 - 用於主要操作和強調
        public static let primary = Color.blue

        /// 次要青色 - 用於輔助元素和漸層
        public static let secondary = Color.cyan

        /// 強調橙色 - 用於警告和重要提醒
        public static let accent = Color.orange

        // MARK: - Weather Colors

        /// 晴天顏色
        public static let sunny = Color.yellow

        /// 多雲顏色
        public static let cloudy = Color.gray

        /// 雨天顏色
        public static let rainy = Color.blue

        /// 雪天顏色
        public static let snowy = Color.white

        // MARK: - Temperature Colors

        /// 極冷溫度 (< 0°C)
        public static let freezing = Color.blue

        /// 低溫 (0-15°C)
        public static let cold = Color.cyan

        /// 舒適溫度 (15-25°C)
        public static let comfortable = Color.green

        /// 溫暖溫度 (25-35°C)
        public static let warm = Color.yellow

        /// 炎熱溫度 (> 35°C)
        public static let hot = Color.red

        // MARK: - Semantic Colors

        /// 成功狀態顏色
        public static let success = Color.green

        /// 警告狀態顏色
        public static let warning = Color.orange

        /// 錯誤狀態顏色
        public static let error = Color.red

        /// 資訊狀態顏色
        public static let info = Color.blue

        // MARK: - Background Colors

        /// 主要背景顏色 - 自適應明暗模式
        #if canImport(UIKit)
        public static let background = Color(UIColor.systemBackground)
        #else
        public static let background = Color.clear
        #endif

        /// 次要背景顏色
        #if canImport(UIKit)
        public static let secondaryBackground = Color(UIColor.secondarySystemBackground)
        #else
        public static let secondaryBackground = Color.secondary
        #endif

        /// 群組背景顏色
        #if canImport(UIKit)
        public static let groupedBackground = Color(UIColor.systemGroupedBackground)
        #else
        public static let groupedBackground = Color.clear
        #endif

        /// 卡片背景材質
        public static let cardBackground = Material.regularMaterial

        // MARK: - Text Colors

        /// 主要文字顏色
        public static let primaryText = Color.primary

        /// 次要文字顏色
        public static let secondaryText = Color.secondary

        /// 三級文字顏色
        #if canImport(UIKit)
        public static let tertiaryText = Color(UIColor.tertiaryLabel)
        #else
        public static let tertiaryText = Color.secondary
        #endif

        /// 反轉文字顏色 - 用於深色背景
        #if canImport(UIKit)
        public static let inverseText = Color(UIColor.systemBackground)
        #else
        public static let inverseText = Color.primary
        #endif

        // MARK: - Border Colors

        /// 分隔線顏色
        #if canImport(UIKit)
        public static let separator = Color(UIColor.separator)
        #else
        public static let separator = Color.secondary.opacity(0.3)
        #endif

        /// 邊框顏色
        #if canImport(UIKit)
        public static let border = Color(UIColor.quaternaryLabel)
        #else
        public static let border = Color.secondary.opacity(0.2)
        #endif
    }

    // MARK: - Typography

    /// 字體系統
    public struct Typography {

        // MARK: - Display Fonts

        /// 超大標題 - 用於主要溫度顯示
        public static let displayLarge = Font.system(size: 48, weight: .thin, design: .rounded)

        /// 大標題 - 用於重要數值
        public static let displayMedium = Font.system(size: 36, weight: .light, design: .rounded)

        /// 小標題 - 用於次要數值
        public static let displaySmall = Font.system(size: 24, weight: .regular, design: .rounded)

        // MARK: - Headline Fonts

        /// 主標題 - 用於頁面標題
        public static let headlineLarge = Font.title

        /// 中標題 - 用於區塊標題
        public static let headlineMedium = Font.title2

        /// 小標題 - 用於次要標題
        public static let headlineSmall = Font.title3

        // MARK: - Body Fonts

        /// 大內文 - 用於重要描述
        public static let bodyLarge = Font.body

        /// 中內文 - 用於一般文字
        public static let bodyMedium = Font.callout

        /// 小內文 - 用於輔助資訊
        public static let bodySmall = Font.footnote

        // MARK: - Label Fonts

        /// 大標籤 - 用於重要標籤
        public static let labelLarge = Font.subheadline

        /// 中標籤 - 用於一般標籤
        public static let labelMedium = Font.caption

        /// 小標籤 - 用於細節標籤
        public static let labelSmall = Font.caption2

        // MARK: - Weight Modifiers

        /// 粗體修飾符
        public static func bold(_ font: Font) -> Font {
            return font.weight(.bold)
        }

        /// 半粗體修飾符
        public static func semibold(_ font: Font) -> Font {
            return font.weight(.semibold)
        }

        /// 中等重量修飾符
        public static func medium(_ font: Font) -> Font {
            return font.weight(.medium)
        }
    }

    // MARK: - Spacing

    /// 間距系統 - 8pt 基準網格
    public struct Spacing {

        /// 極小間距 (4pt)
        public static let extraSmall: CGFloat = 4

        /// 小間距 (8pt)
        public static let small: CGFloat = 8

        /// 中間距 (12pt)
        public static let medium: CGFloat = 12

        /// 大間距 (16pt)
        public static let large: CGFloat = 16

        /// 特大間距 (20pt)
        public static let extraLarge: CGFloat = 20

        /// 超大間距 (24pt)
        public static let xxLarge: CGFloat = 24

        /// 巨大間距 (32pt)
        public static let xxxLarge: CGFloat = 32

        /// 最大間距 (48pt)
        public static let maximum: CGFloat = 48
    }

    // MARK: - Corner Radius

    /// 圓角系統
    public struct CornerRadius {

        /// 無圓角
        public static let none: CGFloat = 0

        /// 小圓角 - 用於按鈕和小元件
        public static let small: CGFloat = 8

        /// 中圓角 - 用於卡片
        public static let medium: CGFloat = 12

        /// 大圓角 - 用於主要容器
        public static let large: CGFloat = 16

        /// 特大圓角 - 用於對話框
        public static let extraLarge: CGFloat = 24

        /// 圓形 - 用於頭像和圓形按鈕
        public static let circle: CGFloat = 50
    }

    // MARK: - Shadows

    /// 陰影系統
    public struct Shadow {

        /// 輕微陰影 - 用於懸浮元素
        public static let light = (
            color: Color.black.opacity(0.05),
            radius: CGFloat(4),
            x: CGFloat(0),
            y: CGFloat(2)
        )

        /// 中等陰影 - 用於卡片
        public static let medium = (
            color: Color.black.opacity(0.1),
            radius: CGFloat(8),
            x: CGFloat(0),
            y: CGFloat(4)
        )

        /// 重陰影 - 用於對話框
        public static let heavy = (
            color: Color.black.opacity(0.15),
            radius: CGFloat(12),
            x: CGFloat(0),
            y: CGFloat(6)
        )

        /// 強烈陰影 - 用於主要浮動元素
        public static let intense = (
            color: Color.black.opacity(0.2),
            radius: CGFloat(16),
            x: CGFloat(0),
            y: CGFloat(8)
        )
    }

    // MARK: - Animations

    /// 動畫系統
    public struct Animation {

        /// 快速動畫 - 用於即時反饋
        public static let fast = SwiftUI.Animation.easeInOut(duration: 0.15)

        /// 標準動畫 - 用於一般轉場
        public static let standard = SwiftUI.Animation.easeInOut(duration: 0.3)

        /// 慢速動畫 - 用於重要轉場
        public static let slow = SwiftUI.Animation.easeInOut(duration: 0.5)

        /// 彈跳動畫 - 用於強調效果
        public static let bounce = SwiftUI.Animation.spring(response: 0.5, dampingFraction: 0.6)

        /// 平滑動畫 - 用於滑動效果
        public static let smooth = SwiftUI.Animation.timingCurve(0.25, 0.1, 0.25, 1.0, duration: 0.4)

        /// 延遲動畫工廠
        public static func delayed(_ delay: Double) -> SwiftUI.Animation {
            return standard.delay(delay)
        }
    }

    // MARK: - Gradients

    /// 漸層系統
    public struct Gradients {

        /// 天氣主題漸層
        public static let weather = LinearGradient(
            colors: [Colors.primary, Colors.secondary],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        /// 溫度漸層工廠
        public static func temperature(for temp: Double) -> LinearGradient {
            let colors: [Color] = {
                switch temp {
                case ..<0:
                    return [Colors.freezing, Colors.cold]
                case 0..<15:
                    return [Colors.cold, Colors.comfortable]
                case 15..<25:
                    return [Colors.comfortable, Colors.warm]
                case 25..<35:
                    return [Colors.warm, Colors.hot]
                default:
                    return [Colors.hot, Colors.error]
                }
            }()

            return LinearGradient(
                colors: colors,
                startPoint: .leading,
                endPoint: .trailing
            )
        }

        /// 背景漸層
        public static let background = LinearGradient(
            colors: [Colors.background, Colors.secondaryBackground],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // MARK: - Accessibility

    /// 無障礙設計規範
    public struct Accessibility {

        /// 最小觸控目標尺寸
        public static let minimumTouchTarget: CGFloat = 44

        /// 高對比度顏色
        #if canImport(UIKit)
        public static let highContrast = (
            foreground: Color.primary,
            background: Color(UIColor.systemBackground)
        )
        #else
        public static let highContrast = (
            foreground: Color.primary,
            background: Color.clear
        )
        #endif

        /// 動態字體支援
        public static func scaledFont(_ font: Font) -> Font {
            return font
        }

        /// 減少動畫設定
        public static var reduceMotion: Bool {
            #if canImport(UIKit)
            return UIAccessibility.isReduceMotionEnabled
            #else
            return false
            #endif
        }
    }
}

// MARK: - Design System Extensions

extension View {

    /// 套用卡片樣式
    public func cardStyle() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                    .fill(DesignSystem.Colors.cardBackground)
                    .shadow(
                        color: DesignSystem.Shadow.medium.color,
                        radius: DesignSystem.Shadow.medium.radius,
                        x: DesignSystem.Shadow.medium.x,
                        y: DesignSystem.Shadow.medium.y
                    )
            )
            .padding(.horizontal, DesignSystem.Spacing.large)
    }

    /// 套用主要按鈕樣式
    public func primaryButtonStyle() -> some View {
        self
            .padding(.horizontal, DesignSystem.Spacing.large)
            .padding(.vertical, DesignSystem.Spacing.medium)
            .background(DesignSystem.Colors.primary)
            .foregroundColor(DesignSystem.Colors.inverseText)
            .cornerRadius(DesignSystem.CornerRadius.small)
            .shadow(
                color: DesignSystem.Shadow.light.color,
                radius: DesignSystem.Shadow.light.radius,
                x: DesignSystem.Shadow.light.x,
                y: DesignSystem.Shadow.light.y
            )
    }

    /// 套用標準轉場動畫
    public func standardTransition() -> some View {
        self
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .animation(DesignSystem.Animation.standard, value: UUID())
    }

    /// 套用溫度顏色
    public func temperatureColor(for temperature: Double) -> some View {
        self.foregroundColor(Self.temperatureColor(temperature))
    }

    /// 取得溫度對應顏色
    private static func temperatureColor(_ temp: Double) -> Color {
        switch temp {
        case ..<0:
            return DesignSystem.Colors.freezing
        case 0..<15:
            return DesignSystem.Colors.cold
        case 15..<25:
            return DesignSystem.Colors.comfortable
        case 25..<35:
            return DesignSystem.Colors.warm
        default:
            return DesignSystem.Colors.hot
        }
    }
}

// MARK: - Design Tokens

/// 設計代幣 - 便於主題切換
public struct DesignTokens {

    /// 當前主題模式
    @Environment(\.colorScheme) private var colorScheme

    /// 根據主題返回適當顏色
    public func adaptiveColor(light: Color, dark: Color) -> Color {
        return colorScheme == .dark ? dark : light
    }

    /// 根據主題返回適當透明度
    public func adaptiveOpacity(light: Double, dark: Double) -> Double {
        return colorScheme == .dark ? dark : light
    }
}

// MARK: - Material Design Integration

/// Material Design 3.0 整合
public struct MaterialDesign {

    /// 表面材質
    public static let surfaceMaterial = Material.regularMaterial

    /// 薄材質
    public static let thinMaterial = Material.thinMaterial

    /// 厚材質
    public static let thickMaterial = Material.thickMaterial

    /// 超薄材質
    public static let ultraThinMaterial = Material.ultraThinMaterial

    /// 超厚材質
    public static let ultraThickMaterial = Material.ultraThickMaterial
}