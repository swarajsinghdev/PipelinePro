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
    private var lastLocationUpdateTime: Date = Date.distantPast
    private let minimumLocationUpdateInterval: TimeInterval = 5.0 // Minimum 5 seconds between updates
    private var geocodingTask: Task<Void, Never>?
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    // MARK: - Setup
    
    private func setupLocationManager() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters // Reduced accuracy to reduce API calls
        manager.distanceFilter = 50 // Only update if moved 50 meters (increased from 10)
        manager.allowsBackgroundLocationUpdates = false
        
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
        // Prevent duplicate start calls
        guard !isLocationUpdatesActive else { return }
        
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            requestLocationPermission()
            return
        }
        
        manager.startUpdatingLocation()
        isLocationUpdatesActive = true
    }
    
    func stopLocationUpdates() {
        guard isLocationUpdatesActive else { return }
        
        manager.stopUpdatingLocation()
        isLocationUpdatesActive = false
        
        // Cancel any ongoing geocoding tasks
        geocodingTask?.cancel()
        geocodingTask = nil
    }
    
    func getAddress(from coordinate: CLLocationCoordinate2D) async throws -> String {
        // Cancel any existing geocoding task
        geocodingTask?.cancel()
        
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
            // Don't automatically start location updates on authorization change
            // Let the app explicitly request location updates when needed
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Throttle location updates to prevent excessive API calls
        let now = Date()
        guard now.timeIntervalSince(lastLocationUpdateTime) >= minimumLocationUpdateInterval else {
            return
        }
        
        // Only update if location has changed significantly
        if let current = currentLocation {
            let distance = location.distance(from: CLLocation(latitude: current.latitude, longitude: current.longitude))
            if distance < 50 { return } // Don't update if moved less than 50 meters
        }
        
        DispatchQueue.main.async {
            self.currentLocation = location.coordinate
            self.lastLocationUpdateTime = now
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
        
        // Stop location updates on error to prevent continuous retries
        if let clError = error as? CLError {
            switch clError.code {
            case .denied, .locationUnknown:
                stopLocationUpdates()
            default:
                break
            }
        }
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