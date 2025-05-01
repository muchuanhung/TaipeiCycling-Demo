import SwiftUI

struct MonitorView: View {
    @StateObject private var viewModel = MonitorViewModel()
    
    var body: some View {
        VStack {
            Text("路段警示 / 道路封閉")
                .font(.title)
            // Weather content will be implemented later
        }
    }
} 