import Foundation
import SwiftUI
import Combine

@MainActor
class RouteListViewModel: ObservableObject {
    @Published var routes: [BikeRoute] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let stravaAPIService = StravaAPIService.shared
    private let authService = StravaAuthService.shared
    private var lastFetchTime: Date?
    private let minimumFetchInterval: TimeInterval = 0.5 // 最小間隔時間，0.5秒
    
    
    init() {
        // 如果已經認證，則立即獲取路線
        if authService.isAuthenticated {
            fetchRoutes()
        }
    }
    
    func fetchRoutes() {
        guard authService.isAuthenticated else {
            errorMessage = "請先登入 Strava"
            return
        }
        if let lastTime = lastFetchTime, 
           Date().timeIntervalSince(lastTime) < minimumFetchInterval {
            print("⏱️ 避免重複請求，跳過此次獲取")
            return
        }
        // 更新最後請求時間
        lastFetchTime = Date()
        
        guard !isLoading else {
            print("⏳ 已有請求進行中，跳過此次獲取")
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedRoutes = try await stravaAPIService.fetchUserRoutes()
                await MainActor.run {
                    self.routes = fetchedRoutes
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "獲取路線失敗: \(error.localizedDescription)"
                    self.isLoading = false
                }
                print("❌ 獲取路線錯誤: \(error)")
            }
        }
    }
} 