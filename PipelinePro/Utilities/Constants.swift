//
//  Constants.swift
//  PipelinePro
//
//  Created by Swarajmeet Singh on 08/07/25.
//

import Foundation
import MapKit
import UIKit
import SwiftUI

/// Constants used across the app
public enum Constants {
    static let defaultRegionSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    static let defaultSearchRadius: Double = 1000 // Meters
    static let defaultPinColor = UIColor.systemBlue
    static let defaultPinSwiftUIColor = Color(.systemBlue)
}