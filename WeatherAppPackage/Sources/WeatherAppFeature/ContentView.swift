import SwiftUI
import CoreLocation

/// WeatherApp 主介面
/// 整合當前天氣和每週預報功能
public struct ContentView: View {

    // MARK: - State Objects
    @StateObject private var weatherViewModel: WeatherViewModel
    @StateObject private var weeklyForecastViewModel: WeeklyForecastViewModel
    @StateObject private var locationManager = LocationManager()

    // MARK: - State
    @State private var selectedTab: WeatherTab = .current

    // MARK: - Initializer
    public init() {
        let weatherService = WeatherService()
        self._weatherViewModel = StateObject(wrappedValue: WeatherViewModel(weatherService: weatherService))
        self._weeklyForecastViewModel = StateObject(wrappedValue: WeeklyForecastViewModel(weatherService: weatherService))
    }

    // MARK: - Body
    public var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                // 當前天氣頁面
                currentWeatherTab
                    .tabItem {
                        Image(systemName: "sun.max.fill")
                        Text("現在")
                    }
                    .tag(WeatherTab.current)

                // 每週預報頁面
                weeklyForecastTab
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("7天預報")
                    }
                    .tag(WeatherTab.weekly)
            }
            .navigationTitle(navigationTitle)
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    refreshButton
                }
            }
            .background(DesignSystem.Colors.background)
        }
        .onAppear {
            requestLocationAndFetchWeather()
        }
        .onChange(of: locationManager.currentLocation) { _, location in
            if let location = location {
                fetchWeatherData(for: location)
            }
        }
    }

    // MARK: - Tab Views

    /// 當前天氣標籤頁
    private var currentWeatherTab: some View {
        ScrollView {
            LazyVStack(spacing: DesignSystem.Spacing.large) {
                CurrentWeatherView(viewModel: weatherViewModel)

                if !weeklyForecastViewModel.weeklyForecast.isEmpty {
                    WeeklyForecastView(viewModel: weeklyForecastViewModel)
                }
            }
            .padding(.top, DesignSystem.Spacing.large)
        }
        .refreshable {
            await refreshWeatherData()
        }
        .background(DesignSystem.Colors.background)
    }

    /// 每週預報標籤頁
    private var weeklyForecastTab: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.large) {
                WeeklyForecastView(viewModel: weeklyForecastViewModel)
            }
            .padding(.top, DesignSystem.Spacing.large)
        }
        .refreshable {
            await refreshWeatherData()
        }
        .background(DesignSystem.Colors.background)
    }

    // MARK: - UI Components

    /// 導航標題
    private var navigationTitle: String {
        switch selectedTab {
        case .current:
            return "天氣"
        case .weekly:
            return "每週預報"
        }
    }

    /// 刷新按鈕
    private var refreshButton: some View {
        Button {
            Task {
                await refreshWeatherData()
            }
        } label: {
            Image(systemName: "arrow.clockwise")
                .foregroundColor(DesignSystem.Colors.primary)
        }
        .accessibilityLabel("重新整理天氣資料")
    }

    // MARK: - Methods

    /// 請求位置並獲取天氣資料
    private func requestLocationAndFetchWeather() {
        locationManager.requestLocation()
    }

    /// 獲取天氣資料
    private func fetchWeatherData(for location: CLLocation) {
        Task {
            // 同時獲取當前天氣和每週預報
            async let currentWeather: () = weatherViewModel.fetchWeather(for: location)
            async let weeklyForecast: () = weeklyForecastViewModel.fetchWeeklyForecast(for: location)

            _ = await currentWeather
            _ = await weeklyForecast
        }
    }

    /// 刷新天氣資料
    @MainActor
    private func refreshWeatherData() async {
        guard let location = locationManager.currentLocation else {
            // 如果沒有位置，重新請求
            locationManager.requestLocation()
            return
        }

        fetchWeatherData(for: location)
    }
}

// MARK: - WeatherTab Enum
enum WeatherTab: String, CaseIterable {
    case current = "current"
    case weekly = "weekly"
}

// MARK: - WeeklyForecastViewModel
@MainActor
final class WeeklyForecastViewModel: ObservableObject, WeeklyForecastViewModelProtocol {
    @Published var weeklyForecast: [DailyWeatherData] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let weatherService: WeatherServiceProtocol

    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }

    func fetchWeeklyForecast(for location: CLLocation) async {
        isLoading = true
        errorMessage = nil

        // 模擬每週預報資料
        let forecastData = generateMockWeeklyForecast()
        await MainActor.run {
            self.weeklyForecast = forecastData
            self.isLoading = false
        }
    }

    private func generateMockWeeklyForecast() -> [DailyWeatherData] {
        let calendar = Calendar.current
        let today = Date()

        return (0..<7).map { dayOffset in
            let date = calendar.date(byAdding: .day, value: dayOffset, to: today) ?? today
            let conditions = ["sunny", "cloudy", "rainy", "sunny", "cloudy", "sunny", "rainy"]
            let highs = [28.0, 26.0, 22.0, 30.0, 25.0, 27.0, 24.0]
            let lows = [18.0, 16.0, 12.0, 20.0, 15.0, 17.0, 14.0]
            let descriptions = ["晴朗", "多雲", "小雨", "晴天", "部分多雲", "晴朗", "陣雨"]

            return DailyWeatherData(
                date: date,
                condition: conditions[dayOffset],
                highTemperature: highs[dayOffset],
                lowTemperature: lows[dayOffset],
                description: descriptions[dayOffset]
            )
        }
    }
}

// MARK: - LocationManager
@MainActor
final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var currentLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }

    func requestLocation() {
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            // 使用默認位置（台北）
            currentLocation = CLLocation(latitude: 25.0330, longitude: 121.5654)
        @unknown default:
            break
        }
    }

    // MARK: - CLLocationManagerDelegate

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        Task { @MainActor in
            authorizationStatus = status

            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.requestLocation()
            case .denied, .restricted:
                // 使用默認位置
                currentLocation = CLLocation(latitude: 25.0330, longitude: 121.5654)
            default:
                break
            }
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task { @MainActor in
            currentLocation = locations.first
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            // 使用默認位置
            currentLocation = CLLocation(latitude: 25.0330, longitude: 121.5654)
        }
    }
}
