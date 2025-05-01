//
//  ContentView.swift
//  TaipeiCycling
//
//  Created by michael on 2025/4/18.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("selectedTab") private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("首頁", systemImage: "house")
                }
                .tag(0)
            
            GroupView()
                .tabItem {
                    Label("約騎", systemImage: "figure.walk.diamond")
                }
                .tag(1)
            
            RouteListView()
                .tabItem {
                    Label("路線", systemImage: "list.bullet")
                }
                .tag(2)
            
            MonitorView()
                .tabItem {
                    Label("路況監控", systemImage: "exclamationmark.triangle")
                }
                .tag(3)
            // TestView() // UIKit 包裝的 View
            //     .tabItem {
            //         Label("個人", systemImage: "person.circle")
            //     }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("UserLoggedOut"))) { _ in
            // 確保在收到通知時也切換到首頁
            selectedTab = 0
        }
        .ignoresSafeArea(.all, edges: .top)
    }
}

#Preview {
    ContentView()
}
