import Foundation
import Combine

class StravaAPIService {
    static let shared = StravaAPIService()
    
    private let baseURL = "https://www.strava.com/api/v3"
    
    private init() {}
    
    func fetchUserRoutes() async throws -> [BikeRoute] {
        guard let token = UserDefaults.standard.string(forKey: "strava_token") else {
            throw APIError.notAuthenticated
        }
        
        // 使用 "athlete/routes" 端點獲取當前用戶的路線
        let urlString = "\(baseURL)/athlete/routes"
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        print("🚲 開始獲取用戶路線")
        print("🔗 URL: \(urlString)")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            print("❌ HTTP 錯誤: \(httpResponse.statusCode)")
            if let errorString = String(data: data, encoding: .utf8) {
                print("📄 錯誤信息: \(errorString)")
            }
            throw APIError.httpError(httpResponse.statusCode)
        }
        
        // 解析 JSON
        let stravaRoutes = try JSONDecoder().decode([StravaRoute].self, from: data)
        print("✅ 成功獲取 \(stravaRoutes.count) 條路線")
        
        // 將 Strava 路線轉換為應用的 BikeRoute 模型
        return stravaRoutes.map { stravaRoute in
            return BikeRoute(
                name: stravaRoute.name,
                description: stravaRoute.description ?? "無描述",
                distance: stravaRoute.distance / 1000, // 轉換為公里
                coordinates: [], // 如果需要具體路徑，可以再發送請求獲取
                difficulty: determineDifficulty(distance: stravaRoute.distance, elevation: stravaRoute.elevation_gain)
            )
        }
    }
    
    private func determineDifficulty(distance: Double, elevation: Double) -> BikeRoute.RouteDifficulty {
        // 基於距離和爬升簡單計算難度
        let distanceKm = distance / 1000
        
        if elevation > 500 || distanceKm > 40 {
            return .difficult
        } else if elevation > 200 || distanceKm > 20 {
            return .moderate
        } else {
            return .easy
        }
    }
    
    enum APIError: Error {
        case notAuthenticated
        case invalidURL
        case invalidResponse
        case httpError(Int)
        case decodingError
    }
}

// Strava API 返回的路線模型
struct StravaRoute: Codable {
    let id: Int
    let name: String
    let description: String?
    let distance: Double
    let elevation_gain: Double
    let map: RouteMap
    
    struct RouteMap: Codable {
        let summary_polyline: String
    }
}