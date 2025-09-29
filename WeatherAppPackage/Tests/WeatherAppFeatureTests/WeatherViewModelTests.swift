import XCTest
import CoreLocation
import Combine
@testable import WeatherAppFeature

// MARK: - Test MockWeatherService
final class TestMockWeatherService: WeatherServiceProtocol, @unchecked Sendable {
    var mockWeatherData: WeatherData?
    var shouldThrowError: Bool = false
    var errorToThrow: WeatherServiceError = .networkError
    
    init(mockData: WeatherData? = nil) {
        self.mockWeatherData = mockData
    }
    
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

final class WeatherViewModelTests: XCTestCase {
    
    // MARK: - Properties
    private var viewModel: WeatherViewModel!
    private var mockWeatherService: TestMockWeatherService!
    
    // MARK: - Test Data
    private let sampleLocation = CLLocation(latitude: 37.7749, longitude: -122.4194) // San Francisco
    private let sampleWeatherData = WeatherData(
        temperature: 22.5,
        condition: "sunny",
        humidity: 0.6,
        windSpeed: 12.0,
        description: "Clear and sunny"
    )
    
    // MARK: - Setup & Teardown
    override func setUp() async throws {
        try await super.setUp()
        mockWeatherService = TestMockWeatherService()
        
        // 在主執行緒建立 ViewModel
        viewModel = await WeatherViewModel(weatherService: mockWeatherService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockWeatherService = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    @MainActor
    func testInitialState() {
        // Given & When - ViewModel 剛建立時
        // Then - 驗證初始狀態
        XCTAssertNil(viewModel.currentWeather)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    // MARK: - Success Scenario Tests
    @MainActor
    func testFetchWeatherSuccess() async throws {
        // Given - 準備成功的 Mock 回應
        mockWeatherService.mockWeatherData = sampleWeatherData
        mockWeatherService.shouldThrowError = false
        
        // When - 呼叫 fetchWeather
        await viewModel.fetchWeather(for: sampleLocation)
        
        // Then - 驗證成功狀態
        XCTAssertNotNil(viewModel.currentWeather)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        
        // 驗證天氣資料正確性
        XCTAssertEqual(viewModel.currentWeather?.temperature, 22.5)
        XCTAssertEqual(viewModel.currentWeather?.condition, "sunny")
        XCTAssertEqual(viewModel.currentWeather?.humidity, 0.6)
        XCTAssertEqual(viewModel.currentWeather?.windSpeed, 12.0)
        XCTAssertEqual(viewModel.currentWeather?.description, "Clear and sunny")
    }
    
    // MARK: - Error Scenario Tests
    @MainActor
    func testFetchWeatherError() async throws {
        // Given - 準備錯誤的 Mock 回應
        mockWeatherService.shouldThrowError = true
        mockWeatherService.errorToThrow = WeatherServiceError.networkError
        
        // When - 呼叫 fetchWeather
        await viewModel.fetchWeather(for: sampleLocation)
        
        // Then - 驗證錯誤狀態
        XCTAssertNil(viewModel.currentWeather)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, "網路連線發生問題")
    }
    
    // MARK: - Loading State Tests
    @MainActor
    func testLoadingState() async throws {
        // Given - 準備成功的 Mock 回應
        mockWeatherService.mockWeatherData = sampleWeatherData
        mockWeatherService.shouldThrowError = false
        
        // When & Then - 驗證初始 loading 狀態為 false
        XCTAssertFalse(viewModel.isLoading)
        
        // 呼叫 fetchWeather
        await viewModel.fetchWeather(for: sampleLocation)
        
        // 驗證完成後 loading 狀態為 false
        XCTAssertFalse(viewModel.isLoading)
    }
    
    // MARK: - Multiple Calls Tests
    @MainActor
    func testMultipleFetchCalls() async throws {
        // Given - 準備多次呼叫的情境
        mockWeatherService.mockWeatherData = sampleWeatherData
        
        // When - 快速多次呼叫 fetchWeather
        await viewModel.fetchWeather(for: sampleLocation)
        await viewModel.fetchWeather(for: sampleLocation)
        await viewModel.fetchWeather(for: sampleLocation)
        
        // Then - 驗證狀態穩定
        XCTAssertNotNil(viewModel.currentWeather)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
}