import SwiftUI
import Foundation

/// WeeklyForecastView 顯示每週天氣預報
/// 包含 7 天的天氣預報清單
struct WeeklyForecastView<ViewModel: ObservableObject>: View {

    // MARK: - Properties
    @ObservedObject var viewModel: ViewModel

    // MARK: - Initializer
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // 標題
            headerView

            if isLoading {
                // 載入狀態 - 使用骨架內容
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
            } else if let errorMessage = errorMessage {
                // 錯誤狀態
                ErrorView(errorMessage: errorMessage) {
                    await retryForecastFetch()
                }
            } else if !weeklyForecast.isEmpty {
                // 顯示預報清單
                forecastListView
            } else {
                // 空白狀態
                emptyStateView
            }
        }
        .cardStyle()
        .animation(DesignSystem.Animation.standard, value: isLoading)
        .animation(DesignSystem.Animation.standard, value: weeklyForecast.count)
        .animation(DesignSystem.Animation.standard, value: errorMessage)
    }

    // MARK: - Private Computed Properties

    /// 取得每週預報資料 (透過 Key Path 存取)
    private var weeklyForecast: [DailyWeatherData] {
        (viewModel as? any WeeklyForecastViewModelProtocol)?.weeklyForecast ?? []
    }

    /// 取得載入狀態 (透過 Key Path 存取)
    private var isLoading: Bool {
        (viewModel as? any WeeklyForecastViewModelProtocol)?.isLoading ?? false
    }

    /// 取得錯誤訊息 (透過 Key Path 存取)
    private var errorMessage: String? {
        (viewModel as? any WeeklyForecastViewModelProtocol)?.errorMessage
    }

    // MARK: - Private Methods

    /// 重試預報資料獲取
    private func retryForecastFetch() async {
        if viewModel is WeeklyForecastViewModel {
            // TODO: 實作重試邏輯，需要位置資訊
            print("重試預報資料獲取")
        }
    }

    // MARK: - View Components

    /// 標題視圖
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.extraSmall) {
                Text("7 天預報")
                    .font(DesignSystem.Typography.headlineMedium)
                    .fontWeight(.bold)
                    .foregroundColor(DesignSystem.Colors.primaryText)

                Text("未來一週天氣趨勢")
                    .font(DesignSystem.Typography.labelMedium)
                    .foregroundColor(DesignSystem.Colors.secondaryText)
            }

            Spacer()

            Image(systemName: "calendar")
                .font(DesignSystem.Typography.headlineMedium)
                .foregroundColor(DesignSystem.Colors.primary)
        }
        .padding(.horizontal, DesignSystem.Spacing.large)
        .padding(.vertical, DesignSystem.Spacing.large)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
        )
    }

    /// 載入狀態視圖
    private var loadingView: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(DesignSystem.Colors.primary)

            Text("載入 7 天預報中...")
                .font(DesignSystem.Typography.bodyMedium)
                .foregroundColor(DesignSystem.Colors.secondaryText)
        }
        .frame(minHeight: 200)
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
        .accessibilityLabel("Loading weekly forecast data")
    }

    /// 預報清單視圖
    private var forecastListView: some View {
        LazyVStack(spacing: 0) {
            ForEach(weeklyForecast, id: \.date) { dailyData in
                DailyWeatherRow(dailyData: dailyData)
                    .standardTransition()

                if dailyData.date != weeklyForecast.last?.date {
                    Divider()
                        .padding(.horizontal, DesignSystem.Spacing.large)
                }
            }
        }
        .padding(.vertical, DesignSystem.Spacing.medium)
    }

    /// 錯誤狀態視圖
    private func errorView(message: String) -> some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(DesignSystem.Colors.warning)

            Text("無法載入預報")
                .font(DesignSystem.Typography.headlineMedium)
                .fontWeight(.semibold)
                .foregroundColor(DesignSystem.Colors.primaryText)

            Text(message)
                .font(DesignSystem.Typography.bodyMedium)
                .foregroundColor(DesignSystem.Colors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(minHeight: 200)
        .padding(.horizontal, DesignSystem.Spacing.large)
        .transition(.move(edge: .top).combined(with: .opacity))
        .accessibilityLabel("Error loading forecast: \(message)")
    }

    /// 空白狀態視圖
    private var emptyStateView: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 40))
                .foregroundColor(DesignSystem.Colors.cloudy)

            Text("尚無預報資料")
                .font(DesignSystem.Typography.headlineMedium)
                .fontWeight(.medium)
                .foregroundColor(DesignSystem.Colors.secondaryText)

            Text("請重新整理以取得 7 天天氣預報")
                .font(DesignSystem.Typography.bodyMedium)
                .foregroundColor(DesignSystem.Colors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(minHeight: 200)
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
        .accessibilityLabel("No weekly forecast data available")
    }
}

// MARK: - DailyWeatherRow Component
struct DailyWeatherRow: View {
    let dailyData: DailyWeatherData

