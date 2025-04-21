import SwiftUI

struct BaseCarouselView<Content: View>: View {
    let content: Content
    let itemCount: Int
    @Binding var currentIndex: Int
    let configuration: CarouselConfiguration
    
    init(
        itemCount: Int,
        currentIndex: Binding<Int>,
        configuration: CarouselConfiguration = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.itemCount = itemCount
        self._currentIndex = currentIndex
        self.configuration = configuration
        self.content = content()
    }
    
    var body: some View {
        TabView(selection: $currentIndex) {
            content
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
    }
}