import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    
    var body: some View {
          VStack {
            Text("地圖資訊")
                .font(.title)
            // Weather content will be implemented later
        }
    }
} 