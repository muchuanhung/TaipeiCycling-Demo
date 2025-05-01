// 天氣資訊模型使用struct來定義，並且遵循Codable協議，以便於JSON的序列化和反序列化
struct Weather: Codable {
    // 基本屬性
    let temperature: Double    // 溫度，使用 Double 來儲存小數點數值
    let humidity: Int         // 濕度，使用 Int 因為濕度通常是整數百分比
    let condition: String     // 天氣狀況描述，如「晴時多雲」
    let windSpeed: Double     // 風速，使用 Double 來儲存小數點數值
    
    // 計算屬性
    var temperatureCelsius: String {
        return String(format: "%.1f°C", temperature)  // 將溫度格式化為帶有一位小數的攝氏度字串
    }
    // 提供默認值的初始化方法
    init(temperature: Double = 0.0, humidity: Int = 0, condition: String = "", windSpeed: Double = 0.0) {
        self.temperature = temperature
        self.humidity = humidity
        self.condition = condition
        self.windSpeed = windSpeed
    }
}