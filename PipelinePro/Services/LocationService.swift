//
//  LocationService.swift
//  PipelinePro
//
//  Created by Swarajmeet Singh on 08/07/25.
//

import CoreLocation

// MARK: - Injected Dependencies

/// Protocol for location services to enable dependency injection
protocol LocationService {
    var currentLocation: Coordinate? { get }
    var authorizationStatus: CLAuthorizationStatus { get }
    func requestLocationPermission()
    func getAddress(from coordinate: Coordinate) async throws -> String
}