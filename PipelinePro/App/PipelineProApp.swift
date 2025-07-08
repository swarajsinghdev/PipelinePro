//
//  PipelineProApp.swift
//  PipelinePro
//
//  Created by Swarajmeet Singh on 08/07/25.
//

import SwiftUI

/// The main entry point for the PipelinePro application.
/// 
/// This app provides a comprehensive pipeline management solution with mapping,
/// search, and location services capabilities.
@main
struct PipelineProApp: App {
    
    // MARK: - App Body
    
    var body: some Scene {
        WindowGroup {
            TabScene()
                .preferredColorScheme(.light)
        }
    }
}
