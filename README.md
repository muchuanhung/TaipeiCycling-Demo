#  Velorder（Strava單車約騎 ＆ 氣象預報 ＆ 即時路況系統）－APP 開發
## 專案名稱
Velorder

## 專案介紹
Velorder 
> 是一款整合Strava、氣象資料與即時交通資訊的智慧型約騎iOS APP。目標是讓騎士能夠更智慧地安排訓練與出遊時間，提供完整的騎乘規劃與安全預警服務。
> 
>解決「資訊分散」+「即時風險預警」的需求，是目前熱門 App 的補強性工具。
### 🚴‍♂️ Strava 單車約騎整合
> Velorder 與 Strava API 整合，可匯入用戶的騎乘路線與約騎活動資訊

### 🌦️ 氣象預報系統延伸
> 透過串接氣象 API（中央氣象署），Velorder 提供約騎路線的即時與預測天氣資料，包括：
> 
> 降雨機率、風速風向、體感溫度、紫外線指數
> 
> 自動提醒「高溫」、「大雨」、「落山風」等危險天氣
> 
> 約騎活動提前推播天氣變化通知，利於決策與安全規劃

### 🛣️ 即時路況系統整合
> 即時路線監視器畫面live
> 
> 突發事件警告（道路施工、車禍、封路等）

### 📲 未來延伸功能
> 根據使用者location的氣候與交通狀況，自動推薦出遊地點與路線
> 
> 與Garmin 等裝置整合，提供即時騎乘提示
> 
> 活動簽到 ＆ 安全回報系統

## 專案團隊
| 開發人員 | 負責開發範圍 |
| -------- | -------------------------------------- |
| Muchuanhung    | SwiftUI開發 |
| Marco    | Swift開發 |

## 安裝本專案
1. 取得專案
   ```
   git clone https://github.com/muchuanhung/Velorder.git
   ```
2. 移動到專案中
   ```
   cd Velorder
   ```
3. 使用 Xcode 15 或以上開啟 .xcodeproj
4. 設定 API Key：
   ```
   CWB_API_KEY

   TDX_CLIENT_ID / TDX_CLIENT_SECRET

   STRAVA_CLIENT_ID / STRAVA_CLIENT_SECRET
   ```
5. 點選 Build & Run 即可模擬或安裝至真機！

## 資料夾說明
| 資料夾/檔案 | 說明 |
| --- | --- |
| `Common` | 此資料夾中含有共用的頁面配置、元件 |
| `Features` | 根據身份組（路由）去開不同的資料夾，內有此專案主要的功能核心 |
| `Resources` | 圖片、svg 等放置於此 |
| `Services` | 處理第三方的api資訊 |

## 專案使用技術
| 技術 | 用途 |
|------|------|
| **Swift + SwiftUI** | iOS 原生開發 |
| **Combine** | 狀態更新與 API 整合 |
| **MapKit** | 地圖與定位呈現 |
| **Strava API** | 活動資料同步 |
| **CWB API (中央氣象局)** | 氣象預測資料 |
| **TDX API** | 交通與路況資料串接 |

## 系統要求
- macOS 10.15
- iOS 13.0
- tvOS 13.0
- watchOS 7.0
