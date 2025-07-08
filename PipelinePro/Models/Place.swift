//
//  Place.swift
//  PipelinePro
//
//  Created by Swarajmeet Singh on 08/07/25.
//

import Foundation

// MARK: - Codable Structs

/// Represents a place result from a map search
struct Place: Identifiable {
    let id: UUID
    let name: String
    let address: String
    let coordinate: CoordinateCodable
    
    private enum CodingKeys: String, CodingKey {
        case name = "place_name"
        case address = "formatted_address"
        case coordinate = "location"
    }
    
    init(name: String, address: String, coordinate: CoordinateCodable) {
        self.id = UUID()
        self.name = name
        self.address = address
        self.coordinate = coordinate
    }
}
