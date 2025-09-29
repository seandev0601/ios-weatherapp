import Foundation
@testable import WeatherAppFeature

/// Mock WeatherService 用於測試
///
/// 這個 Mock 類別讓我們可以控制天氣服務的回應，
/// 而不需要真正呼叫 WeatherKit API
actor MockWeatherService {

    // MARK: - Mock 控制屬性

    /// 控制是否應該回傳錯誤
    var shouldReturnError = false

    /// 模擬 API 呼叫延遲（秒）
    var simulatedDelay: TimeInterval = 0.1

    /// 模擬的天氣資料
    var mockCurrentWeather: MockWeatherData?

    /// 模擬的天氣預報資料
    var mockWeatherForecast: [MockDailyWeather] = []

    // MARK: - Mock 方法

    /// 模擬獲取當前天氣
    func getCurrentWeather() async throws -> MockWeatherData {
        // 模擬網路延遲
        if simulatedDelay > 0 {
            try await Task.sleep(nanoseconds: UInt64(simulatedDelay * 1_000_000_000))
        }

        // 模擬錯誤情況
        if shouldReturnError {
            throw MockWeatherError.networkError
        }

        // 回傳模擬資料
        return mockCurrentWeather ?? MockWeatherData.defaultWeather
    }

    /// 模擬獲取天氣預報
    func getWeatherForecast() async throws -> [MockDailyWeather] {
        // 模擬網路延遲
        if simulatedDelay > 0 {
            try await Task.sleep(nanoseconds: UInt64(simulatedDelay * 1_000_000_000))
        }

        // 模擬錯誤情況
        if shouldReturnError {
            throw MockWeatherError.networkError
        }

        // 回傳模擬資料
        return mockWeatherForecast.isEmpty ? MockWeatherData.defaultForecast : mockWeatherForecast
    }
}

/// Mock 錯誤類型
enum MockWeatherError: Error, LocalizedError {
    case networkError
    case locationPermissionDenied
    case invalidLocation

    var errorDescription: String? {
        switch self {
        case .networkError:
            return "Network connection failed"
        case .locationPermissionDenied:
            return "Location permission denied"
        case .invalidLocation:
            return "Invalid location"
        }
    }
}