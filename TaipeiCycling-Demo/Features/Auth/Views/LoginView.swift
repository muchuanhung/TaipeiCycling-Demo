import SwiftUI
import OAuthSwift

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var authService = StravaAuthService.shared
    @AppStorage("selectedTab") private var selectedTab: Int = 0
    
    var body: some View {
        VStack(spacing: 24) {
            // Logo 和標題區域
            VStack(spacing: 16) {
                Image("App-icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .cornerRadius(16)
                
                Text("Welcome to Velorder")
                    .font(.system(size: 28, weight: .bold))
                
                Text("風雨無阻，不靠運氣靠 Velorder。")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                
                if authService.isAuthenticated {
                    VStack(spacing: 16) {
                        VStack(spacing: 8) {
                            Text("🎉 已登入 Strava")
                                .font(.headline)
                            Text("Token: \(authService.accessToken?.prefix(20) ?? "")...")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        // 添加登出按鈕
                        Button {
                            authService.logout()
                            // 登出後關閉頁面，並重置選中頁面
                            dismiss()
                            selectedTab = 0
                            NotificationCenter.default.post(
                                name: NSNotification.Name("UserLoggedOut"), 
                                object: nil
                            )
                        } label: {
                            Text("登出 Strava")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.red.opacity(0.8))  // 使用紅色表示登出
                                .cornerRadius(12)
                        }
                    }
                } else {
                    Button {
                        print("🚀 按鈕點擊")
                        authService.authorize()
                    } label: {
                        Text("Strava 登入")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.Theme.strava)
                            .cornerRadius(12)
                    }
                }
            }
            .padding(.top, 60)
            .padding(.horizontal, 20)
            
            Spacer()
        }
#if compiler(>=5.9)
        .onChange(of: authService.isAuthenticated) { oldValue, newValue in
            if newValue {
                // 當登入成功時，延遲一下再關閉頁面，讓用戶看到登入成功的訊息
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    dismiss()
                }
            }
        }
#else
        .onChange(of: authService.isAuthenticated) { value in
            if value {
                // 當登入成功時，延遲一下再關閉頁面，讓用戶看到登入成功的訊息
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    dismiss()
                }
            }
        }
#endif
    }
}

#Preview {
    LoginView()
} 
