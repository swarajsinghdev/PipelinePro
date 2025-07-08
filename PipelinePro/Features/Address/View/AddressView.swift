//
//  AddressView.swift
//  PipelinePro
//
//  Created by Swarajmeet Singh on 08/07/25.
//

import SwiftUI

/// Displays user's address and coordinates
struct AddressView: View {
    @State var viewModel: MapViewModel
    @ObservedObject var locationManager: LocationManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Your Location")
                .font(.title)
                .bold()
            
            if let coordinate = locationManager.currentLocation {
                Text("Latitude: \(coordinate.latitude, specifier: "%.4f")")
                Text("Longitude: \(coordinate.longitude, specifier: "%.4f")")
                Text("Address: \(viewModel.userAddress)")
            } else {
                Text("Location unavailable")
            }
            
            Spacer()
        }
        .padding()
    }
}
