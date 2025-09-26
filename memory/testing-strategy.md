## TDD 測試策略與實作指南

### TDD 開發循環
- **Red**：先寫失敗的測試
- **Green**：寫最小程式碼讓測試通過
- **Refactor**：重構程式碼並保持測試通過

### WeatherApp 測試架構
```
WeatherAppTests/
├── ViewModels/
│   ├── WeatherViewModelTests.swift
│   └── LocationViewModelTests.swift
├── Models/
│   ├── WeatherDataTests.swift
│   └── LocationTests.swift
├── Services/
│   ├── WeatherServiceTests.swift
│   └── LocationServiceTests.swift
├── Mocks/
│   ├── MockWeatherService.swift
│   ├── MockLocationManager.swift
│   └── MockWeatherData.swift
└── UI/
    └── WeatherAppUITests.swift
```

### 單元測試標準
- **測試覆蓋率**：目標 80%+
- **測試命名**：`test_[功能]_[條件]_[預期結果]()`
- **測試結構**：Given-When-Then 模式
- **Mock 使用**：所有外部依賴都要 Mock

#### ViewModel 測試範例
```swift
class WeatherViewModelTests: XCTestCase {
    var viewModel: WeatherViewModel!
    var mockWeatherService: MockWeatherService!

    override func setUp() {
        super.setUp()
        mockWeatherService = MockWeatherService()
        viewModel = WeatherViewModel(weatherService: mockWeatherService)
    }

    func test_fetchWeather_withValidLocation_updatesWeatherData() {
        // Given
        let expectedWeather = MockWeatherData.sampleWeather
        mockWeatherService.mockWeather = expectedWeather

        // When
        await viewModel.fetchWeather()

        // Then
        XCTAssertEqual(viewModel.currentWeather?.temperature, expectedWeather.temperature)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }

    func test_fetchWeather_withNetworkError_setsErrorMessage() {
        // Given
        mockWeatherService.shouldReturnError = true

        // When
        await viewModel.fetchWeather()

        // Then
        XCTAssertNil(viewModel.currentWeather)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
    }
}
```

### UI 測試策略
- **主要流程測試**：關鍵使用者路徑
- **錯誤情境測試**：網路錯誤、權限拒絕等
- **可訪問性測試**：VoiceOver 支援
- **效能測試**：啟動時間、記憶體使用

#### UI 測試範例
```swift
class WeatherAppUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }

    func test_weatherApp_displaysCurrentWeather() {
        // Given
        let temperatureLabel = app.staticTexts["currentTemperature"]

        // When
        app.buttons["refreshWeather"].tap()

        // Then
        XCTAssertTrue(temperatureLabel.exists)
        XCTAssertTrue(temperatureLabel.label.contains("°"))
    }

    func test_weatherApp_displaysWeeklyForecast() {
        // Given
        let forecastList = app.collectionViews["weeklyForecast"]

        // When
        app.buttons["showForecast"].tap()

        // Then
        XCTAssertTrue(forecastList.exists)
        XCTAssertEqual(forecastList.cells.count, 7)
    }
}
```

### Mock 資料策略
```swift
struct MockWeatherData {
    static let sampleWeather = WeatherData(
        temperature: 25.0,
        condition: .sunny,
        humidity: 65,
        windSpeed: 15,
        description: "Sunny and warm"
    )

    static let sampleForecast: [DayWeather] = [
        DayWeather(date: Date(), high: 28, low: 18, condition: .sunny),
        DayWeather(date: Date().addingTimeInterval(86400), high: 26, low: 16, condition: .cloudy),
        // ... 其他 5 天資料
    ]
}

class MockWeatherService: WeatherServiceProtocol {
    var mockWeather: WeatherData?
    var mockForecast: [DayWeather] = []
    var shouldReturnError = false

    func getCurrentWeather(for location: CLLocation) async throws -> WeatherData {
        if shouldReturnError {
            throw WeatherError.networkError
        }
        return mockWeather ?? MockWeatherData.sampleWeather
    }

    func getWeeklyForecast(for location: CLLocation) async throws -> [DayWeather] {
        if shouldReturnError {
            throw WeatherError.networkError
        }
        return mockForecast.isEmpty ? MockWeatherData.sampleForecast : mockForecast
    }
}
```

### 測試執行與報告
- **本地執行**：`cmd+u` 在 Xcode 中執行
- **命令列執行**：`xcodebuild test -scheme WeatherApp`
- **覆蓋率報告**：使用 Xcode Code Coverage
- **CI 整合**：GitHub Actions 自動執行測試

### 測試品質指標
- **測試速度**：單元測試 < 0.1s，UI 測試 < 10s
- **測試穩定性**：flaky tests < 1%
- **測試維護**：每次功能更新都要更新對應測試
- **回歸測試**：修 bug 時必須加入對應的測試案例

### TDD 最佳實踐
- **小步前進**：每次只寫一個失敗測試
- **簡單解法**：用最簡單的方式讓測試通過
- **頻繁重構**：保持程式碼乾淨
- **測試先行**：永遠先寫測試再寫程式碼