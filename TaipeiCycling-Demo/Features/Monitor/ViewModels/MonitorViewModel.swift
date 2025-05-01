import Foundation

class MonitorViewModel: ObservableObject {
    @Published var currentWeather: Weather?
    
    func fetchWeather() {
        // Weather fetching logic will be implemented later
    }
} 