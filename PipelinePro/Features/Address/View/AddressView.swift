//
//  AddressView.swift
//  PipelinePro
//
//  Created by Swarajmeet Singh on 08/07/25.
//

import SwiftUI
import CoreLocation

/// Displays the user's current location information including coordinates and address.
/// 
/// This view shows detailed location information in a user-friendly format,
/// with options to refresh the address and view coordinates.
struct AddressView: View {
    
    // MARK: - Properties
    
    @State var viewModel: MapViewModel
    @Bindable var locationManager: LocationManager
    @State private var isRefreshingAddress = false
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                locationSection
                actionSection
                Spacer(minLength: 0)
            }
            .padding()
        }
        .onAppear {
            refreshAddressIfNeeded()
        }
    }
    
    // MARK: - Private Views
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "location.circle.fill")
                .font(.system(size: 48))
                .foregroundColor(.blue)
            
            Text("Your Location")
                .font(.title)
                .fontWeight(.bold)
        }
    }
    
    private var locationSection: some View {
        VStack(spacing: 16) {
            if let coordinate = locationManager.currentLocation {
                coordinateInfoView(coordinate)
                addressInfoView
            } else {
                locationUnavailableView
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(Constants.defaultCornerRadius)
    }
    
    private func coordinateInfoView(_ coordinate: CLLocationCoordinate2D) -> some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "globe")
                    .foregroundColor(.secondary)
                Text("Coordinates")
                    .font(.headline)
                Spacer()
            }
            
            VStack(spacing: 8) {
                HStack {
                    Text("Latitude:")
                        .fontWeight(.medium)
                    Spacer()
                    Text("\(coordinate.latitude, specifier: "%.6f")")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Longitude:")
                        .fontWeight(.medium)
                    Spacer()
                    Text("\(coordinate.longitude, specifier: "%.6f")")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    private var addressInfoView: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "house")
                    .foregroundColor(.secondary)
                Text("Address")
                    .font(.headline)
                Spacer()
            }
            
            Text(viewModel.userAddress)
                .font(.body)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
        }
    }
    
    private var locationUnavailableView: some View {
        VStack(spacing: 12) {
            Image(systemName: "location.slash")
                .font(.title2)
                .foregroundColor(.secondary)
            
            Text("Location Unavailable")
                .font(.headline)
            
            Text("Please ensure location services are enabled and permissions are granted.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var actionSection: some View {
        VStack(spacing: 12) {
            Button(action: refreshAddress) {
                HStack {
                    if isRefreshingAddress {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "arrow.clockwise")
                    }
                    Text("Refresh Address")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(Constants.defaultCornerRadius)
            }
            .disabled(isRefreshingAddress || locationManager.currentLocation == nil)
            
            if locationManager.authorizationStatus == .denied {
                Button("Open Settings") {
                    openSettings()
                }
                .foregroundColor(.blue)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func refreshAddressIfNeeded() {
        if viewModel.userAddress == "Fetching address..." {
            refreshAddress()
        }
    }
    
    private func refreshAddress() {
        guard locationManager.currentLocation != nil else { return }
        
        isRefreshingAddress = true
        
        Task {
            await viewModel.updateUserAddress()
            await MainActor.run {
                isRefreshingAddress = false
            }
        }
    }
    
    private func openSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }
}

// MARK: - Preview

#Preview {
    AddressView(
        viewModel: MapViewModel(locationService: LocationManager()),
        locationManager: LocationManager()
    )
}
