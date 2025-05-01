import SwiftUI

struct RouteListView: View {
    // 狀態管理
    @StateObject private var viewModel = RouteListViewModel()
    @State private var showLoginSheet = false
    @ObservedObject private var authService = StravaAuthService.shared
    
    var body: some View {
        NavigationView {
            // 條件渲染
            ZStack {
                if viewModel.isLoading {
                    ProgressView("載入中...")
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                        
                        if errorMessage.contains("請先登入 Strava") {
                            Button {
                                showLoginSheet = true
                            } label: {
                                Text("登入 Strava")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.Theme.strava)
                                    .cornerRadius(10)
                            }
                            .padding()
                        } else {
                            Button {
                                viewModel.fetchRoutes()
                            } label: {
                                Text("重試")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                            .padding()
                        }
                    }
                } else if viewModel.routes.isEmpty {
                    VStack {
                        Text("沒有找到路線")
                            .font(.headline)
                        
                        Text("您可能還沒有在 Strava 上創建路線")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding()
                        
                        Button {
                            viewModel.fetchRoutes()
                        } label: {
                            Text("重新載入")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                } else {
                    List(viewModel.routes) { route in
                        NavigationLink(destination: RouteDetailView(route: route)) {
                            RouteRow(route: route)
                        }
                    }
                }
            }
            .navigationTitle("我的路線")
            // 工具欄
            .toolbar {
                // 重新載入
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.fetchRoutes()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
                // 登入
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showLoginSheet = true
                    } label: {
                        Image(systemName: "person.circle")
                            .foregroundColor(authService.isAuthenticated ? .green : .gray)
                    }
                }
            }
            .sheet(isPresented: $showLoginSheet) {
                LoginView()
            }
        }
        // 登入狀態變更
        .onChange(of: authService.isAuthenticated) { _, newValue in
            viewModel.fetchRoutes()
        }
    }
}

// 路線行視圖
struct RouteRow: View {
    let route: BikeRoute
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(route.name)
                .font(.headline)
                .lineLimit(1)
            
            HStack(alignment: .top) {
                InfoLabel(
                    value: String(format: "%.1f km", route.distance),
                    systemImage: "bicycle"
                )
                
                InfoLabel(
                    value: String(format: "%.1f m", route.elevation_gain),
                    systemImage: "mountain.2"
                )
                
                InfoLabel(
                    value: formattedTime(seconds: Int(route.estimated_moving_time)),
                    systemImage: "clock"
                )
            }
            .padding(.top, 4)
        }
        .padding(.vertical, 4)
    }
    
    // 格式化時間格式
    private func formattedTime(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        
        if hours > 0 {
            return "\(hours)小時\(minutes)分"
        } else {
            return "\(minutes)分鐘"
        }
    }
}

// 標籤元件樣式設定
struct InfoLabel: View {
    let value: String
    let systemImage: String
    
    var body: some View {
        VStack(alignment: .center) {
            Label {
                Text(value)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .minimumScaleFactor(0.8)
            } icon: {
                Image(systemName: systemImage)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// 路線詳情視圖
struct RouteDetailView: View {
    let route: BikeRoute
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 路線基本信息
                VStack(alignment: .leading, spacing: 8) {
                    Text(route.name)
                        .font(.largeTitle)
                        .bold()
                        .lineLimit(2)
                    
                    // 使用相同的固定佈局解決方案
                    HStack(alignment: .top) {
                        InfoLabel(
                            value: String(format: "%.1f km", route.distance),
                            systemImage: "bicycle"
                        )
                        
                        InfoLabel(
                            value: String(format: "%.1f m", route.elevation_gain),
                            systemImage: "mountain.2"
                        )
                        
                        InfoLabel(
                            value: formattedTime(seconds: Int(route.estimated_moving_time)),
                            systemImage: "clock"
                        )
                    }
                    .padding(.vertical, 8)
                }
                .padding()
                
                // 路線描述
                VStack(alignment: .leading, spacing: 8) {
                    Text("路線介紹")
                        .font(.headline)
                    
                    Text(route.description)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal)
                
                // 這裡可以未來添加地圖視圖
                Text("地圖視圖將在此顯示")
                    .frame(maxWidth: .infinity, minHeight: 200)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
        }
        .navigationTitle("路線詳情")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // 格式化時間為"x小時y分"格式
    private func formattedTime(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        
        if hours > 0 {
            return "\(hours)小時\(minutes)分"
        } else {
            return "\(minutes)分鐘"
        }
    }
} 
