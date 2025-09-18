//
//  ParkPingApp.swift
//  ParkPing
//
//  Created by Yasin Cetin on 10.09.2025.
//

import SwiftUI

@main
struct ParkPingApp: App {
    @StateObject private var viewModel = ParkingViewModel()
    
    init() {
        // Initialize location manager
        _ = LocationManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabBarView()
                .environmentObject(viewModel)
            
        }
    }
}
