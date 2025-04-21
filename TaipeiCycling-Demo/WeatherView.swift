import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        VStack {
            Text("天氣資訊")
                .font(.title)
            // Weather content will be implemented later
        }
    }
} 