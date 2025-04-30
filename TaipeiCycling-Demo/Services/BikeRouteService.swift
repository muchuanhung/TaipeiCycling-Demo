import Foundation

class BikeRouteService {
    static let shared = BikeRouteService()
    
    private let stravaAPIService = StravaAPIService.shared
    
    // 這是主要方法，可以從不同來源獲取路線
    func fetchRoutes() async throws -> [BikeRoute] {
        // 先嘗試從 Strava 獲取
        if StravaAuthService.shared.isAuthenticated {
            return try await fetchRoutesFromStrava()
        } else {
            // 如果未登入 Strava，可以返回本地/預設路線
            return fetchLocalRoutes()
        }
    }
    
    // 從 Strava 獲取路線
    private func fetchRoutesFromStrava() async throws -> [BikeRoute] {
        return try await stravaAPIService.fetchUserRoutes()
    }
    
    // 獲取本地預設路線
    private func fetchLocalRoutes() -> [BikeRoute] {
        // 這裡可以返回一些預設的台北自行車路線
        return [
            BikeRoute(
                name: "河濱自行車道",
                description: "台北最受歡迎的河濱自行車道，沿著淡水河騎乘，景色優美。",
                distance: 15.5,
                coordinates: [],
                difficulty: .easy
            ),
            BikeRoute(
                name: "關渡-八里路線",
                description: "從關渡騎到八里，可欣賞河岸風光，途經關渡大橋。",
                distance: 22.0,
                coordinates: [],
                difficulty: .moderate
            ),
            BikeRoute(
                name: "內湖-南港路線",
                description: "穿越內湖科技園區到南港，有一定的爬坡，適合挑戰。",
                distance: 18.5,
                coordinates: [],
                difficulty: .moderate
            )
        ]
    }
} 
