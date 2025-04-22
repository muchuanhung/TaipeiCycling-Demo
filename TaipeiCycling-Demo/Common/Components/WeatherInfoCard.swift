import SwiftUI

struct WeatherInfoCard: View {
    let weather: Weather?
    let location: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 26) {
                // 左側天氣圖標
                Image(systemName: getWeatherIcon())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(Color.Theme.primary)
                
                // 中間溫度和天氣資訊
                VStack(alignment: .leading, spacing: 4) {
                    Text(weather?.temperatureCelsius ?? "N/A")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text(weather?.condition ?? "載入中...")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // 右側位置和濕度資訊
                VStack(alignment: .trailing, spacing: 4) {
                    Text(location)
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("濕度: \(weather?.humidity ?? 0)%")
                        .font(.system(size: 14))
                }
                .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 28)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .padding(.horizontal, 16)
    }
    
    // 根據天氣狀況返回對應的系統圖標
    private func getWeatherIcon() -> String {
        guard let condition = weather?.condition else { return "cloud.fill" }
        
        switch condition.lowercased() {
        case let c where c.contains("晴"): return "sun.max.fill"
        case let c where c.contains("雨"): return "cloud.rain.fill"
        case let c where c.contains("陰"): return "cloud.fill"
        case let c where c.contains("多雲"): return "cloud.sun.fill"
        default: return "cloud.fill"
        }
    }
} 
