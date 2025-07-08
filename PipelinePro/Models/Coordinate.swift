//
//  Coordinate.swift
//  PipelinePro
//
//  Created by Swarajmeet Singh on 08/07/25.
//

import Foundation
import CoreLocation

// MARK: - Typealiases

/// A typealias for CLLocationCoordinate2D to improve code readability
/// and provide a more semantic name for pipeline coordinates.
public typealias Coordinate = CLLocationCoordinate2D

// MARK: - Extensions

extension CLLocationCoordinate2D: @retroactive Equatable {
    
    /// Compares two coordinates for equality based on latitude and longitude.
    /// 
    /// - Parameters:
    ///   - lhs: The left-hand side coordinate
    ///   - rhs: The right-hand side coordinate
    /// - Returns: `true` if both coordinates have the same latitude and longitude, `false` otherwise
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

// MARK: - Coordinate Utilities

extension CLLocationCoordinate2D {
    
    /// Creates a coordinate from latitude and longitude values.
    /// 
    /// - Parameters:
    ///   - latitude: The latitude value in degrees
    ///   - longitude: The longitude value in degrees
    /// - Returns: A coordinate with the specified latitude and longitude
    static func make(latitude: Double, longitude: Double) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    /// Checks if the coordinate is valid (latitude between -90 and 90, longitude between -180 and 180).
    var isValid: Bool {
        return latitude >= -90 && latitude <= 90 && longitude >= -180 && longitude <= 180
    }
}
