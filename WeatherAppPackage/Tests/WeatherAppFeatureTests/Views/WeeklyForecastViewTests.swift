import XCTest
import SwiftUI
import Foundation
@testable import WeatherAppFeature

// DailyWeatherData is imported from WeatherAppFeature

// MARK: - MockWeeklyForecastViewModel for UI Testing
@MainActor
final class MockWeeklyForecastViewModel: ObservableObject, WeeklyForecastViewModelProtocol {
    @Published var weeklyForecast: [DailyWeatherData] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func setMockForecast(_ forecast: [DailyWeatherData]) {
        weeklyForecast = forecast
        isLoading = false
        errorMessage = nil
    }

    func setLoading(_ loading: Bool) {
        isLoading = loading
        if loading {
            weeklyForecast = []
            errorMessage = nil
        }
    }

    func setError(_ message: String) {
        isLoading = false
        weeklyForecast = []
        errorMessage = message
    }
}

@MainActor
final class WeeklyForecastViewTests: XCTestCase {

    // MARK: - Properties
    private var mockViewModel: MockWeeklyForecastViewModel?

    // MARK: - Test Data
    private lazy var sampleWeeklyForecast: [DailyWeatherData] = {
        let calendar = Calendar.current
        let today = Date()

        return (0..<7).map { dayOffset in
            let date = calendar.date(byAdding: .day, value: dayOffset, to: today) ?? today
            return DailyWeatherData(
                date: date,
                condition: ["sunny", "cloudy", "rainy", "sunny", "cloudy", "sunny", "rainy"][dayOffset],
                highTemperature: [28, 26, 22, 30, 25, 27, 24][dayOffset],
                lowTemperature: [18, 16, 12, 20, 15, 17, 14][dayOffset],
                description: ["Clear", "Cloudy", "Light rain", "Sunny", "Partly cloudy", "Clear", "Showers"][dayOffset]
            )
        }
    }()

    // MARK: - Setup & Teardown
    override func setUp() async throws {
        try await super.setUp()
        mockViewModel = MockWeeklyForecastViewModel()
    }

    override func tearDown() {
        mockViewModel = nil
        super.tearDown()
    }

    // MARK: - Seven Days Display Tests
    func testDisplaysSevenDays() {
        // Given - 有 7 天預報資料的 ViewModel
        guard let viewModel = mockViewModel else {
            XCTFail("MockViewModel should be initialized")
            return
        }
        viewModel.setMockForecast(sampleWeeklyForecast)

        // When - 建立 WeeklyForecastView
        let view = WeeklyForecastView(viewModel: viewModel)

        // Then - ViewModel 應該包含 7 天的預報資料
        XCTAssertNotNil(view, "WeeklyForecastView should be created")
        XCTAssertEqual(viewModel.weeklyForecast.count, 7, "Should have 7 days of forecast")
        XCTAssertFalse(viewModel.isLoading, "Should not be loading")
        XCTAssertNil(viewModel.errorMessage, "Should have no error message")
    }

    // MARK: - Daily Row Content Tests
    func testDailyRowContent() {
        // Given - 有預報資料的 ViewModel
        guard let viewModel = mockViewModel else {
            XCTFail("MockViewModel should be initialized")
            return
        }
        viewModel.setMockForecast(sampleWeeklyForecast)

        // When - 建立 WeeklyForecastView
        let view = WeeklyForecastView(viewModel: viewModel)

        // Then - 第一天的資料應該正確
        let firstDay = viewModel.weeklyForecast.first
        XCTAssertNotNil(view, "WeeklyForecastView should be created")
        XCTAssertNotNil(firstDay, "Should have first day data")
        XCTAssertEqual(firstDay?.condition, "sunny", "First day should be sunny")
        XCTAssertEqual(firstDay?.highTemperature, 28, "First day high should be 28")
        XCTAssertEqual(firstDay?.lowTemperature, 18, "First day low should be 18")
        XCTAssertEqual(firstDay?.description, "Clear", "First day description should be Clear")
    }

    // MARK: - Loading State Tests
    func testLoadingStateDisplay() {
        // Given - 載入狀態的 ViewModel
        guard let viewModel = mockViewModel else {
            XCTFail("MockViewModel should be initialized")
            return
        }
        viewModel.setLoading(true)

        // When - 建立 WeeklyForecastView
        let view = WeeklyForecastView(viewModel: viewModel)

        // Then - ViewModel 應該處於載入狀態
        XCTAssertNotNil(view, "WeeklyForecastView should be created")
        XCTAssertTrue(viewModel.isLoading, "Should be loading")
        XCTAssertTrue(viewModel.weeklyForecast.isEmpty, "Should have no forecast data when loading")
    }

    // MARK: - Empty State Tests
    func testEmptyStateDisplay() {
        // Given - 沒有資料的 ViewModel (預設狀態)
        guard let viewModel = mockViewModel else {
            XCTFail("MockViewModel should be initialized")
            return
        }

        // When - 建立 WeeklyForecastView
        let view = WeeklyForecastView(viewModel: viewModel)

        // Then - ViewModel 應該處於空白狀態
        XCTAssertNotNil(view, "WeeklyForecastView should be created")
        XCTAssertFalse(viewModel.isLoading, "Should not be loading")
        XCTAssertTrue(viewModel.weeklyForecast.isEmpty, "Should have no forecast data initially")
        XCTAssertNil(viewModel.errorMessage, "Should have no error message initially")
    }

    // MARK: - Error State Tests
    func testErrorStateDisplay() {
        // Given - 錯誤狀態的 ViewModel
        guard let viewModel = mockViewModel else {
            XCTFail("MockViewModel should be initialized")
            return
        }
        viewModel.setError("Failed to load weekly forecast")

        // When - 建立 WeeklyForecastView
        let view = WeeklyForecastView(viewModel: viewModel)

        // Then - ViewModel 應該處於錯誤狀態
        XCTAssertNotNil(view, "WeeklyForecastView should be created")
        XCTAssertFalse(viewModel.isLoading, "Should not be loading")
        XCTAssertTrue(viewModel.weeklyForecast.isEmpty, "Should have no forecast data when error")
        XCTAssertEqual(viewModel.errorMessage, "Failed to load weekly forecast", "Should show error message")
    }
}