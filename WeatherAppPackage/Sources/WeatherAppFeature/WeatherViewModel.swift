import Foundation
import CoreLocation
import Combine

/// WeatherViewModel 負責管理天氣資料的狀態和業務邏輯
/// 遵循 MVVM 架構模式，作為 View 和 Model 之間的橋樑

// MARK: - WeatherViewModel
@MainActor
class WeatherViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var currentWeather: WeatherData?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    private let weatherService: WeatherServiceProtocol
    
    // MARK: - Initializer
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }
    
    // MARK: - Public Methods
    
    /// 獲取指定位置的天氣資料
    /// - Parameter location: 目標位置
    func fetchWeather(for location: CLLocation) async {
        await performWeatherFetch {
            try await self.weatherService.fetchCurrentWeather(for: location)
        }
    }
    
    /// 清除錯誤訊息
    func clearError() {
        errorMessage = nil
    }
    
    /// 重新整理天氣資料
    func refreshWeather() async {
        guard let lastLocation = getLastKnownLocation() else {
            setError(WeatherServiceError.invalidLocation)
            return
        }
        
        await fetchWeather(for: lastLocation)
    }
    
    // MARK: - Private Methods
    
    /// 執行天氣獲取操作的通用方法
    /// - Parameter operation: 獲取天氣資料的操作
    private func performWeatherFetch(_ operation: @escaping () async throws -> WeatherData) async {
        setLoadingState(true)
        clearError()
        
        do {
            let weatherData = try await operation()
            setWeatherData(weatherData)
        } catch {
            handleError(error)
        }
        
        setLoadingState(false)
    }
    
    /// 設定載入狀態
    /// - Parameter loading: 是否正在載入
    private func setLoadingState(_ loading: Bool) {
        isLoading = loading
    }
    
    /// 設定天氣資料
    /// - Parameter data: 天氣資料
    private func setWeatherData(_ data: WeatherData) {
        currentWeather = data
        errorMessage = nil
    }
    
    /// 處理錯誤
    /// - Parameter error: 錯誤物件
    private func handleError(_ error: Error) {
        currentWeather = nil
        setError(error)
    }
    
    /// 設定錯誤訊息
    /// - Parameter error: 錯誤物件
    private func setError(_ error: Error) {
        if let weatherError = error as? WeatherServiceError {
            errorMessage = weatherError.localizedDescription
        } else {
            errorMessage = error.localizedDescription
        }
    }
    
    /// 獲取最後一次知道的位置（模擬實作）
    /// - Returns: 最後一次使用的位置，目前回傳 nil
    private func getLastKnownLocation() -> CLLocation? {
        // TODO: 實作位置緩存機制
        return nil
    }
}