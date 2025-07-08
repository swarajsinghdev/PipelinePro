//
//  Place.swift
//  PipelinePro
//
//  Created by Swarajmeet Singh on 08/07/25.
//

import Foundation
import CoreLocation

/// Represents a place result from a map search or location service.
/// 
/// This entity encapsulates information about a specific location including
/// its name, address, and geographic coordinates.
struct Place: Identifiable {
    
    // MARK: - Properties
    
    /// Unique identifier for the place
    let id: UUID
    
    /// The display name of the place
    let name: String
    
    /// The formatted address of the place
    let address: String
    
    /// The geographic coordinates of the place
    let coordinate: CoordinateCodable
    
    // MARK: - Coding Keys
    
    private enum CodingKeys: String, CodingKey {
        case name = "place_name"
        case address = "formatted_address"
        case coordinate = "location"
    }
    
    // MARK: - Initializers
    
    /// Creates a place with the specified properties.
    /// 
    /// - Parameters:
    ///   - name: The display name of the place
    ///   - address: The formatted address of the place
    ///   - coordinate: The geographic coordinates of the place
    init(name: String, address: String, coordinate: CoordinateCodable) {
        self.id = UUID()
        self.name = name
        self.address = address
        self.coordinate = coordinate
    }
    
    /// Creates a place from a CoreLocation coordinate.
    /// 
    /// - Parameters:
    ///   - name: The display name of the place
    ///   - address: The formatted address of the place
    ///   - coordinate: The CoreLocation coordinate
    init(name: String, address: String, coordinate: CLLocationCoordinate2D) {
        self.id = UUID()
        self.name = name
        self.address = address
        self.coordinate = CoordinateCodable(from: coordinate)
    }
    
    // MARK: - Computed Properties
    
    /// Returns the CoreLocation coordinate representation.
    var clCoordinate: CLLocationCoordinate2D {
        coordinate.coordinate
    }
}
