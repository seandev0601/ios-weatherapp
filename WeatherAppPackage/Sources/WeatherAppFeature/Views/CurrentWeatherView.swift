import SwiftUI

/// CurrentWeatherView 顯示當前天氣資訊
/// 包含溫度、天氣狀況和載入狀態
struct CurrentWeatherView<ViewModel: ObservableObject>: View {
    
    // MARK: - Properties
    @ObservedObject var viewModel: ViewModel
    
    // MARK: - Initializer
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 24) {
            // 根據 ViewModel 狀態顯示內容
            if isLoading {
                // 載入狀態 - 使用骨架畫面
                CurrentWeatherSkeleton()
            } else if let weather = currentWeather {
                // 顯示天氣資訊
                weatherContentView(weather: weather)
            } else if let errorMessage = errorMessage {
                // 錯誤狀態
                ErrorView(errorMessage: errorMessage) {
                    await retryWeatherFetch()
                }
            } else {
                // 無資料狀態
                emptyStateView
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, DesignSystem.Spacing.large)
        .padding(.vertical, DesignSystem.Spacing.xxxLarge)
        .cardStyle()
        .animation(DesignSystem.Animation.standard, value: isLoading)
        .animation(DesignSystem.Animation.standard, value: currentWeather?.temperature)
        .animation(DesignSystem.Animation.standard, value: errorMessage)
    }
    
    // MARK: - Private Computed Properties
    
    /// 取得當前天氣資料 (透過 Key Path 存取)
    private var currentWeather: WeatherData? {
        (viewModel as? any CurrentWeatherViewModelProtocol)?.currentWeather
    }
    
    /// 取得載入狀態 (透過 Key Path 存取)
    private var isLoading: Bool {
        (viewModel as? any CurrentWeatherViewModelProtocol)?.isLoading ?? false
    }

    /// 取得錯誤訊息 (透過 Key Path 存取)
    private var errorMessage: String? {
        (viewModel as? any CurrentWeatherViewModelProtocol)?.errorMessage
    }

    // MARK: - Private Methods

    /// 重試天氣資料獲取
    private func retryWeatherFetch() async {
        if let weatherViewModel = viewModel as? WeatherViewModel {
            await weatherViewModel.refreshWeather()
        }
    }

    // MARK: - View Components

    /// 載入狀態視圖
    private var loadingView: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(DesignSystem.Colors.primary)

            Text("載入天氣資料中...")
                .font(DesignSystem.Typography.bodyMedium)
                .foregroundColor(DesignSystem.Colors.secondaryText)
        }
        .frame(minHeight: 120)
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
        .accessibilityLabel("Loading weather data")
    }

    /// 天氣內容視圖
    private func weatherContentView(weather: WeatherData) -> some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            // 天氣圖示
            Image(systemName: weather.weatherIconName)
                .font(.system(size: 60))
                .foregroundStyle(DesignSystem.Colors.primary, DesignSystem.Colors.secondary)
                .symbolRenderingMode(.hierarchical)

            // 溫度資訊
            VStack(spacing: DesignSystem.Spacing.small) {
                Text(weather.temperatureDisplay)
                    .font(DesignSystem.Typography.displayLarge)
                    .foregroundColor(DesignSystem.Colors.primaryText)
                    .temperatureColor(for: weather.temperature)

                Text(weather.description)
                    .font(DesignSystem.Typography.headlineSmall)
                    .fontWeight(.medium)
                    .foregroundColor(DesignSystem.Colors.secondaryText)
            }

            // 額外資訊
            HStack(spacing: DesignSystem.Spacing.xxLarge) {
                WeatherDetailItem(
                    icon: "humidity",
                    label: "濕度",
                    value: weather.humidityDisplay
                )

                WeatherDetailItem(
                    icon: "wind",
                    label: "風速",
                    value: weather.windSpeedDisplay
                )
            }
        }
        .standardTransition()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Weather: \(weather.description), Temperature: \(weather.temperatureDisplay)")
    }

    /// 錯誤狀態視圖
    private func errorView(message: String) -> some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(DesignSystem.Colors.warning)

            Text("發生錯誤")
                .font(DesignSystem.Typography.headlineMedium)
                .fontWeight(.semibold)
                .foregroundColor(DesignSystem.Colors.primaryText)

            Text(message)
                .font(DesignSystem.Typography.bodyMedium)
                .foregroundColor(DesignSystem.Colors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(minHeight: 120)
        .transition(.move(edge: .top).combined(with: .opacity))
        .accessibilityLabel("Error: \(message)")
    }

    /// 空白狀態視圖
    private var emptyStateView: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            Image(systemName: "cloud.fill")
                .font(.system(size: 40))
                .foregroundColor(DesignSystem.Colors.cloudy)

            Text("尚無天氣資料")
                .font(DesignSystem.Typography.headlineMedium)
                .fontWeight(.medium)
                .foregroundColor(DesignSystem.Colors.secondaryText)

            Text("請重新整理以取得最新天氣資訊")
                .font(DesignSystem.Typography.bodyMedium)
                .foregroundColor(DesignSystem.Colors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(minHeight: 120)
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
        .accessibilityLabel("No weather data available")
    }
}

// MARK: - Supporting Views

/// 天氣詳細資訊項目元件
private struct WeatherDetailItem: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.extraSmall) {
            Image(systemName: icon)
                .font(DesignSystem.Typography.headlineMedium)
                .foregroundColor(DesignSystem.Colors.primary)

            Text(label)
                .font(DesignSystem.Typography.labelMedium)
                .foregroundColor(DesignSystem.Colors.secondaryText)

            Text(value)
                .font(DesignSystem.Typography.labelLarge)
                .fontWeight(.medium)
                .foregroundColor(DesignSystem.Colors.primaryText)
        }
        .frame(minWidth: 60)
    }
}

// MARK: - Protocol for ViewModel
/// CurrentWeatherView 要求的 ViewModel 協議
@MainActor
protocol CurrentWeatherViewModelProtocol {
    var currentWeather: WeatherData? { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
}

// MARK: - Preview
#Preview {
    // Preview 用的 Mock ViewModel
    @MainActor
    final class MockViewModel: ObservableObject, CurrentWeatherViewModelProtocol {
        @Published var currentWeather: WeatherData? = WeatherData(
            temperature: 25.0,
            condition: "sunny",
            humidity: 0.6,
            windSpeed: 15.0,
            description: "Clear and sunny"
        )

        @Published var isLoading: Bool = false
        @Published var errorMessage: String? = nil
    }
    
    return CurrentWeatherView(viewModel: MockViewModel())
}