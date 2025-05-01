import SwiftUI
import MapKit

struct GroupView: View {
    @StateObject private var viewModel = GroupViewModel()
    
    var body: some View {
          VStack {
            Text("約騎資訊")
                .font(.title)
            // Weather content will be implemented later
        }
    }
} 