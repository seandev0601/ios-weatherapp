import Foundation
import Testing
@testable import WeatherAppFeature

/// 測試輔助工具和擴展
///
/// 提供常用的測試輔助函數，讓測試程式碼更簡潔和可讀

// MARK: - 非同步測試輔助

/// 等待非同步條件滿足的輔助函數
///
/// - Parameters:
///   - timeout: 等待超時時間（秒）
///   - condition: 需要等待的條件
func waitFor(
    timeout: TimeInterval = 5.0,
    condition: @escaping () async -> Bool
) async throws {
    let startTime = Date()

    while Date().timeIntervalSince(startTime) < timeout {
        if await condition() {
            return
        }
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 秒
    }

    Issue.record("Timeout waiting for condition after \(timeout) seconds")
}

/// 驗證非同步操作會拋出預期的錯誤
///
/// - Parameters:
///   - operation: 要執行的非同步操作
///   - expectedError: 預期的錯誤類型
func expectAsyncThrows<T, E: Error>(
    _ operation: @escaping () async throws -> T,
    expectedError: E.Type,
    file: StaticString = #file,
    line: UInt = #line
) async {
    do {
        _ = try await operation()
        Issue.record("Expected operation to throw \(expectedError), but it succeeded",
                    sourceLocation: .init(fileID: file.description, filePath: String(describing: file), line: Int(line), column: 1))
    } catch {
        if !(error is E) {
            Issue.record("Expected error of type \(expectedError), but got \(type(of: error))",
                        sourceLocation: .init(fileID: file.description, filePath: String(describing: file), line: Int(line), column: 1))
        }
    }
}

// MARK: - 測試資料生成器

/// 測試資料生成器
struct TestDataGenerator {

    /// 生成指定數量的模擬天氣資料
    static func generateWeatherData(count: Int) -> [MockWeatherData] {
        return (0..<count).map { _ in MockWeatherData.randomWeather() }
    }

    /// 生成指定日期範圍的天氣預報
    static func generateForecast(
        startDate: Date = Date(),
        dayCount: Int = 7
    ) -> [MockDailyWeather] {
        return (0..<dayCount).map { dayOffset in
            let date = startDate.addingTimeInterval(TimeInterval(dayOffset * 86400))
            return MockDailyWeather(
                date: date,
                highTemperature: Double.random(in: 15...35),
                lowTemperature: Double.random(in: 5...20),
                condition: ["sunny", "cloudy", "rainy"].randomElement() ?? "sunny",
                precipitationChance: Double.random(in: 0...1)
            )
        }
    }
}

// MARK: - 測試斷言輔助

/// 驗證兩個 Double 值是否近似相等（考慮浮點數精度）
func expectApproximately(
    _ actual: Double,
    _ expected: Double,
    accuracy: Double = 0.001,
    file: StaticString = #file,
    line: UInt = #line
) {
    let difference = abs(actual - expected)
    if difference > accuracy {
        Issue.record("Expected \(expected) ± \(accuracy), but got \(actual)",
                    sourceLocation: .init(fileID: file.description, filePath: String(describing: file), line: Int(line), column: 1))
    }
}

/// 驗證日期是否在指定範圍內
func expectDateInRange(
    _ date: Date,
    from startDate: Date,
    to endDate: Date,
    file: StaticString = #file,
    line: UInt = #line
) {
    if date < startDate || date > endDate {
        Issue.record("Expected date to be between \(startDate) and \(endDate), but got \(date)",
                    sourceLocation: .init(fileID: file.description, filePath: String(describing: file), line: Int(line), column: 1))
    }
}

// MARK: - Mock 設定輔助

/// MockWeatherService 的快速設定擴展
extension MockWeatherService {

    /// 設定成功回應的快速方法
    func setupSuccessResponse(
        weather: MockWeatherData = MockWeatherData.defaultWeather,
        forecast: [MockDailyWeather] = MockWeatherData.defaultForecast,
        delay: TimeInterval = 0.1
    ) {
        self.shouldReturnError = false
        self.mockCurrentWeather = weather
        self.mockWeatherForecast = forecast
        self.simulatedDelay = delay
    }

    /// 設定錯誤回應的快速方法
    func setupErrorResponse(delay: TimeInterval = 0.1) {
        self.shouldReturnError = true
        self.simulatedDelay = delay
    }
}

// MARK: - 日期輔助

extension Date {

    /// 獲取今天的開始時間（00:00:00）
    static var todayStart: Date {
        Calendar.current.startOfDay(for: Date())
    }

    /// 獲取明天的開始時間
    static var tomorrowStart: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: todayStart) ?? Date()
    }

    /// 增加指定天數
    func addingDays(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }
}