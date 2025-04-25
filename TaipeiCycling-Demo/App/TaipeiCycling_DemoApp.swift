//
//  TaipeiCycling_DemoApp.swift
//  TaipeiCycling-Demo
//
//  Created by michael on 2025/4/21.
//

import SwiftUI
import OAuthSwift

@main
struct TaipeiCycling_DemoApp: App {
    @StateObject private var authService = StravaAuthService.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authService)
                .onOpenURL { url in
                    print("📱 收到 URL 回調: \(url)")
                    if url.scheme == "velorder" {
                        print("✅ 處理 OAuth 回調")
                        OAuthSwift.handle(url: url)
                    } else {
                        print("❌ URL scheme 不匹配: \(url.scheme ?? "nil")")
                    }
                }
        }
    }
}


