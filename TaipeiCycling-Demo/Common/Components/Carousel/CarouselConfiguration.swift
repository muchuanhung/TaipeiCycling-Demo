import SwiftUI

struct CarouselConfiguration {
    let autoScroll: Bool
    let scrollInterval: TimeInterval
    let transition: AnyTransition
    
    static let `default` = CarouselConfiguration(
        autoScroll: true,
        scrollInterval: 3.0,
        transition: .slide
    )
}