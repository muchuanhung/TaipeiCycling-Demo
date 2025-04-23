import Foundation
import OAuthSwift

class StravaAuthService: ObservableObject {
    static let shared = StravaAuthService()
    
    private let clientID = "6db294d67dae229724684181d5caa56ec6f04c68"
    private let clientSecret = "ede64feec927c527db8429701576767187eeda50"
    private let callbackURL = "velorder://oauth-callback"
    private let authorizeURL = "https://www.strava.com/oauth/authorize"
    private let accessTokenURL = "https://www.strava.com/oauth/token"
    
    public var oauthswift: OAuth2Swift?
    
    @Published var isAuthenticated = false
    @Published var accessToken: String?
    
    func authorize() {
        print("🚀 開始 Strava 授權流程...")

        oauthswift = OAuth2Swift(
            consumerKey:    clientID,
            consumerSecret: clientSecret,
            authorizeUrl:   authorizeURL,
            accessTokenUrl: accessTokenURL,
            responseType:   "code"
        )
        
        print("📡 正在發送授權請求...")
        print("🔗 Callback URL: \(callbackURL)")
        print("🟡 授權開始前")
        oauthswift?.authorize(
            withCallbackURL: callbackURL,
            scope: "read,activity:read_all",
            state: "STATE"
        ) { result in
            print("🟢 結果回來了！")
            switch result {
            case .success(let (credential, _, _)):
                print("✅ OAuth success: \(credential)")
        
  
                DispatchQueue.main.async {
                    self.accessToken = credential.oauthToken
                    self.isAuthenticated = true
                    // 保存 token
                    UserDefaults.standard.set(credential.oauthToken, forKey: "strava_token")
                    print("💾 Token 已保存到 UserDefaults")
                }
            case .failure(let error):
                print("❌ OAuth failure: \(error.localizedDescription)")
                print("\n=== ❌ Strava 授權失敗 ===")
                print("❌ 錯誤訊息: \(error.localizedDescription)")
                print("🔍 錯誤詳情: \(error)")
                print("========================\n")
            }
        }
    }
} 
