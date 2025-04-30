import SwiftUI

struct RouteListView: View {
    @StateObject private var viewModel = RouteListViewModel()
    @State private var showLoginSheet = false
    @ObservedObject private var authService = StravaAuthService.shared
    
    var body: some View {
        NavigationView {
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.fetchRoutes()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
                
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
        .onAppear {
            viewModel.fetchRoutes()
        }
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
            
            HStack {
                Label("\(String(format: "%.1f", route.distance)) km", systemImage: "map")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                difficultyView
            }
        }
        .padding(.vertical, 4)
    }
    
    var difficultyView: some View {
        HStack {
            Text(difficultyText)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(difficultyColor.opacity(0.2))
                .foregroundColor(difficultyColor)
                .cornerRadius(4)
        }
    }
    
    var difficultyText: String {
        switch route.difficulty {
        case .easy: return "簡單"
        case .moderate: return "中等"
        case .difficult: return "困難"
        }
    }
    
    var difficultyColor: Color {
        switch route.difficulty {
        case .easy: return .green
        case .moderate: return .orange
        case .difficult: return .red
        }
    }
}

// 路線詳情視圖（我們需要創建這個視圖）
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
                    
                    HStack {
                        Label("\(String(format: "%.1f", route.distance)) km", systemImage: "map")
                        
                        Spacer()
                        
                        Text(difficultyText)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(difficultyColor.opacity(0.2))
                            .foregroundColor(difficultyColor)
                            .cornerRadius(6)
                    }
                    .font(.headline)
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
    
    var difficultyText: String {
        switch route.difficulty {
        case .easy: return "簡單"
        case .moderate: return "中等"
        case .difficult: return "困難"
        }
    }
    
    var difficultyColor: Color {
        switch route.difficulty {
        case .easy: return .green
        case .moderate: return .orange
        case .difficult: return .red
        }
    }
} 
