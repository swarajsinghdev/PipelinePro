//
//  MapViewModel.swift
//  PipelinePro
//
//  Created by Swarajmeet Singh on 08/07/25.
//

import Foundation
import MapKit
import CoreLocation

/// View model for managing map-related state and logic.
/// 
/// This class handles the business logic for map interactions, location updates,
/// and search result management using the MVVM pattern.
@Observable
final class MapViewModel {
    
    // MARK: - Properties
    
    /// The current map region to display
    var region: MKCoordinateRegion
    
    /// The current search query entered by the user
    var searchQuery: String = ""
    
    /// The list of search results from location queries
    var searchResults: [Place] = []
    
    /// The currently selected place on the map
    var selectedPlace: Place?
    
    /// The user's current address, formatted for display
    private(set) var userAddress: String = "Fetching address..."
    
    /// Indicates whether location updates are currently active
    private(set) var isLocationUpdatesActive = false
    
    // MARK: - Dependencies
    
    private let locationService: LocationService
    private var locationUpdateTimer: Timer?
    
    // MARK: - Initialization
    
    /// Creates a new map view model with the specified location service.
    /// 
    /// - Parameter locationService: The service responsible for location functionality
    init(locationService: LocationService) {
        self.locationService = locationService
        
        // Initialize with a default region (San Francisco)
        let defaultCoordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        self.region = MKCoordinateRegion(
            center: defaultCoordinate,
            span: Constants.defaultRegionSpan
        )
        
        // Update to user location if available
        updateToUserLocationIfAvailable()
    }
    
    // MARK: - Public Methods
    
    /// Updates the map region to show the user's current location.
    func updateToUserLocation() {
        guard let coordinate = locationService.currentLocation else { return }
        
        region = MKCoordinateRegion(
            center: coordinate,
            span: Constants.defaultRegionSpan
        )
    }
    
    /// Starts monitoring location updates.
    func startLocationUpdates() {
        locationService.startLocationUpdates()
        isLocationUpdatesActive = true
    }
    
    /// Stops monitoring location updates.
    func stopLocationUpdates() {
        locationService.stopLocationUpdates()
        locationUpdateTimer?.invalidate()
        locationUpdateTimer = nil
        isLocationUpdatesActive = false
    }
    
    /// Updates the user's address based on current location.
    func updateUserAddress() async {
        guard let coordinate = locationService.currentLocation else { return }
        
        do {
            let address = try await locationService.getAddress(from: coordinate)
            await MainActor.run {
                self.userAddress = address
            }
        } catch {
            await MainActor.run {
                self.userAddress = "Address unavailable"
            }
            print("Failed to get address: \(error)")
        }
    }
    
    /// Selects a place and updates the map region to focus on it.
    /// 
    /// - Parameter place: The place to select and focus on
    func selectPlace(_ place: Place) {
        selectedPlace = place
        region = MKCoordinateRegion(
            center: place.clCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
    }
    
    /// Clears the current search results.
    func clearSearchResults() {
        searchResults.removeAll()
        selectedPlace = nil
    }
    
    // MARK: - Private Methods
    
    /// Updates to user location if available, using a non-blocking timer approach.
    private func updateToUserLocationIfAvailable() {
        // Check immediately first
        if let coordinate = locationService.currentLocation {
            self.region = MKCoordinateRegion(
                center: coordinate,
                span: Constants.defaultRegionSpan
            )
            return
        }
        
        // If not available, set up a timer to check periodically
        var timerCount = 0
        locationUpdateTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            timerCount += 1
            
            if let coordinate = self.locationService.currentLocation {
                self.region = MKCoordinateRegion(
                    center: coordinate,
                    span: Constants.defaultRegionSpan
                )
                timer.invalidate()
            }
            
            // Stop checking after 10 seconds to avoid infinite timer
            if timerCount >= 20 {
                timer.invalidate()
            }
        }
    }
    
    // MARK: - Cleanup
    
    deinit {
        stopLocationUpdates()
    }
}
