import SwiftUI

/// 友善的錯誤顯示組件
/// 提供錯誤資訊展示和重試功能
struct ErrorView: View {

    // MARK: - Properties
    let error: WeatherServiceError
    let onRetry: () async -> Void

    // MARK: - State
    @State private var isRetrying = false

    // MARK: - Body
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            // 錯誤圖示
            errorIcon

            // 錯誤標題
            Text(errorTitle)
                .font(DesignSystem.Typography.headlineMedium)
                .fontWeight(.semibold)
                .foregroundColor(DesignSystem.Colors.primaryText)
                .multilineTextAlignment(.center)

            // 錯誤描述
            Text(errorDescription)
                .font(DesignSystem.Typography.bodyMedium)
                .foregroundColor(DesignSystem.Colors.secondaryText)
                .multilineTextAlignment(.center)
                .lineLimit(nil)

            // 建議和重試按鈕
            VStack(spacing: DesignSystem.Spacing.medium) {
                if !errorSuggestion.isEmpty {
                    Text(errorSuggestion)
                        .font(DesignSystem.Typography.bodySmall)
                        .foregroundColor(DesignSystem.Colors.tertiaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, DesignSystem.Spacing.large)
                }

                retryButton
            }
        }
        .padding(DesignSystem.Spacing.large)
        .cardStyle()
        .animation(DesignSystem.Animation.standard, value: isRetrying)
    }

    // MARK: - Private Views

    /// 錯誤圖示
    private var errorIcon: some View {
        ZStack {
            Circle()
                .fill(errorColor.opacity(0.1))
                .frame(width: 80, height: 80)

            Image(systemName: errorIconName)
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(errorColor)
        }
        .scaleEffect(isRetrying ? 0.95 : 1.0)
        .animation(DesignSystem.Animation.bounce, value: isRetrying)
    }

    /// 重試按鈕
    private var retryButton: some View {
        Button {
            Task {
                await performRetry()
            }
        } label: {
            HStack(spacing: DesignSystem.Spacing.small) {
                if isRetrying {
                    ProgressView()
                        .scaleEffect(0.8)
                        .tint(DesignSystem.Colors.inverseText)
                } else {
                    Image(systemName: "arrow.clockwise")
                }

                Text(isRetrying ? "重試中..." : "重試")
            }
            .font(DesignSystem.Typography.labelLarge)
            .fontWeight(.medium)
        }
        .primaryButtonStyle()
        .disabled(isRetrying)
        .opacity(isRetrying ? 0.7 : 1.0)
        .accessibilityLabel(isRetrying ? "正在重試載入天氣資料" : "重試載入天氣資料")
    }

    // MARK: - Computed Properties

    /// 錯誤標題
    private var errorTitle: String {
        switch error {
        case .networkError:
            return "網路連線問題"
        case .invalidLocation:
            return "位置資訊無效"
        case .apiError:
            return "服務暫時不可用"
        case .invalidData:
            return "資料格式錯誤"
        case .weatherKitNotAvailable:
            return "天氣服務不可用"
        }
    }

    /// 錯誤描述
    private var errorDescription: String {
        switch error {
        case .networkError:
            return "無法連接到網路，請檢查您的網路連線狀態"
        case .invalidLocation:
            return "無法取得有效的位置資訊，請確認位置權限設定"
        case .apiError(let message):
            return "天氣服務發生錯誤：\(message)"
        case .invalidData:
            return "接收到的天氣資料格式不正確，請稍後再試"
        case .weatherKitNotAvailable:
            return "Apple WeatherKit 服務目前不可用，請稍後再試"
        }
    }

    /// 錯誤建議
    private var errorSuggestion: String {
        switch error {
        case .networkError:
            return "建議檢查 Wi-Fi 或行動數據連線"
        case .invalidLocation:
            return "請前往設定 > 隱私權與安全性 > 定位服務"
        case .apiError:
            return "服務可能正在維護中"
        case .invalidData:
            return "這通常是暫時性問題"
        case .weatherKitNotAvailable:
            return "WeatherKit 需要 iOS 16 或更新版本"
        }
    }

    /// 錯誤圖示名稱
    private var errorIconName: String {
        switch error {
        case .networkError:
            return "wifi.slash"
        case .invalidLocation:
            return "location.slash"
        case .apiError:
            return "server.rack"
        case .invalidData:
            return "exclamationmark.triangle"
        case .weatherKitNotAvailable:
            return "cloud.slash"
        }
    }

    /// 錯誤顏色
    private var errorColor: Color {
        switch error {
        case .networkError:
            return DesignSystem.Colors.warning
        case .invalidLocation:
            return DesignSystem.Colors.info
        case .apiError:
            return DesignSystem.Colors.error
        case .invalidData:
            return DesignSystem.Colors.warning
        case .weatherKitNotAvailable:
            return DesignSystem.Colors.error
        }
    }

    // MARK: - Private Methods

    /// 執行重試操作
    private func performRetry() async {
        isRetrying = true

        // 添加小延遲以改善用戶體驗
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 秒

        await onRetry()

        isRetrying = false
    }
}

// MARK: - ErrorView Extensions

extension ErrorView {

    /// 便利初始化方法，接受字串錯誤訊息
    init(errorMessage: String, onRetry: @escaping () async -> Void) {
        // 嘗試解析常見的錯誤類型
        let serviceError: WeatherServiceError

        if errorMessage.contains("網路") || errorMessage.contains("network") {
            serviceError = .networkError
        } else if errorMessage.contains("位置") || errorMessage.contains("location") {
            serviceError = .invalidLocation
        } else if errorMessage.contains("API") || errorMessage.contains("api") {
            serviceError = .apiError(errorMessage)
        } else if errorMessage.contains("資料") || errorMessage.contains("data") {
            serviceError = .invalidData
        } else if errorMessage.contains("WeatherKit") {
            serviceError = .weatherKitNotAvailable
        } else {
            serviceError = .apiError(errorMessage)
        }

        self.init(error: serviceError, onRetry: onRetry)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: DesignSystem.Spacing.large) {
        ErrorView(error: .networkError) {
            // 模擬重試延遲
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            print("重試網路錯誤")
        }

        ErrorView(error: .invalidLocation) {
            print("重試位置錯誤")
        }

        ErrorView(error: .apiError("服務器維護中")) {
            print("重試 API 錯誤")
        }
    }
    .background(DesignSystem.Colors.secondaryBackground)
}