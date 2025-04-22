import Foundation

// 定義輪播項目結構
struct CarouselItem: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let description: String
} 