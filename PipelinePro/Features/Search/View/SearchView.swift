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
            
            Map {
                ForEach(viewModel.searchResults) { place in
                    Annotation(place.name, coordinate: place.coordinate.clCoordinate) {
                        VStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                                .font(.title2)
                            Text(place.name)
                                .font(.caption)
                                .padding(4)
                                .background(.ultraThinMaterial)
                                .cornerRadius(4)
                        }
                    }
                }
            }
            
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
