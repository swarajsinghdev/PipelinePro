//
//  MapViewModel.swift
//  PipelinePro
//
//  Created by Swarajmeet Singh on 08/07/25.
//

import Foundation
import MapKit
import CoreLocation

// MARK: - View Models

/// View model for managing map-related state and logic
@Observable
final class MapViewModel {
    // MARK: - Published State / UI State
    var region: MKCoordinateRegion
    var searchQuery: String = ""
    var searchResults: [Place] = []
    var selectedPlace: Place?
    private(set) var userAddress: String = "Fetching address..."
    
    // MARK: - Injected Dependencies
    private let locationService: LocationService
    
    // MARK: - Initializers
    init(locationService: LocationService) {
        self.locationService = locationService
        let defaultCoordinate = Coordinate(latitude: 37.7749, longitude: -122.4194)
        self.region = MKCoordinateRegion(
            center: locationService.currentLocation ?? defaultCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }
    
    // MARK: - Public Methods
    
    /// Updates the map region to show the user's current location
    func updateToUserLocation() {
        if let coordinate = locationService.currentLocation {
            self.region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        }
    }
    
    /// Updates the user's address based on current location
    func updateUserAddress() async {
        if let coordinate = locationService.currentLocation {
            do {
                let address = try await locationService.getAddress(from: coordinate)
                await MainActor.run {
                    self.userAddress = address
                }
            } catch {
                print("Failed to get address: \(error)")
            }
        }
    }
    
    /// Selects a place and updates the map region
    func selectPlace(_ place: Place) {
        selectedPlace = place
        region = MKCoordinateRegion(
            center: place.coordinate.clCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
    }
}
