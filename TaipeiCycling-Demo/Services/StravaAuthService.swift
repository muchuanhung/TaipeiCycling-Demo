import Foundation
import OAuthSwift

class StravaAuthService: ObservableObject {
    static let shared = StravaAuthService()
    
    private let clientID = "156639"
    private let clientSecret = "ede64feec927c527db8429701576767187eeda50"
    private let callbackURL = "velorder://velorder.com"
    private let authorizeURL = "https://www.strava.com/oauth/authorize"
    private let accessTokenURL = "https://www.strava.com/oauth/token"
    
    private var oauthswift: OAuth2Swift?
    
    @Published var isAuthenticated = false
    @Published var accessToken: String?
    
    // 授權流程
    func authorize() {
        print("\n=== 🚀 開始 Strava 授權流程 ===")
        print("📝 Client ID: \(clientID)")
        print("📝 Callback URL: \(callbackURL)")
        
        oauthswift = OAuth2Swift(
            consumerKey: clientID,
            consumerSecret: clientSecret,
            authorizeUrl: authorizeURL,
            accessTokenUrl: accessTokenURL,
            responseType: "code"
        )
        
        print("📡 正在發送授權請求...")
        
        guard let callbackURL = URL(string: callbackURL) else {
            print("❌ Invalid callback URL")
            return
        }
        
        oauthswift?.authorize(
            withCallbackURL: callbackURL,
            scope: "read",
            state: "STATE"
        ) { result in
            print("🟢 結果回來了！")
            switch result {
            case .success(let (credential, response, parameters)):
                print("✅ OAuth success")
                print("🎟️ Access Token: \(credential.oauthToken)")
                print("📊 Response: \(String(describing: response))")
                print("📝 Parameters: \(parameters)")
                
                DispatchQueue.main.async {
                    self.accessToken = credential.oauthToken
                    self.isAuthenticated = true
                    UserDefaults.standard.set(credential.oauthToken, forKey: "strava_token")
                    print("💾 Token 已保存到 UserDefaults")
                }
                
            case .failure(let error):
                print("\n=== ❌ Strava 授權失敗 ===")
                print("❌ 錯誤訊息: \(error.localizedDescription)")
                print("🔍 錯誤詳情: \(error)")
                print("========================\n")
            }
        }
    }

    // 登出
    func logout() {
        print("🚪 開始登出...")
        
        // 清除本地保存的授權數據
        UserDefaults.standard.removeObject(forKey: "strava_token")
        
        // 更新狀態
        self.accessToken = nil
        self.isAuthenticated = false
        
        // 清除 OAuth 實例
        self.oauthswift = nil
        
        print("✅ 登出成功")
    }
} 
