//
//  LocationManager.swift
//  PipelinePro
//
//  Created by Swarajmeet Singh on 08/07/25.
//

import Foundation
import CoreLocation
import MapKit

/// Manages location-related functionality including permissions, updates, and geocoding.
/// 
/// This class implements the LocationService protocol and provides a concrete
/// implementation for handling device location services.
@Observable
final class LocationManager: NSObject, LocationService, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    /// The current location of the device, if available
    private(set) var currentLocation: CLLocationCoordinate2D?
    
    /// The current authorization status for location services
    private(set) var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    /// Indicates whether location updates are currently active
    private(set) var isLocationUpdatesActive = false
    
    // MARK: - Private Properties
    
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    // MARK: - Setup
    
    private func setupLocationManager() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 10 // Only update if moved 10 meters
        
        // Defer the authorization status check to avoid publishing during init
        DispatchQueue.main.async {
            self.authorizationStatus = self.manager.authorizationStatus
        }
    }
    
    // MARK: - LocationService Implementation
    
    func requestLocationPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func startLocationUpdates() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            requestLocationPermission()
            return
        }
        
        manager.startUpdatingLocation()
        isLocationUpdatesActive = true
    }
    
    func stopLocationUpdates() {
        manager.stopUpdatingLocation()
        isLocationUpdatesActive = false
    }
    
    func getAddress(from coordinate: CLLocationCoordinate2D) async throws -> String {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            guard let placemark = placemarks.first else { 
                return "Unknown address" 
            }
            return placemark.formattedAddress
        } catch {
            throw LocationError.geocodingFailed(error)
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorizationStatus = status
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                self.startLocationUpdates()
            } else {
                self.stopLocationUpdates()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Only update if location has changed significantly
        if let current = currentLocation {
            let distance = location.distance(from: CLLocation(latitude: current.latitude, longitude: current.longitude))
            if distance < 10 { return } // Don't update if moved less than 10 meters
        }
        
        DispatchQueue.main.async {
            self.currentLocation = location.coordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
    
    // MARK: - Cleanup
    
    deinit {
        stopLocationUpdates()
    }
}

// MARK: - Error Types

enum LocationError: LocalizedError {
    case geocodingFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .geocodingFailed(let error):
            return "Failed to get address: \(error.localizedDescription)"
        }
    }
}

// MARK: - Helper Extensions

extension CLPlacemark {
    
    /// Returns a formatted address string from the placemark components.
    var formattedAddress: String {
        [subThoroughfare, thoroughfare, locality, administrativeArea, postalCode]
            .compactMap { $0 }
            .joined(separator: ", ")
    }
}