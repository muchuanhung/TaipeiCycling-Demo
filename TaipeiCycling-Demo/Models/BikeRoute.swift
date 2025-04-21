import Foundation
import CoreLocation

struct BikeRoute: Identifiable {
    let id: UUID = UUID()
    let name: String
    let description: String
    let distance: Double
    let coordinates: [CLLocationCoordinate2D]
    let difficulty: RouteDifficulty
    
    enum RouteDifficulty {
        case easy
        case moderate
        case difficult
    }
} 