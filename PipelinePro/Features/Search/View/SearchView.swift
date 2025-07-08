//
//  SearchView.swift
//  PipelinePro
//
//  Created by Swarajmeet Singh on 08/07/25.
//

import SwiftUI
import MapKit

/// Allows searching for nearby places and displaying results on a map.
/// 
/// This view provides a search interface with a text field for queries
/// and displays results both on a map and in a list format.
struct SearchScene: View {
    
    // MARK: - Properties
    
    @State var viewModel: MapViewModel
    @State private var isSearching = false
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            searchHeader
            searchResults
        }
        .onChange(of: viewModel.searchQuery) { _, newQuery in
            handleSearchQueryChange(newQuery)
        }
    }
    
    // MARK: - Private Views
    
    private var searchHeader: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search nearby places...", text: $viewModel.searchQuery)
                    .textFieldStyle(.plain)
                
                if !viewModel.searchQuery.isEmpty {
                    Button("Clear") {
                        viewModel.searchQuery = ""
                        viewModel.clearSearchResults()
                    }
                    .foregroundColor(.blue)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(Constants.defaultCornerRadius)
            .padding(.horizontal)
            
            if isSearching {
                ProgressView("Searching...")
                    .padding()
            }
        }
        .padding(.top)
    }
    
    private var searchResults: some View {
        VStack(spacing: 0) {
            if viewModel.searchResults.isEmpty && !viewModel.searchQuery.isEmpty {
                emptyStateView
            } else {
                resultsMap
                resultsList
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("No Results Found")
                .font(.headline)
            
            Text("Try adjusting your search terms or location")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var resultsMap: some View {
        Map {
            ForEach(viewModel.searchResults) { place in
                Annotation(place.name, coordinate: place.clCoordinate) {
                    SearchResultPinView(place: place)
                }
            }
        }
        .frame(height: 200)
    }
    
    private var resultsList: some View {
        List(viewModel.searchResults) { place in
            SearchResultRowView(place: place) {
                viewModel.selectPlace(place)
            }
        }
        .listStyle(.plain)
    }
}

// MARK: - Supporting Views

/// A custom pin view for search result annotations.
struct SearchResultPinView: View {
    
    let place: Place
    
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "mappin.circle.fill")
                .font(.title2)
                .foregroundColor(.red)
            
            Text(place.name)
                .font(.caption)
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .background(.ultraThinMaterial)
                .cornerRadius(4)
        }
    }
}

/// A row view for displaying search results in a list.
struct SearchResultRowView: View {
    
    let place: Place
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(place.name)
                .font(.headline)
                .lineLimit(1)
            
            Text(place.address)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

// MARK: - Private Methods

private extension SearchScene {
    
    func handleSearchQueryChange(_ query: String) {
        guard !query.isEmpty else {
            viewModel.clearSearchResults()
            isSearching = false
            return
        }
        
        // Simulate search functionality
        isSearching = true
        
        // In a real app, this would call an actual search service
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Simulate search results
            let mockResults = [
                Place(name: "Sample Location 1", address: "123 Main St", coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)),
                Place(name: "Sample Location 2", address: "456 Oak Ave", coordinate: CLLocationCoordinate2D(latitude: 37.7849, longitude: -122.4094))
            ]
            
            viewModel.searchResults = mockResults
            isSearching = false
        }
    }
}

// MARK: - Preview

#Preview {
    SearchScene(viewModel: MapViewModel(locationService: LocationManager()))
}
