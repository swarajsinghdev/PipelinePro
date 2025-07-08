//
//  MainTabView.swift
//  PipelinePro
//
//  Created by Swarajmeet Singh on 08/07/25.
//

import SwiftUI
import MapKit
import CoreLocation

/// Main tab view containing the primary navigation structure of the application.
/// 
/// This view provides access to the three main features: Map, Address, and Search,
/// each represented as a separate tab with appropriate icons and labels.
struct MainTabView: View {
    
    // MARK: - Properties
    
    @State private var locationManager = LocationManager()
    @State private var mapViewModel: MapViewModel
    
    // MARK: - Initialization
    
    init() {
        let locationManager = LocationManager()
        self._locationManager = State(wrappedValue: locationManager)
        self._mapViewModel = State(wrappedValue: MapViewModel(locationService: locationManager))
    }
    
    // MARK: - Body
    
    var body: some View {
        TabView {
            MapView(viewModel: mapViewModel, locationManager: locationManager)
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            
            AddressView(viewModel: mapViewModel, locationManager: locationManager)
                .tabItem {
                    Label("Address", systemImage: "house")
                }
            
            SearchView(viewModel: mapViewModel)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
        .onAppear {
            setupLocationServices()
        }
    }
    
    // MARK: - Private Methods
    
    private func setupLocationServices() {
        DispatchQueue.main.async {
            locationManager.requestLocationPermission()
        }
    }
}

// MARK: - Preview

#Preview {
    MainTabView()
}
