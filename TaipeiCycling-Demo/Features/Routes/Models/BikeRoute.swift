import Foundation
import CoreLocation

struct BikeRoute: Identifiable {
    let id: UUID = UUID()
    let name: String
    let description: String
    let distance: Double
    // let elevation_gain: Double
    // let estimated_moving_time: Int
    let coordinates: [CLLocationCoordinate2D]
    let difficulty: RouteDifficulty
    
    enum RouteDifficulty {
        case easy
        case moderate
        case difficult
    }
} 