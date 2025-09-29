import SwiftUI

/// 載入骨架畫面組件
/// 提供優雅的載入狀態視覺反饋
struct SkeletonView: View {

    // MARK: - Properties
    let style: SkeletonStyle

    // MARK: - State
    @State private var isAnimating = false

    // MARK: - Body
    var body: some View {
        RoundedRectangle(cornerRadius: style.cornerRadius)
            .fill(skeletonGradient)
            .frame(width: style.width, height: style.height)
            .overlay(
                // 閃光效果
                shimmerOverlay
            )
            .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
            .onAppear {
                startAnimation()
            }
            .accessibilityLabel("Loading content")
            .accessibilityValue("Please wait")
    }

    // MARK: - Private Views

    /// 閃光覆蓋層
    private var shimmerOverlay: some View {
        LinearGradient(
            colors: [
                Color.clear,
                DesignSystem.Colors.primaryText.opacity(0.1),
                Color.clear
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        .rotationEffect(.degrees(30))
        .offset(x: isAnimating ? 300 : -300)
        .animation(
            Animation.linear(duration: 1.5).repeatForever(autoreverses: false),
            value: isAnimating
        )
    }

    /// 骨架漸層
    private var skeletonGradient: LinearGradient {
        LinearGradient(
            colors: [
                DesignSystem.Colors.secondaryBackground,
                DesignSystem.Colors.groupedBackground,
                DesignSystem.Colors.secondaryBackground
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // MARK: - Private Methods

    /// 開始動畫
    private func startAnimation() {
        // 延遲開始動畫以避免閃爍
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isAnimating = true
        }
    }
}

// MARK: - SkeletonStyle

/// 骨架樣式定義
struct SkeletonStyle {
    let width: CGFloat?
    let height: CGFloat
    let cornerRadius: CGFloat

    // 預設樣式
    static let text = SkeletonStyle(
        width: nil,
        height: 20,
        cornerRadius: DesignSystem.CornerRadius.small
    )

    static let title = SkeletonStyle(
        width: nil,
        height: 28,
        cornerRadius: DesignSystem.CornerRadius.small
    )

    static let temperature = SkeletonStyle(
        width: 120,
        height: 48,
        cornerRadius: DesignSystem.CornerRadius.medium
    )

    static let icon = SkeletonStyle(
        width: 60,
        height: 60,
        cornerRadius: DesignSystem.CornerRadius.large
    )

    static let card = SkeletonStyle(
        width: nil,
        height: 200,
        cornerRadius: DesignSystem.CornerRadius.medium
    )

    static let row = SkeletonStyle(
        width: nil,
        height: 60,
        cornerRadius: DesignSystem.CornerRadius.small
    )
}

// MARK: - Weather Skeleton Views

/// 當前天氣骨架視圖
struct CurrentWeatherSkeleton: View {

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            // 天氣圖示骨架
            SkeletonView(style: .icon)

            // 溫度區域骨架
            VStack(spacing: DesignSystem.Spacing.small) {
                SkeletonView(style: .temperature)

                SkeletonView(style: .text)
                    .frame(width: 100)
            }

            // 詳細資訊骨架
            HStack(spacing: DesignSystem.Spacing.xxLarge) {
                VStack(spacing: DesignSystem.Spacing.extraSmall) {
                    SkeletonView(style: .text)
                        .frame(width: 24, height: 24)

                    SkeletonView(style: .text)
                        .frame(width: 30, height: 12)

                    SkeletonView(style: .text)
                        .frame(width: 40, height: 16)
                }

                VStack(spacing: DesignSystem.Spacing.extraSmall) {
                    SkeletonView(style: .text)
                        .frame(width: 24, height: 24)

                    SkeletonView(style: .text)
                        .frame(width: 30, height: 12)

                    SkeletonView(style: .text)
                        .frame(width: 40, height: 16)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, DesignSystem.Spacing.large)
        .padding(.vertical, DesignSystem.Spacing.xxxLarge)
        .cardStyle()
    }
}

/// 每週預報骨架視圖
struct WeeklyForecastSkeleton: View {

    var body: some View {
        VStack(spacing: 0) {
            // 標題骨架
            headerSkeleton

            // 預報列表骨架
            VStack(spacing: 0) {
                ForEach(0..<7, id: \.self) { index in
                    DailyForecastRowSkeleton()

                    if index < 6 {
                        Divider()
                            .padding(.horizontal, DesignSystem.Spacing.large)
                    }
                }
            }
            .padding(.vertical, DesignSystem.Spacing.medium)
        }
        .cardStyle()
    }

    /// 標題骨架
    private var headerSkeleton: some View {
        HStack {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.extraSmall) {
                SkeletonView(style: .title)
                    .frame(width: 80)

                SkeletonView(style: .text)
                    .frame(width: 120, height: 12)
            }

            Spacer()

            SkeletonView(style: .text)
                .frame(width: 24, height: 24)
        }
        .padding(.horizontal, DesignSystem.Spacing.large)
        .padding(.vertical, DesignSystem.Spacing.large)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
        )
    }
}

/// 每日預報行骨架視圖
struct DailyForecastRowSkeleton: View {

    var body: some View {
        HStack(spacing: DesignSystem.Spacing.large) {
            // 日期區域骨架
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.extraSmall) {
                SkeletonView(style: .text)
                    .frame(width: 50, height: 16)

                SkeletonView(style: .text)
                    .frame(width: 40, height: 12)
            }
            .frame(width: 70, alignment: .leading)

            // 天氣圖示骨架
            SkeletonView(style: .text)
                .frame(width: 24, height: 24)
                .frame(width: 40)

            // 天氣描述骨架
            VStack(alignment: .leading, spacing: 2) {
                SkeletonView(style: .text)
                    .frame(width: 80, height: 16)

                SkeletonView(style: .text)
                    .frame(width: 60, height: 12)
            }

            Spacer()

            // 溫度範圍骨架
            VStack(alignment: .trailing, spacing: DesignSystem.Spacing.extraSmall) {
                SkeletonView(style: .text)
                    .frame(width: 30, height: 16)

                SkeletonView(style: .text)
                    .frame(width: 60, height: 4)

                SkeletonView(style: .text)
                    .frame(width: 30, height: 12)
            }
            .frame(width: 70)
        }
        .padding(.horizontal, DesignSystem.Spacing.large)
        .padding(.vertical, DesignSystem.Spacing.medium)
    }
}

// MARK: - Convenience Extensions

extension View {

    /// 套用骨架載入效果
    func skeleton(when isLoading: Bool, style: SkeletonStyle = .text) -> some View {
        ZStack {
            if isLoading {
                SkeletonView(style: style)
            } else {
                self
            }
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: DesignSystem.Spacing.large) {
        CurrentWeatherSkeleton()

        WeeklyForecastSkeleton()
    }
    .background(DesignSystem.Colors.background)
}