import Testing
@testable import WeatherAppFeature

/// WeatherViewModel 的單元測試
///
/// 這是 TDD 測試的起點，我們先寫一個必定失敗的測試
/// 來確保 RED -> GREEN -> REFACTOR 循環的正確開始
@Suite("WeatherViewModel Tests")
struct WeatherViewModelTests {

    // MARK: - TDD RED 階段：第一個失敗測試

    /// 測試 WeatherViewModel 是否存在
    ///
    /// 這個測試必定會失敗，因為我們還沒有建立 WeatherViewModel 類別
    /// 這是 TDD 的正確起點：RED 狀態
    @Test("WeatherViewModel should exist")
    func testWeatherViewModelExists() async throws {
        // Given: 我們需要一個 WeatherViewModel 實例

        // When: 嘗試建立 WeatherViewModel（這會編譯失敗）
        let viewModel = WeatherViewModel()

        // Then: 驗證 viewModel 不為 nil
        #expect(viewModel != nil)
    }

    /// 測試 WeatherViewModel 的初始狀態
    ///
    /// 這個測試也會失敗，因為相關的屬性和狀態還不存在
    @Test("WeatherViewModel should have correct initial state")
    func testWeatherViewModelInitialState() async throws {
        // Given: 建立 WeatherViewModel 實例
        let viewModel = WeatherViewModel()

        // Then: 驗證初始狀態
        #expect(viewModel.isLoading == false)
        #expect(viewModel.currentWeather == nil)
        #expect(viewModel.errorMessage == nil)
    }

    /// 測試 WeatherViewModel 載入天氣的功能
    ///
    /// 這個測試會失敗，因為 fetchWeather 方法還不存在
    @Test("WeatherViewModel should be able to fetch weather")
    func testFetchWeatherFunctionExists() async throws {
        // Given: 建立 WeatherViewModel 實例
        let viewModel = WeatherViewModel()

        // When: 嘗試呼叫 fetchWeather 方法（這會編譯失敗）
        await viewModel.fetchWeather()

        // Then: 如果能執行到這裡，表示方法存在
        #expect(true) // 這個測試的目的是確保方法存在
    }
}