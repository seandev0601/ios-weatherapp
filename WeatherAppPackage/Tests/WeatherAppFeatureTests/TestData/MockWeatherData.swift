import Foundation
@testable import WeatherAppFeature

/// 測試用的模擬天氣資料
///
/// 提供一致的測試資料，讓測試結果可預測和可重現
struct MockWeatherData {

    // MARK: - 基礎屬性

    let temperature: Double
    let condition: String
    let description: String
    let humidity: Double
    let windSpeed: Double
    let precipitationChance: Double

    // MARK: - 預設測試資料

    /// 預設的晴天天氣資料
    static let defaultWeather = MockWeatherData(
        temperature: 25.0,
        condition: "sunny",
        description: "Sunny and warm",
        humidity: 0.65,
        windSpeed: 15.0,
        precipitationChance: 0.1
    )

    /// 雨天天氣資料
    static let rainyWeather = MockWeatherData(
        temperature: 18.0,
        condition: "rainy",
        description: "Light rain",
        humidity: 0.85,
        windSpeed: 20.0,
        precipitationChance: 0.8
    )

    /// 多雲天氣資料
    static let cloudyWeather = MockWeatherData(
        temperature: 22.0,
        condition: "cloudy",
        description: "Partly cloudy",
        humidity: 0.70,
        windSpeed: 10.0,
        precipitationChance: 0.3
    )

    /// 預設的 7 日天氣預報
    static let defaultForecast: [MockDailyWeather] = [
        MockDailyWeather(
            date: Date(),
            highTemperature: 28.0,
            lowTemperature: 18.0,
            condition: "sunny",
            precipitationChance: 0.1
        ),
        MockDailyWeather(
            date: Date().addingTimeInterval(86400), // 明天
            highTemperature: 26.0,
            lowTemperature: 16.0,
            condition: "cloudy",
            precipitationChance: 0.3
        ),
        MockDailyWeather(
            date: Date().addingTimeInterval(86400 * 2), // 後天
            highTemperature: 24.0,
            lowTemperature: 14.0,
            condition: "rainy",
            precipitationChance: 0.7
        ),
        MockDailyWeather(
            date: Date().addingTimeInterval(86400 * 3),
            highTemperature: 27.0,
            lowTemperature: 17.0,
            condition: "sunny",
            precipitationChance: 0.2
        ),
        MockDailyWeather(
            date: Date().addingTimeInterval(86400 * 4),
            highTemperature: 25.0,
            lowTemperature: 15.0,
            condition: "cloudy",
            precipitationChance: 0.4
        ),
        MockDailyWeather(
            date: Date().addingTimeInterval(86400 * 5),
            highTemperature: 23.0,
            lowTemperature: 13.0,
            condition: "rainy",
            precipitationChance: 0.8
        ),
        MockDailyWeather(
            date: Date().addingTimeInterval(86400 * 6),
            highTemperature: 29.0,
            lowTemperature: 19.0,
            condition: "sunny",
            precipitationChance: 0.1
        )
    ]
}

/// 每日天氣預報的模擬資料
struct MockDailyWeather {
    let date: Date
    let highTemperature: Double
    let lowTemperature: Double
    let condition: String
    let precipitationChance: Double
}

// MARK: - 測試輔助擴展

extension MockWeatherData {

    /// 建立極端高溫天氣資料（用於邊界測試）
    static let extremeHotWeather = MockWeatherData(
        temperature: 45.0,
        condition: "hot",
        description: "Extremely hot",
        humidity: 0.20,
        windSpeed: 5.0,
        precipitationChance: 0.0
    )

    /// 建立極端低溫天氣資料（用於邊界測試）
    static let extremeColdWeather = MockWeatherData(
        temperature: -20.0,
        condition: "snow",
        description: "Heavy snow",
        humidity: 0.90,
        windSpeed: 25.0,
        precipitationChance: 0.9
    )
}

// MARK: - 測試輔助函數

extension MockWeatherData {

    /// 生成隨機天氣資料（用於壓力測試）
    static func randomWeather() -> MockWeatherData {
        let conditions = ["sunny", "cloudy", "rainy", "snow"]
        let temperatures = Array(-10...40)

        return MockWeatherData(
            temperature: Double(temperatures.randomElement() ?? 20),
            condition: conditions.randomElement() ?? "sunny",
            description: "Random weather for testing",
            humidity: Double.random(in: 0.3...0.9),
            windSpeed: Double.random(in: 0...30),
            precipitationChance: Double.random(in: 0...1)
        )
    }
}