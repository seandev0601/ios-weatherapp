import Foundation

// MARK: - WeatherData Model
import Foundation

// MARK: - WeatherData Model
struct WeatherData: Codable {
    let temperature: Double
    let condition: String
    let humidity: Double
    let windSpeed: Double
    let description: String
    
    // MARK: - Initializer
    init(temperature: Double, condition: String, humidity: Double, windSpeed: Double, description: String) {
        self.temperature = temperature
        self.condition = condition
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.description = description
    }
    
    // MARK: - Computed Properties
    /// 溫度的攝氏顯示格式
    var temperatureDisplay: String {
        return String(format: "%.1f°C", temperature)
    }
    
    /// 華氏溫度
    var temperatureFahrenheit: Double {
        return (temperature * 9/5) + 32
    }
    
    /// 華氏溫度顯示格式
    var temperatureFahrenheitDisplay: String {
        return String(format: "%.1f°F", temperatureFahrenheit)
    }
    
    /// 濕度百分比顯示
    var humidityDisplay: String {
        return String(format: "%.0f%%", humidity * 100)
    }
    
    /// 風速顯示（公里/小時）
    var windSpeedDisplay: String {
        return String(format: "%.1f km/h", windSpeed)
    }
    
    /// 天氣狀況圖示名稱（SF Symbols）
    var weatherIconName: String {
        switch condition.lowercased() {
        case "sunny", "clear":
            return "sun.max.fill"
        case "cloudy", "overcast":
            return "cloud.fill"
        case "rainy", "rain":
            return "cloud.rain.fill"
        case "stormy", "thunderstorm":
            return "cloud.bolt.fill"
        case "snowy", "snow":
            return "cloud.snow.fill"
        case "windy":
            return "wind"
        default:
            return "questionmark.circle.fill"
        }
    }
    
    /// 是否為舒適的天氣條件
    var isComfortable: Bool {
        return temperature >= 18 && temperature <= 26 && humidity <= 0.7
    }
    
    /// 天氣品質評級
    var weatherQuality: WeatherQuality {
        if isComfortable && windSpeed < 20 {
            return .excellent
        } else if temperature >= 15 && temperature <= 30 && humidity <= 0.8 {
            return .good
        } else if temperature >= 5 && temperature <= 35 {
            return .fair
        } else {
            return .poor
        }
    }
}

// MARK: - WeatherQuality Enum
enum WeatherQuality: String, CaseIterable {
    case excellent = "優秀"
    case good = "良好"
    case fair = "普通"
    case poor = "惡劣"
    
    var color: String {
        switch self {
        case .excellent: return "green"
        case .good: return "blue"
        case .fair: return "orange"
        case .poor: return "red"
        }
    }
}

// MARK: - WeatherData Validation Extension
extension WeatherData {
    /// 驗證天氣資料的有效性
    var isValid: Bool {
        return isTemperatureValid && isHumidityValid && isWindSpeedValid && !condition.isEmpty
    }
    
    /// 驗證溫度範圍是否合理 (-50°C 到 60°C)
    private var isTemperatureValid: Bool {
        return temperature >= -50 && temperature <= 60
    }
    
    /// 驗證濕度範圍 (0-1)
    private var isHumidityValid: Bool {
        return humidity >= 0 && humidity <= 1
    }
    
    /// 驗證風速 (0-200 km/h)
    private var isWindSpeedValid: Bool {
        return windSpeed >= 0 && windSpeed <= 200
    }
    
    /// 獲取驗證錯誤資訊
    var validationErrors: [String] {
        var errors: [String] = []
        
        if !isTemperatureValid {
            errors.append("溫度超出合理範圍 (-50°C 到 60°C)")
        }
        
        if !isHumidityValid {
            errors.append("濕度值無效 (應該在 0-1 之間)")
        }
        
        if !isWindSpeedValid {
            errors.append("風速值無效 (應該在 0-200 km/h 之間)")
        }
        
        if condition.isEmpty {
            errors.append("天氣狀況不能為空")
        }
        
        return errors
    }
}

// MARK: - WeatherDataError
enum WeatherDataError: Error, LocalizedError {
    case invalidTemperature(Double)
    case invalidHumidity(Double)
    case invalidWindSpeed(Double)
    case emptyCondition
    case invalidData([String])
    
    var errorDescription: String? {
        switch self {
        case .invalidTemperature(let temp):
            return "無效的溫度值: \(temp)°C (合理範圍: -50°C 到 60°C)"
        case .invalidHumidity(let humidity):
            return "無效的濕度值: \(humidity) (合理範圍: 0-1)"
        case .invalidWindSpeed(let speed):
            return "無效的風速值: \(speed) km/h (合理範圍: 0-200 km/h)"
        case .emptyCondition:
            return "天氣狀況不能為空"
        case .invalidData(let errors):
            return "資料驗證失敗: \(errors.joined(separator: ", "))"
        }
    }
}

// MARK: - WeatherData Factory
extension WeatherData {
    /// 安全建立 WeatherData 實例，包含驗證
    static func create(temperature: Double, condition: String, humidity: Double, windSpeed: Double, description: String) throws -> WeatherData {
        let weatherData = WeatherData(
            temperature: temperature,
            condition: condition,
            humidity: humidity,
            windSpeed: windSpeed,
            description: description
        )
        
        if !weatherData.isValid {
            throw WeatherDataError.invalidData(weatherData.validationErrors)
        }
        
        return weatherData
    }
}
