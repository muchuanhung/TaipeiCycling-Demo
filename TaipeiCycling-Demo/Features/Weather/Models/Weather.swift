import Foundation

struct Weather: Codable {
    let temperature: Double
    let humidity: Int
    let condition: String
    let windSpeed: Double
    
    var temperatureCelsius: String {
        return String(format: "%.1f°C", temperature)
    }
} 