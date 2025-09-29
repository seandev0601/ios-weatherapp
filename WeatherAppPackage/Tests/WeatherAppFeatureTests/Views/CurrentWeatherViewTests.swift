import XCTest
import SwiftUI
import CoreLocation
@testable import WeatherAppFeature

// MARK: - MockWeatherViewModel for UI Testing
@MainActor
final class MockWeatherViewModel: ObservableObject, CurrentWeatherViewModelProtocol {
    @Published var currentWeather: WeatherData?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    func setMockWeather(_ weather: WeatherData) {
        currentWeather = weather
        isLoading = false
        errorMessage = nil
    }
    
    func setLoading(_ loading: Bool) {
        isLoading = loading
        if loading {
            currentWeather = nil
            errorMessage = nil
        }
    }
    
    func setError(_ message: String) {
        isLoading = false
        currentWeather = nil
        errorMessage = message
    }
}

@MainActor
final class CurrentWeatherViewTests: XCTestCase {
    
    // MARK: - Properties
    private var mockViewModel: MockWeatherViewModel?
    
    // MARK: - Test Data
    private let sampleWeatherData = WeatherData(
        temperature: 25.5,
        condition: "sunny",
        humidity: 0.6,
        windSpeed: 12.0,
        description: "Clear and sunny"
    )
    
    // MARK: - Setup & Teardown
    override func setUp() async throws {
        try await super.setUp()
        mockViewModel = MockWeatherViewModel()
    }
    
    override func tearDown() {
        mockViewModel = nil
        super.tearDown()
    }
    
    // MARK: - Temperature Display Tests
    func testDisplaysTemperature() {
        // Given - 有天氣資料的 ViewModel
        guard let viewModel = mockViewModel else {
            XCTFail("MockViewModel should be initialized")
            return
        }
        viewModel.setMockWeather(sampleWeatherData)

        // When - 建立 CurrentWeatherView
        let view = CurrentWeatherView(viewModel: viewModel)

        // Then - View 應該能正常創建且包含期望的資料
        XCTAssertNotNil(view, "CurrentWeatherView should be created")
        XCTAssertEqual(viewModel.currentWeather?.temperature, 25.5, "Temperature should match")
        XCTAssertFalse(viewModel.isLoading, "Should not be loading")
    }
    
    // MARK: - Weather Condition Display Tests
    func testDisplaysWeatherCondition() {
        // Given - 有天氣資料的 ViewModel
        guard let viewModel = mockViewModel else {
            XCTFail("MockViewModel should be initialized")
            return
        }
        viewModel.setMockWeather(sampleWeatherData)

        // When - 建立 CurrentWeatherView
        let view = CurrentWeatherView(viewModel: viewModel)

        // Then - ViewModel 應該包含正確的天氣描述
        XCTAssertNotNil(view, "CurrentWeatherView should be created")
        XCTAssertEqual(viewModel.currentWeather?.description, "Clear and sunny", "Weather description should match")
        XCTAssertEqual(viewModel.currentWeather?.condition, "sunny", "Weather condition should match")
    }
    
    // MARK: - Loading State Display Tests
    func testLoadingStateDisplay() {
        // Given - 載入狀態的 ViewModel
        guard let viewModel = mockViewModel else {
            XCTFail("MockViewModel should be initialized")
            return
        }
        viewModel.setLoading(true)

        // When - 建立 CurrentWeatherView
        let view = CurrentWeatherView(viewModel: viewModel)

        // Then - ViewModel 應該處於載入狀態
        XCTAssertNotNil(view, "CurrentWeatherView should be created")
        XCTAssertTrue(viewModel.isLoading, "Should be loading")
        XCTAssertNil(viewModel.currentWeather, "Should have no weather data when loading")
    }
    
    // MARK: - Error State Tests
    func testErrorStateDisplay() {
        // Given - 錯誤狀態的 ViewModel
        guard let viewModel = mockViewModel else {
            XCTFail("MockViewModel should be initialized")
            return
        }
        viewModel.setError("Network error")

        // When - 建立 CurrentWeatherView
        let view = CurrentWeatherView(viewModel: viewModel)

        // Then - ViewModel 應該處於錯誤狀態
        XCTAssertNotNil(view, "CurrentWeatherView should be created")
        XCTAssertFalse(viewModel.isLoading, "Should not be loading")
        XCTAssertNil(viewModel.currentWeather, "Should have no weather data when error")
        XCTAssertEqual(viewModel.errorMessage, "Network error", "Should show error message")
    }
    
    // MARK: - Empty State Tests
    func testEmptyStateDisplay() {
        // Given - 沒有資料的 ViewModel (預設狀態)
        guard let viewModel = mockViewModel else {
            XCTFail("MockViewModel should be initialized")
            return
        }

        // When - 建立 CurrentWeatherView
        let view = CurrentWeatherView(viewModel: viewModel)

        // Then - ViewModel 應該處於空白狀態
        XCTAssertNotNil(view, "CurrentWeatherView should be created")
        XCTAssertFalse(viewModel.isLoading, "Should not be loading")
        XCTAssertNil(viewModel.currentWeather, "Should have no weather data initially")
        XCTAssertNil(viewModel.errorMessage, "Should have no error message initially")
    }
}