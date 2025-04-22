import SwiftUI
import MapKit

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack(spacing: -40) {
            // 輪播圖區域
            BaseCarouselView(
                itemCount: viewModel.carouselItems.count,
                currentIndex: $viewModel.currentCarouselIndex
            ) {
                ForEach(viewModel.carouselItems) { item in
                    CarouselItemView(item: item)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 650)
            .ignoresSafeArea(.all)
            
            // 確認 WeatherInfoCard 的使用
            WeatherInfoCard(
                weather: viewModel.weather,
                location: viewModel.location
            )
            .padding(.horizontal)
            
            Spacer()
        }
        .ignoresSafeArea(.all, edges: .top)
    }
}

// 輪播圖項目視圖
struct CarouselItemView: View {
    let item: CarouselItem
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(item.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .ignoresSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    VStack(spacing: 8) {
                        Text(item.title)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(Color.Theme.primary)
                        
                        Text(item.description)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal)
                    
                    Spacer()
                        .frame(height: 70)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
