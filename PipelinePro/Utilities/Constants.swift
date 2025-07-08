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

/// Application-wide constants and configuration values.
/// 
/// This enum provides centralized access to commonly used values
/// throughout the application, ensuring consistency and maintainability.
public enum Constants {
    
    // MARK: - Map Configuration
    
    /// Default coordinate span for map regions
    static let defaultRegionSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    
    /// Default search radius in meters
    static let defaultSearchRadius: Double = 1000
    
    /// Default location accuracy for location services (optimized to reduce API calls)
    static let defaultLocationAccuracy: CLLocationAccuracy = kCLLocationAccuracyHundredMeters
    
    /// Minimum distance in meters before updating location (increased to reduce API calls)
    static let minimumLocationUpdateDistance: CLLocationDistance = 50
    
    /// Minimum time interval between location updates in seconds
    static let minimumLocationUpdateInterval: TimeInterval = 5.0
    
    /// Address update interval in seconds
    static let addressUpdateInterval: TimeInterval = 30.0
    
    // MARK: - UI Configuration
    
    /// Default pin color for map annotations
    static let defaultPinColor = UIColor.systemBlue
    
    /// Default pin color for SwiftUI map annotations
    static let defaultPinSwiftUIColor = Color(.systemBlue)
    
    /// Default animation duration for UI transitions
    static let defaultAnimationDuration: Double = 0.3
    
    /// Default corner radius for UI elements
    static let defaultCornerRadius: CGFloat = 8
    
    // MARK: - Network Configuration
    
    /// Default timeout for network requests in seconds
    static let defaultNetworkTimeout: TimeInterval = 30
    
    /// Maximum number of search results to display
    static let maxSearchResults = 20
}