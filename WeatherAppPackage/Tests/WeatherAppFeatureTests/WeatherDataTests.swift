import XCTest
@testable import WeatherAppFeature

final class WeatherDataTests: XCTestCase {
    
    // MARK: - Test Data
    private let sampleTemperature = 25.5
    private let sampleCondition = "sunny"
    private let sampleHumidity = 0.65
    private let sampleWindSpeed = 15.2
    private let sampleDescription = "Clear sunny day"
    
    // MARK: - Initialization Tests
    func testWeatherDataInitialization() {
        // Given - 準備測試資料
        let temperature = sampleTemperature
        let condition = sampleCondition
        let humidity = sampleHumidity
        let windSpeed = sampleWindSpeed
        let description = sampleDescription
        
        // When - 建立 WeatherData 實例
        let weatherData = WeatherData(
            temperature: temperature,
            condition: condition,
            humidity: humidity,
            windSpeed: windSpeed,
            description: description
        )
        
        // Then - 驗證屬性正確設定
        XCTAssertEqual(weatherData.temperature, temperature)
        XCTAssertEqual(weatherData.condition, condition)
        XCTAssertEqual(weatherData.humidity, humidity)
        XCTAssertEqual(weatherData.windSpeed, windSpeed)
        XCTAssertEqual(weatherData.description, description)
    }
    
    // MARK: - Codable Tests
    func testWeatherDataCodable() throws {
        // Given - 準備測試資料和 JSON
        let originalWeatherData = WeatherData(
            temperature: sampleTemperature,
            condition: sampleCondition,
            humidity: sampleHumidity,
            windSpeed: sampleWindSpeed,
            description: sampleDescription
        )
        
        let expectedJSON = """
        {
            "temperature": \(sampleTemperature),
            "condition": "\(sampleCondition)",
            "humidity": \(sampleHumidity),
            "windSpeed": \(sampleWindSpeed),
            "description": "\(sampleDescription)"
        }
        """.data(using: .utf8)!
        
        // When - 序列化為 JSON
        let encodedData = try JSONEncoder().encode(originalWeatherData)
        let decodedWeatherData = try JSONDecoder().decode(WeatherData.self, from: expectedJSON)
        
        // Then - 驗證序列化和反序列化正確
        XCTAssertNotNil(encodedData)
        XCTAssertEqual(decodedWeatherData.temperature, sampleTemperature)
        XCTAssertEqual(decodedWeatherData.condition, sampleCondition)
        XCTAssertEqual(decodedWeatherData.humidity, sampleHumidity)
        XCTAssertEqual(decodedWeatherData.windSpeed, sampleWindSpeed)
        XCTAssertEqual(decodedWeatherData.description, sampleDescription)
        
        // 驗證編碼後再解碼的一致性
        let redecoded = try JSONDecoder().decode(WeatherData.self, from: encodedData)
        XCTAssertEqual(redecoded.temperature, originalWeatherData.temperature)
        XCTAssertEqual(redecoded.condition, originalWeatherData.condition)
        XCTAssertEqual(redecoded.humidity, originalWeatherData.humidity)
        XCTAssertEqual(redecoded.windSpeed, originalWeatherData.windSpeed)
        XCTAssertEqual(redecoded.description, originalWeatherData.description)
    }
}