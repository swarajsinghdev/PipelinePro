//
//  MapView.swift
//  PipelinePro
//
//  Created by Swarajmeet Singh on 08/07/25.
//

import SwiftUI
import MapKit

/// Displays the map with current location
struct MapView: View {
    @ObservedObject var viewModel: MapViewModel
    @ObservedObject var locationManager: LocationManager
    
    var body: some View {
        Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
            .ignoresSafeArea()
            .overlay {
                if locationManager.authorizationStatus == .notDetermined {
                    Text("Please allow location access")
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(8)
                }
            }
    }
}
