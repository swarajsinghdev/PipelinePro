//
//  CoordinateCodable.swift
//  PipelinePro
//
//  Created by Swarajmeet Singh on 08/07/25.
//

import Foundation
import CoreLocation

/// A codable representation of a coordinate for JSON parsing and serialization.
/// 
/// This struct provides a bridge between JSON data and CoreLocation coordinates,
/// with custom coding keys to match common API response formats.
struct CoordinateCodable: Codable {
    
    // MARK: - Properties
    
    /// The latitude value in degrees
    let latitude: Double
    
    /// The longitude value in degrees
    let longitude: Double
    
    // MARK: - Coding Keys
    
    private enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
    
    // MARK: - Initializers
    
    /// Creates a codable coordinate from a CoreLocation coordinate.
    /// 
    /// - Parameter coordinate: The CoreLocation coordinate to convert
    init(from coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
    
    /// Creates a codable coordinate with specified latitude and longitude.
    /// 
    /// - Parameters:
    ///   - latitude: The latitude value in degrees
    ///   - longitude: The longitude value in degrees
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    // MARK: - Computed Properties
    
    /// Converts the codable coordinate to a CoreLocation coordinate.
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
