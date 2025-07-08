//
//  MapView.swift
//  PipelinePro
//
//  Created by Swarajmeet Singh on 08/07/25.
//

import SwiftUI
import MapKit

/// Displays an interactive map with current location and search results.
/// 
/// This view provides the primary mapping interface, showing the user's
/// current location and any selected search results as annotations.
struct MapView: View {
    
    // MARK: - Properties
    
    @State var viewModel: MapViewModel
    @Bindable var locationManager: LocationManager
    
    // MARK: - Body
    
    var body: some View {
        Map {
            UserAnnotation()
            
            ForEach(viewModel.searchResults) { place in
                Annotation(place.name, coordinate: place.clCoordinate) {
                    MapPinView(place: place)
                }
            }
        }
        .ignoresSafeArea()
        .overlay(alignment: .top) {
            locationPermissionOverlay
        }
        .onAppear {
            viewModel.startLocationUpdates()
        }
        .onDisappear {
            viewModel.stopLocationUpdates()
        }
    }
    
    // MARK: - Private Views
    
    @ViewBuilder
    private var locationPermissionOverlay: some View {
        if locationManager.authorizationStatus == .notDetermined {
            VStack {
                Text("Location Access Required")
                    .font(.headline)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(Constants.defaultCornerRadius)
                
                Text("Please allow location access to see your position on the map")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
        }
    }
}

// MARK: - Supporting Views

/// A custom pin view for map annotations.
struct MapPinView: View {
    
    let place: Place
    
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "mappin.circle.fill")
                .font(.title2)
                .foregroundColor(Constants.defaultPinSwiftUIColor)
            
            Text(place.name)
                .font(.caption)
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .background(.ultraThinMaterial)
                .cornerRadius(4)
        }
    }
}

// MARK: - Preview

#Preview {
    MapView(
        viewModel: MapViewModel(locationService: LocationManager()),
        locationManager: LocationManager()
    )
}
