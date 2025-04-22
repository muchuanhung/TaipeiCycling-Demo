import Foundation

class WeatherService {
    static let shared = WeatherService()
    
    private let apiKey = "CWA-F5A40623-05C5-405B-85A6-DFF900B07913"
    private let baseURL = "https://opendata.cwa.gov.tw/api/v1/rest/datastore/F-C0032-001"

    func fetchWeatherData() async throws -> (Weather, String) {
        // 構建 URL
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.queryItems = [
            URLQueryItem(name: "Authorization", value: apiKey),
            URLQueryItem(name: "format", value: "JSON"),
            URLQueryItem(name: "locationName", value: "臺北市"),
            URLQueryItem(name: "elementName", value: "Wx,PoP,MinT,MaxT,CI")
        ]
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        print("🌤️ Fetching weather data from URL: \(url.absoluteString)")
        
        // 發送請求
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // 檢查 HTTP 狀態碼
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        print("📡 API Response Status Code: \(httpResponse.statusCode)")
        
        // 打印原始 JSON 數據
        if let jsonString = String(data: data, encoding: .utf8) {
            print("📦 Raw JSON Response: \(jsonString)")
        }
        
        // 解析 JSON 數據
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(WeatherResponse.self, from: data)
            
            guard let location = response.records.location.first else {
                throw WeatherError.noData
            }
            
            let weatherElement = location.weatherElement
            
            // 解析天氣資料
            let condition = weatherElement.first { $0.elementName == "Wx" }?.time.first?.parameter.parameterName ?? "未知"
            let minTemp = Double(weatherElement.first { $0.elementName == "MinT" }?.time.first?.parameter.parameterName ?? "0") ?? 0
            let maxTemp = Double(weatherElement.first { $0.elementName == "MaxT" }?.time.first?.parameter.parameterName ?? "0") ?? 0
            let humidity = Int(weatherElement.first { $0.elementName == "PoP" }?.time.first?.parameter.parameterName ?? "0") ?? 0
            
            let averageTemp = (minTemp + maxTemp) / 2
            
            let weather = Weather(
                temperature: averageTemp,
                humidity: humidity,
                condition: condition,
                windSpeed: 0.0
            )
            
            return (weather, location.locationName)
        } catch {
            print("❌ JSON Parsing Error: \(error)")
            throw error
        }
    }
}

// 定義錯誤類型
enum WeatherError: Error {
    case noData
    case invalidResponse
}

// API 回應的數據結構
struct WeatherResponse: Codable {
    let success: String
    let records: Records
}

struct Records: Codable {
    let location: [Location]
}

struct Location: Codable {
    let locationName: String
    let weatherElement: [WeatherElement]
}

struct WeatherElement: Codable {
    let elementName: String
    let time: [TimeElement]
}

struct TimeElement: Codable {
    let startTime: String
    let endTime: String
    let parameter: Parameter
}

struct Parameter: Codable {
    let parameterName: String
    let parameterValue: String?
} 
