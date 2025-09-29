import XCTest
import CoreLocation
@testable import WeatherAppFeature

final class WeatherServiceTests: XCTestCase {
    
    // MARK: - Test Data
    private let sampleLocation = CLLocation(latitude: 37.7749, longitude: -122.4194) // San Francisco
    private let sampleWeatherData = WeatherData(
        temperature: 22.5,
        condition: "sunny",
        humidity: 0.6,
        windSpeed: 12.0,
        description: "Clear and sunny"
    )
    
    // MARK: - Success Tests
    func testFetchCurrentWeatherSuccess() async throws {
        // Given - 準備 WeatherService 實例
        let weatherService = WeatherService()
        
        // When - 呼叫 fetchCurrentWeather 方法
        let result = try await weatherService.fetchCurrentWeather(for: sampleLocation)
        
        // Then - 驗證回傳的天氣資料
        XCTAssertNotNil(result)
        XCTAssertEqual(result.temperature, sampleWeatherData.temperature)
        XCTAssertEqual(result.condition, sampleWeatherData.condition)
        XCTAssertEqual(result.humidity, sampleWeatherData.humidity)
        XCTAssertEqual(result.windSpeed, sampleWeatherData.windSpeed)
        XCTAssertEqual(result.description, sampleWeatherData.description)
        
        // 驗證資料有效性
        XCTAssertTrue(result.isValid)
    }
    
    // MARK: - Error Handling Tests
    func testFetchWeatherError() async throws {
        // Given - 準備 WeatherService 實例和無效位置
        let weatherService = WeatherService()
        let invalidLocation = CLLocation(latitude: 999, longitude: 999) // 無效座標
        
        // When & Then - 驗證錯誤處理
        do {
            _ = try await weatherService.fetchCurrentWeather(for: invalidLocation)
            XCTFail("應該要拋出錯誤")
        } catch {
            // 驗證錯誤類型
            XCTAssertTrue(error is WeatherServiceError)
            
            if let weatherError = error as? WeatherServiceError {
                switch weatherError {
                case .networkError, .invalidLocation, .apiError:
                    // 預期的錯誤類型
                    XCTAssertTrue(true)
                default:
                    XCTFail("非預期的錯誤類型")
                }
            }
        }
    }
    
    // MARK: - Additional Test Cases
    func testFetchWeatherWithNilLocation() async throws {
        // Given - 準備 WeatherService 實例和 nil 位置
        let weatherService = WeatherService()
        
        // When & Then - 測試 nil 位置處理
        do {
            // 使用極端座標模擬無效位置
            let extremeLocation = CLLocation(latitude: 91, longitude: 181)
            _ = try await weatherService.fetchCurrentWeather(for: extremeLocation)
            XCTFail("應該要拋出位置錯誤")
        } catch WeatherServiceError.invalidLocation {
            // 預期的錯誤
            XCTAssertTrue(true)
        } catch {
            XCTFail("錯誤類型不符: \(error)")
        }
    }
    
    func testWeatherServiceInitialization() {
        // Given & When - 建立 WeatherService 實例
        let weatherService = WeatherService()
        
        // Then - 驗證實例建立成功
        XCTAssertNotNil(weatherService)
    }
}