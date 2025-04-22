//
//  HomeViewModel.swift
//  TaipeiCycling-Demo
//
//  Created by michael on 2025/4/21.
//
// 定義首頁視圖模型數據和狀態
import Foundation
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var currentCarouselIndex = 0
    @Published var weather: Weather?
    @Published var location: String = "載入中..."
    
    let carouselItems = [
        CarouselItem(
            title: "台北約騎熱門路線",
            imageName: "bike-mountain-01",
            description: "探索台北最佳自行車道"
        ),
        CarouselItem(
            title: "天氣資訊",
            imageName: "bike-mountain-02",
            description: "即時掌握騎乘天氣"
        ),
        CarouselItem(
            title: "景點推薦",
            imageName: "bike-mountain-03",
            description: "發現城市特色景點"
        )
    ]
    
    init() {
        fetchWeatherData()
    }
    
    func fetchWeatherData() {
        Task {
            do {
                let (weatherData, locationName) = try await WeatherService.shared.fetchWeatherData()
                self.weather = weatherData
                self.location = locationName
            } catch {
                print("Error fetching weather data: \(error)")
            }
        }
    }
}

