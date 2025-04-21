//
//  ContentView.swift
//  TaipeiCycling
//
//  Created by michael on 2025/4/18.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MapView()
                .tabItem {
                    Label("地圖", systemImage: "map")
                }
            
            RouteListView()
                .tabItem {
                    Label("路線", systemImage: "list.bullet")
                }
            
            WeatherView()
                .tabItem {
                    Label("天氣", systemImage: "cloud.sun")
                }
        }
    }
}

#Preview {
    ContentView()
}
