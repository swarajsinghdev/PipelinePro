//
//  CoordinateCodable.swift
//  PipelinePro
//
//  Created by Swarajmeet Singh on 08/07/25.
//

import Foundation

/// Represents a codable coordinate for JSON parsing
struct CoordinateCodable: Codable {
    let latitude: Double
    let longitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
    
    /// Converts to CLLocationCoordinate2D
    var clCoordinate: Coordinate {
        Coordinate(latitude: latitude, longitude: longitude)
    }
}
