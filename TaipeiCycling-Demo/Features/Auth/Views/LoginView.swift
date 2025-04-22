import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 24) {
            // Logo 和標題區域
            VStack(spacing: 16) {
                Image("App-icon") // 修改為 App-icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .cornerRadius(16) // 添加圓角，讓 logo 更美觀
                
                Text("Welcome to Velorder")
                    .font(.system(size: 28, weight: .bold))
                
                Text("風雨無阻，不靠運氣靠 Velorder。")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
              
                Button {
                    // 註冊功能
                } label: {
                    Text("Strava 登入")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.Theme.strava)
                        .cornerRadius(12)
                }
                .padding(.top, 60)
                .padding(.horizontal, 20)
            }
            .padding(.top, 60)
            
            Spacer()
            
        }
    }
}

#Preview {
    LoginView()
} 
