import Foundation
import CoreLocation
#if canImport(WeatherKit)
import WeatherKit
#endif

// MARK: - WeatherServiceError
enum WeatherServiceError: Error, LocalizedError {
    case networkError
    case invalidLocation
    case apiError(String)
    case invalidData
    case weatherKitNotAvailable
    
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "網路連線發生問題"
        case .invalidLocation:
            return "無效的位置資訊"
        case .apiError(let message):
            return "API 錯誤: \(message)"
        case .invalidData:
            return "無效的天氣資料"
        case .weatherKitNotAvailable:
            return "WeatherKit 服務不可用"
        }
    }
}

// MARK: - WeatherServiceProtocol
// MARK: - WeatherServiceProtocol
protocol WeatherServiceProtocol: Sendable {
    func fetchCurrentWeather(for location: CLLocation) async throws -> WeatherData
}

// MARK: - WeatherService (Concrete Implementation)
// MARK: - WeatherService (Concrete Implementation)
final class WeatherService: WeatherServiceProtocol {
    
    // MARK: - Properties
    private let useRealAPI: Bool
    
    // MARK: - Initializer
    init(useRealAPI: Bool = false) {
        self.useRealAPI = useRealAPI
    }
    
    // MARK: - Public Methods
    func fetchCurrentWeather(for location: CLLocation) async throws -> WeatherData {
        // 驗證位置有效性
        try validateLocation(location)
        
        if useRealAPI {
            return try await fetchFromWeatherKit(location: location)
        } else {
            return try await fetchMockData(for: location)
        }
    }
    
    // MARK: - Private Methods
    private func validateLocation(_ location: CLLocation) throws {
        // 檢查座標範圍
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        if latitude < -90 || latitude > 90 || longitude < -180 || longitude > 180 {
            throw WeatherServiceError.invalidLocation
        }
        
        // 檢查極端值（模擬無效位置）
        if latitude == 999 || longitude == 999 || latitude > 90 || longitude > 180 {
            throw WeatherServiceError.invalidLocation
        }
    }
    
    private func fetchMockData(for location: CLLocation) async throws -> WeatherData {
        // 模擬網路延遲
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 秒
        
        // 回傳 Mock 資料
        return WeatherData(
            temperature: 22.5,
            condition: "sunny",
            humidity: 0.6,
            windSpeed: 12.0,
            description: "Clear and sunny"
        )
    }
    
    private func fetchFromWeatherKit(location: CLLocation) async throws -> WeatherData {
        // 目前先使用 Mock 資料，未來可以整合真實的 WeatherKit API
        // WeatherKit 需要在真實裝置上運行且需要適當的權限設定
        #if canImport(WeatherKit) && !targetEnvironment(simulator)
        do {
            // 實際的 WeatherKit 整合會在真實專案中完成
            throw WeatherServiceError.weatherKitNotAvailable
        } catch {
            throw WeatherServiceError.apiError(error.localizedDescription)
        }
        #else
        // 在開發環境中回傳 Mock 資料
        return try await fetchMockData(for: location)
        #endif
    }
}

// MARK: - MockWeatherService (for Testing)
// MARK: - MockWeatherService (for Testing)
// MARK: - MockWeatherService (for Testing)
final class MockWeatherService: WeatherServiceProtocol, @unchecked Sendable {
    
    // MARK: - Properties
    var mockWeatherData: WeatherData?
    var shouldThrowError: Bool = false
    var errorToThrow: WeatherServiceError = .networkError
    
    // MARK: - Initializer
    init(mockData: WeatherData? = nil) {
        self.mockWeatherData = mockData
    }
    
    // MARK: - Protocol Implementation
    func fetchCurrentWeather(for location: CLLocation) async throws -> WeatherData {
        if shouldThrowError {
            throw errorToThrow
        }
        
        return mockWeatherData ?? WeatherData(
            temperature: 25.0,
            condition: "cloudy",
            humidity: 0.7,
            windSpeed: 10.0,
            description: "Partly cloudy"
        )
    }
}