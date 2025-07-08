//
//  LocationManager.swift
//  PipelinePro
//
//  Created by Swarajmeet Singh on 08/07/25.
//

import Foundation
import CoreLocation
import MapKit

/// Manages location-related functionality
final class LocationManager: NSObject, LocationService, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published private(set) var currentLocation: Coordinate?
    @Published private(set) var authorizationStatus: CLAuthorizationStatus
    
    override init() {
        authorizationStatus = manager.authorizationStatus
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocationPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
    
    /// Retrieves address for a given coordinate
    func getAddress(from coordinate: Coordinate) async throws -> String {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        guard let placemark = placemarks.first else { return "Unknown address" }
        return placemark.formattedAddress
    }
    
    deinit {
        manager.stopUpdatingLocation()
    }
}

extension CLPlacemark {
    var formattedAddress: String {
        [subThoroughfare, thoroughfare, locality, administrativeArea, postalCode]
            .compactMap { $0 }
            .joined(separator: ", ")
    }
}