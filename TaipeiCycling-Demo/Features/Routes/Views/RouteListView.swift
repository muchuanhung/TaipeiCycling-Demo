import SwiftUI

struct RouteListView: View {
    // 狀態管理
    @StateObject private var viewModel = RouteListViewModel()
    @State private var showLoginSheet = false
    @ObservedObject private var authService = StravaAuthService.shared
    
    // 控制自行車動畫
    @State private var bikePosition: CGFloat = 300
    @State private var isAnimating = false
    
    
    var body: some View {
        NavigationView {
            // 條件渲染
            ZStack {
                // 自行車載入動畫
                if viewModel.isLoading {
                    VStack {
                        Text("🚴‍♂️")
                            .font(.system(size: 32))
                            .offset(x: bikePosition)
                            .zIndex(2) // 確保動畫在最頂層
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .onAppear {
                        startBikeAnimation()
                    }
                }
                
                // 主要內容區域
                if viewModel.isLoading && !isAnimating {
                    // 使用空視圖以保持結構完整
                    Color.clear
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
                     // 自定義下拉刷新
                    // ScrollView {
                    //     ForEach(viewModel.routes) { route in
                    //         NavigationLink(destination: RouteDetailView(route: route)) {
                    //             RouteRow(route: route)
                    //         }
                    //         .buttonStyle(PlainButtonStyle())
                    //         .padding(.horizontal)
                    //         .padding(.vertical, 8)
                    //         .background(Color.white)
                    //         .cornerRadius(10)
                    //         .shadow(radius: 1)
                    //         .padding(.horizontal, 10)
                    //         .padding(.vertical, 5)
                    //     }
                    //     GeometryReader { geometry in
                    //         if geometry.frame(in: .global).minY > 50 {
                    //             // 檢測到足夠的下拉距離時顯示我們的動畫
                    //             VStack {
                    //                 Color.clear
                    //             }
                    //             .frame(width: geometry.size.width)
                    //             .onAppear {
                    //                 if !viewModel.isLoading {
                    //                     viewModel.isLoading = true
                    //                     startBikeAnimation() // 直接在這裡調用動畫
                    //                     viewModel.fetchRoutes()
                                        
                    //                     // 模擬加載結束
                    //                     DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    //                         viewModel.isLoading = false
                    //                         isAnimating = false // 停止動畫
                    //                         bikePosition = UIScreen.main.bounds.width + 100 // 重置位置
                    //                     }
                    //                 }
                    //             }
                    //         }
                    //     }
                    //     .frame(height: 40)
                    // }

                    // 系統下拉刷新
                    List(viewModel.routes) { route in
                        NavigationLink(destination: RouteDetailView(route: route)) {
                            RouteRow(route: route)
                        }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 1)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            // 移除預設的 padding
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)    
                            .listRowBackground(Color.clear) 
                    }
                   .refreshable {
                        viewModel.isLoading = true
                        startBikeAnimation()
                        await Task {
                            viewModel.fetchRoutes()
                       try? await Task.sleep(nanoseconds: 1_000_000_000)
                        viewModel.isLoading = false
                        isAnimating = false
                        bikePosition = UIScreen.main.bounds.width + 100
                        }.value
                    }
                }
            }
            .navigationTitle("我的路線")
            // 工具欄
            .toolbar {
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
                isAnimating = false
                bikePosition = UIScreen.main.bounds.width + 100 // 重置位置
        }
    }
    
    // 開始自行車動畫
    private func startBikeAnimation() {
        isAnimating = true
        bikePosition = UIScreen.main.bounds.width + 100 // 起始位置（螢幕右側外）
        
        // 使用withAnimation創建動畫
        withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
            bikePosition = -300 // 終點位置（螢幕左側外）
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
