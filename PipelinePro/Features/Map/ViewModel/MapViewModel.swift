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
        let defaultCoordinate = Coordinate(latitude: 37.7749, longitude: -122.4194) // San Francisco
        self.region = MKCoordinateRegion(
            center: locationService.currentLocation ?? defaultCoordinate,
            span: Constants.defaultRegionSpan
        )
    }
    
    // MARK: - Public API Methods
    /// Requests location permission
    func requestPermission() {
        locationService.requestLocationPermission()
    }
    
    /// Performs a search for nearby places
    func searchNearby() async {
        guard !searchQuery.isEmpty, let location = locationService.currentLocation else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchQuery
        request.region = MKCoordinateRegion(
            center: location,
            latitudinalMeters: Constants.defaultSearchRadius,
            longitudinalMeters: Constants.defaultSearchRadius
        )
        
        do {
            let search = MKLocalSearch(request: request)
            let response = try await search.start()
            await MainActor.run {
                searchResults = response.mapItems.map { item in
                    Place(
                        name: item.name ?? "Unknown",
                        address: item.placemark.formattedAddress,
                        coordinate: CoordinateCodable(
                            latitude: item.placemark.coordinate.latitude,
                            longitude: item.placemark.coordinate.longitude
                        )
                    )
                }
            }
        } catch {
            print("Search error: \(error.localizedDescription)")
        }
    }
    
    /// Selects a place and updates the map region
    func selectPlace(_ place: Place) {
        selectedPlace = place
        region = MKCoordinateRegion(
            center: place.coordinate.clCoordinate,
            span: Constants.defaultRegionSpan
        )
    }
    
    /// Updates the map region to the current location
    func updateToCurrentLocation() {
        guard let location = locationService.currentLocation else { return }
        region = MKCoordinateRegion(center: location, span: Constants.defaultRegionSpan)
        Task { await updateUserAddress() }
    }
    
    // MARK: - Internal Logic / Helpers
    @MainActor
    private func updateUserAddress() async {
        guard let coordinate = locationService.currentLocation else { return }
        do {
            userAddress = try await locationService.getAddress(from: coordinate)
        } catch {
            userAddress = "Unable to fetch address"
        }
    }
}