    var body: some View {
        HStack(spacing: DesignSystem.Spacing.large) {
            // 日期區域
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.extraSmall) {
                Text(dailyData.dayName)
                    .font(DesignSystem.Typography.bodyMedium)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.primaryText)

                Text(dateFormatter.string(from: dailyData.date))
                    .font(DesignSystem.Typography.labelMedium)
                    .foregroundColor(DesignSystem.Colors.secondaryText)
            }
            .frame(width: 70, alignment: .leading)

            // 天氣圖示
            Image(systemName: dailyData.weatherIconName)
                .font(DesignSystem.Typography.headlineMedium)
                .foregroundStyle(DesignSystem.Colors.primary, DesignSystem.Colors.secondary)
                .symbolRenderingMode(.hierarchical)
                .frame(width: 40)

            // 天氣描述
            VStack(alignment: .leading, spacing: 2) {
                Text(dailyData.description)
                    .font(DesignSystem.Typography.bodyMedium)
                    .fontWeight(.medium)
                    .foregroundColor(DesignSystem.Colors.primaryText)

                Text(dailyData.condition.capitalized)
                    .font(DesignSystem.Typography.labelMedium)
                    .foregroundColor(DesignSystem.Colors.secondaryText)
            }

            Spacer()

            // 溫度範圍條
            temperatureRangeView
        }
        .padding(.horizontal, DesignSystem.Spacing.large)
        .padding(.vertical, DesignSystem.Spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.small)
                .fill(.clear)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(dailyData.dayName), \(dailyData.description), temperature \(dailyData.temperatureRange)")
    }

    /// 溫度範圍視圖
    private var temperatureRangeView: some View {
        VStack(alignment: .trailing, spacing: DesignSystem.Spacing.extraSmall) {
            // 高溫
            Text("\(Int(dailyData.highTemperature))°")
                .font(DesignSystem.Typography.bodyMedium)
                .fontWeight(.semibold)
                .foregroundColor(DesignSystem.Colors.primaryText)
                .temperatureColor(for: dailyData.highTemperature)

            // 溫度範圍條
            ZStack {
                // 背景條
                RoundedRectangle(cornerRadius: 2)
                    .fill(DesignSystem.Colors.border)
                    .frame(width: 60, height: 4)

                // 溫度範圍條
                HStack {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(temperatureGradient)
                        .frame(width: temperatureBarWidth, height: 4)

                    Spacer()
                }
                .frame(width: 60)
            }

            // 低溫
            Text("\(Int(dailyData.lowTemperature))°")
                .font(DesignSystem.Typography.labelMedium)
                .fontWeight(.medium)
                .foregroundColor(DesignSystem.Colors.secondaryText)
                .temperatureColor(for: dailyData.lowTemperature)
        }
        .frame(width: 70)
    }

    /// 溫度條寬度計算
    private var temperatureBarWidth: CGFloat {
        let tempRange = dailyData.highTemperature - dailyData.lowTemperature
        let normalizedRange = min(max(tempRange / 20.0, 0.3), 1.0) // 正規化到 0.3-1.0
        return 60 * normalizedRange
    }

    /// 溫度梯度顏色
    private var temperatureGradient: LinearGradient {
        let avgTemp = (dailyData.highTemperature + dailyData.lowTemperature) / 2

        let colors: [Color] = {
            switch avgTemp {
            case ..<0:
                return [.blue, .cyan]
            case 0..<15:
                return [.cyan, .green]
            case 15..<25:
                return [.green, .yellow]
            case 25..<35:
                return [.yellow, .orange]
            default:
                return [.orange, .red]
            }
        }()

        return LinearGradient(
            colors: colors,
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter
    }
}

// MARK: - DailyWeatherData Model
struct DailyWeatherData {
    let date: Date
    let condition: String
    let highTemperature: Double
    let lowTemperature: Double
    let description: String

    var weatherIconName: String {
        switch condition.lowercased() {
        case "sunny", "clear":
            return "sun.max.fill"
        case "cloudy", "overcast":
            return "cloud.fill"
        case "rainy", "rain":
            return "cloud.rain.fill"
        default:
            return "questionmark.circle.fill"
        }
    }

    var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }

    var temperatureRange: String {
        return "\(Int(lowTemperature))° - \(Int(highTemperature))°"
    }
}

// MARK: - Protocol for ViewModel
/// WeeklyForecastView 要求的 ViewModel 協議
@MainActor
protocol WeeklyForecastViewModelProtocol {
    var weeklyForecast: [DailyWeatherData] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
}

// MARK: - Preview
#Preview {
    // Preview 用的 Mock ViewModel
    @MainActor
    final class MockViewModel: ObservableObject, WeeklyForecastViewModelProtocol {
        @Published var weeklyForecast: [DailyWeatherData] = {
            let calendar = Calendar.current
            let today = Date()

            return (0..<7).map { dayOffset in
                let date = calendar.date(byAdding: .day, value: dayOffset, to: today) ?? today
                return DailyWeatherData(
                    date: date,
                    condition: "sunny",
                    highTemperature: 25.0,
                    lowTemperature: 15.0,
                    description: "Clear and sunny"
                )
            }
        }()

        @Published var isLoading: Bool = false
        @Published var errorMessage: String? = nil
    }

    return WeeklyForecastView(viewModel: MockViewModel())
}