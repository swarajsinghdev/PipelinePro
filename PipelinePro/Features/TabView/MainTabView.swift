//
//  MainTabView.swift
//  PipelinePro
//
//  Created by Swarajmeet Singh on 08/07/25.
//

import SwiftUI
import MapKit
import CoreLocation


// MARK: - Views

/// Main TabView containing three tabs for map, address, and search
struct MainTabView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var viewModel: MapViewModel
    
    init() {
        let locationManager = LocationManager()
        _locationManager = StateObject(wrappedValue: locationManager)
        _viewModel = State(wrappedValue: MapViewModel(locationService: locationManager))
    }
    
    
    var body: some View {
        TabView {
            MapView(viewModel: viewModel, locationManager: locationManager)
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            
//            AddressView(viewModel: viewModel, locationManager: locationManager)
//                .tabItem {
//                    Label("Address", systemImage: "house")
//                }
            
//            SearchView(viewModel: viewModel)
//                .tabItem {
//                    Label("Search", systemImage: "magnifyingglass")
//                }
        }
        .onAppear {
            viewModel.requestPermission()
        }
    }
}





// MARK: - Preview
#Preview {
    MainTabView()
}
