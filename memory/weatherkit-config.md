## Apple WeatherKit 專用配置

### WeatherKit 基本資訊
- **官方文檔**：[Apple WeatherKit Documentation](https://developer.apple.com/documentation/weatherkit)
- **需求**：Apple Developer Program 會員資格
- **支援平台**：iOS 16.0+, macOS 13.0+, watchOS 9.0+, tvOS 16.0+
- **API 限制**：每月 500,000 次呼叫 (免費額度)

### 開發環境設定

#### 1. Apple Developer Portal 設定
- **App ID 配置**：
  - 登入 [Apple Developer Portal](https://developer.apple.com)
  - 建立新的 App ID 或修改現有的
  - 啟用 "WeatherKit" capability
  - 下載更新的 Provisioning Profile

#### 2. Xcode 專案設定
```swift
// 在 Xcode 專案中啟用 WeatherKit
// Project Settings → Signing & Capabilities → + → WeatherKit
```

#### 3. 權限配置
```xml
<!-- Info.plist 不需要特別設定，WeatherKit 不需要 usage description -->
<!-- 但如果需要位置資訊，則需要位置權限 -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access to provide accurate weather information.</string>
```

### WeatherKit Swift API 使用指南

#### 基礎服務設定
```swift
import WeatherKit
import CoreLocation

class WeatherService: ObservableObject {
    private let weatherService = WeatherKit.shared

    // 取得當前天氣
    func getCurrentWeather(for location: CLLocation) async throws -> CurrentWeather {
        let weather = try await weatherService.weather(for: location)
        return weather.currentWeather
    }

    // 取得每小時預報 (48 小時)
    func getHourlyForecast(for location: CLLocation) async throws -> Forecast<HourWeather> {
        let weather = try await weatherService.weather(
            for: location,
            including: .hourly
        )
        return weather
    }

    // 取得每日預報 (10 天)
    func getDailyForecast(for location: CLLocation) async throws -> Forecast<DayWeather> {
        let weather = try await weatherService.weather(
            for: location,
            including: .daily
        )
        return weather
    }
}
```

#### 資料模型結構
```swift
// 當前天氣資料模型
struct WeatherData {
    let temperature: Measurement<UnitTemperature>
    let condition: WeatherCondition
    let symbolName: String
    let description: String
    let humidity: Double
    let pressure: Measurement<UnitPressure>
    let windSpeed: Measurement<UnitSpeed>
    let windDirection: Measurement<UnitAngle>
    let uvIndex: Int
    let visibility: Measurement<UnitLength>

    init(from currentWeather: CurrentWeather) {
        self.temperature = currentWeather.temperature
        self.condition = currentWeather.condition
        self.symbolName = currentWeather.symbolName
        self.description = currentWeather.condition.description
        self.humidity = currentWeather.humidity
        self.pressure = currentWeather.pressure
        self.windSpeed = currentWeather.wind.speed
        self.windDirection = currentWeather.wind.direction ?? Measurement(value: 0, unit: .degrees)
        self.uvIndex = currentWeather.uvIndex.value
        self.visibility = currentWeather.visibility
    }
}

// 每日預報資料模型
struct DailyWeatherData {
    let date: Date
    let condition: WeatherCondition
    let symbolName: String
    let highTemperature: Measurement<UnitTemperature>
    let lowTemperature: Measurement<UnitTemperature>
    let precipitationChance: Double

    init(from dayWeather: DayWeather) {
        self.date = dayWeather.date
        self.condition = dayWeather.condition
        self.symbolName = dayWeather.symbolName
        self.highTemperature = dayWeather.highTemperature
        self.lowTemperature = dayWeather.lowTemperature
        self.precipitationChance = dayWeather.precipitationChance
    }
}
```

### 錯誤處理策略
```swift
enum WeatherError: Error, LocalizedError {
    case locationNotFound
    case networkError
    case apiLimitExceeded
    case invalidResponse
    case locationPermissionDenied

    var errorDescription: String? {
        switch self {
        case .locationNotFound:
            return "無法取得位置資訊"
        case .networkError:
            return "網路連線發生問題"
        case .apiLimitExceeded:
            return "API 呼叫次數已達上限"
        case .invalidResponse:
            return "天氣資料格式錯誤"
        case .locationPermissionDenied:
            return "需要位置權限才能取得天氣資訊"
        }
    }
}

// 錯誤處理實作
extension WeatherService {
    func handleWeatherError(_ error: Error) -> WeatherError {
        if error is CLError {
            return .locationPermissionDenied
        } else if error is URLError {
            return .networkError
        } else {
            return .invalidResponse
        }
    }
}
```

### 位置服務整合
```swift
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()

    @Published var currentLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
    }

    func requestLocation() {
        locationManager.requestLocation()
    }

    // MARK: - CLLocationManagerDelegate
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            requestLocation()
        case .denied, .restricted:
            // 處理權限被拒絕的情況
            break
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("位置取得失敗: \(error.localizedDescription)")
    }
}
```

### 快取策略
```swift
class WeatherCache {
    private let cache = NSCache<NSString, WeatherData>()
    private let cacheTimeout: TimeInterval = 300 // 5 分鐘

    func setWeather(_ weather: WeatherData, for location: CLLocation) {
        let key = cacheKey(for: location)
        cache.setObject(weather, forKey: key)
    }

    func getWeather(for location: CLLocation) -> WeatherData? {
        let key = cacheKey(for: location)
        return cache.object(forKey: key)
    }

    private func cacheKey(for location: CLLocation) -> NSString {
        return "\(location.coordinate.latitude),\(location.coordinate.longitude)" as NSString
    }
}
```

### 測試策略
```swift
// Mock WeatherService for testing
class MockWeatherService: WeatherService {
    var mockCurrentWeather: CurrentWeather?
    var shouldReturnError = false

    override func getCurrentWeather(for location: CLLocation) async throws -> CurrentWeather {
        if shouldReturnError {
            throw WeatherError.networkError
        }

        return mockCurrentWeather ?? createMockWeather()
    }

    private func createMockWeather() -> CurrentWeather {
        // 建立測試用的天氣資料
        // 注意：CurrentWeather 是 WeatherKit 的類別，無法直接初始化
        // 在實際測試中，需要使用真實的 API 回應或建立 protocol
    }
}
```

### API 使用限制和最佳實踐

#### 呼叫限制
- **免費額度**：每月 500,000 次 API 呼叫
- **付費方案**：超過免費額度後按次收費
- **建議策略**：
  - 實作智慧快取機制
  - 避免頻繁刷新（建議間隔 ≥ 5 分鐘）
  - 批次處理多個位置的請求

#### 效能最佳化
```swift
class OptimizedWeatherService: WeatherService {
    private var lastFetchTime: Date?
    private let minimumFetchInterval: TimeInterval = 300 // 5 分鐘

    override func getCurrentWeather(for location: CLLocation) async throws -> CurrentWeather {
        // 檢查是否需要重新獲取資料
        if let lastFetch = lastFetchTime,
           Date().timeIntervalSince(lastFetch) < minimumFetchInterval {
            // 返回快取資料
            return getCachedWeather(for: location)
        }

        let weather = try await super.getCurrentWeather(for: location)
        lastFetchTime = Date()
        cacheWeather(weather, for: location)

        return weather
    }
}
```

### 除錯和監控
```swift
extension WeatherService {
    private func logAPICall(_ request: String, location: CLLocation) {
        #if DEBUG
        print("WeatherKit API 呼叫: \(request) for \(location.coordinate)")
        #endif
    }

    private func logAPIResponse(_ response: Any) {
        #if DEBUG
        print("WeatherKit API 回應: \(response)")
        #endif
    }
}
```

### 隱私和合規
- **資料使用**：WeatherKit 資料僅供 App 內使用，不得轉售或重新分發
- **位置隱私**：遵循 Apple 位置隱私指南
- **快取限制**：天氣資料快取不應超過合理時間
- **使用條款**：遵循 Apple Developer Program License Agreement

### 故障排除

#### 常見問題
1. **"WeatherKit not available"**：
   - 檢查 App ID 是否啟用 WeatherKit capability
   - 確認 Provisioning Profile 已更新

2. **API 呼叫失敗**：
   - 檢查網路連線
   - 確認 API 呼叫限制
   - 驗證位置資料有效性

3. **權限問題**：
   - 確認位置權限設定
   - 檢查 Info.plist 配置

#### 除錯工具
```swift
// 在開發階段使用的除錯工具
#if DEBUG
extension WeatherService {
    func debugAPIUsage() {
        // 記錄 API 使用狀況
        // 監控快取命中率
        // 追蹤錯誤頻率
    }
}
#endif
```