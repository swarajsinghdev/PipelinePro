//
//  LocationService.swift
//  PipelinePro
//
//  Created by Swarajmeet Singh on 08/07/25.
//

import CoreLocation

/// Protocol defining the interface for location services.
/// 
/// This protocol enables dependency injection and testing by abstracting
/// location-related functionality behind a clean interface.
protocol LocationService {
    
    // MARK: - Properties
    
    /// The current location of the device, if available
    var currentLocation: CLLocationCoordinate2D? { get }
    
    /// The current authorization status for location services
    var authorizationStatus: CLAuthorizationStatus { get }
    
    // MARK: - Methods
    
    /// Requests permission to access location services.
    /// 
    /// This method should be called before attempting to access location data.
    func requestLocationPermission()
    
    /// Retrieves the address for a given coordinate.
    /// 
    /// - Parameter coordinate: The coordinate to get the address for
    /// - Returns: The formatted address string
    /// - Throws: An error if the address lookup fails
    func getAddress(from coordinate: CLLocationCoordinate2D) async throws -> String
    
    /// Starts monitoring location updates.
    /// 
    /// This method should be called when the app needs to track location changes.
    func startLocationUpdates()
    
    /// Stops monitoring location updates.
    /// 
    /// This method should be called when location tracking is no longer needed.
    func stopLocationUpdates()
}