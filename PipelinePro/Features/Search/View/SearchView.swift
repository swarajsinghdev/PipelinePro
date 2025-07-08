//
//  SearchView.swift
//  PipelinePro
//
//  Created by Swarajmeet Singh on 08/07/25.
//

import SwiftUI
import MapKit

/// Allows searching for nearby places and dropping pins
struct SearchView: View {
    @State var viewModel: MapViewModel
    
    var body: some View {
        VStack {
            TextField("Search nearby...", text: $viewModel.searchQuery)
                .textFieldStyle(.roundedBorder)
                .padding()
                .onSubmit {
                    DispatchQueue.main.async {
                        Task { await viewModel.searchNearby() }
                    }
                }
            
            Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.searchResults) { place in
                MapAnnotation(coordinate: place.coordinate.clCoordinate) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(Constants.defaultPinSwiftUIColor)
                        .font(.title)
                }
            }
            .ignoresSafeArea()
            
            List(viewModel.searchResults) { place in
                VStack(alignment: .leading) {
                    Text(place.name)
                        .font(.headline)
                    Text(place.address)
                        .font(.subheadline)
                }
                .onTapGesture {
                    viewModel.selectPlace(place)
                }
            }
            .listStyle(.plain)
        }
    }
}
