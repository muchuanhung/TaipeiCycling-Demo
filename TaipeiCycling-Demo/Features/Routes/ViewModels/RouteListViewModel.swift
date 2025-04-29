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