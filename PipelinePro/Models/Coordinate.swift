//
//  Coordinate.swift
//  PipelinePro
//
//  Created by Swarajmeet Singh on 08/07/25.
//

import Foundation
import CoreLocation

// MARK: - Typealiases / Constants

/// Typealias for coordinate to improve readability
typealias Coordinate = CLLocationCoordinate2D

// MARK: - Extensions

// Note: This extension may cause a warning if CoreLocation adds Equatable conformance in the future.
extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
