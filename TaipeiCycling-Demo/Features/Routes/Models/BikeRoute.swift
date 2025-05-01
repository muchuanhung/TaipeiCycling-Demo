import Foundation
import CoreLocation

struct BikeRoute: Identifiable {
    let id: UUID = UUID()
    let name: String
    let description: String
    let distance: Double
    let elevation_gain: Double
    let estimated_moving_time: Double
    let coordinates: [CLLocationCoordinate2D]
} 
