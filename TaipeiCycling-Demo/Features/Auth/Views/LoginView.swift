import SwiftUI
import OAuthSwift

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var authService = StravaAuthService.shared
    
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
                    VStack(spacing: 8) {
                        Text("🎉 已登入 Strava")
                            .font(.headline)
                        Text("Token: \(authService.accessToken ?? "N/A")")
                            .font(.caption)
                            .foregroundColor(.gray)
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
                dismiss()
            }
        }
#else
        .onChange(of: authService.isAuthenticated) { value in
            if value {
                dismiss()
            }
        }
#endif
    }
}

#Preview {
    LoginView()
} 
