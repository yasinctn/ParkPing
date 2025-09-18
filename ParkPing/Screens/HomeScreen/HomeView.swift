//
//  HomeView.swift
//  ParkPing
//
//  Created by Yasin Cetin on 10.09.2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = ParkingViewModel()
    @StateObject private var locationManager = LocationManager.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color.black,
                        Color.blue.opacity(0.1),
                        Color.purple.opacity(0.05)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("ParkPing")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("Never lose your car again")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Recent Parking Section
                    RecentParkingCard(parkingSpot: viewModel.mostRecentSpot)
                        .padding(.horizontal, 20)
                    
                    // Main Save Button
                    GlassmorphicButton(
                        title: "Save Parking Location",
                        action: {
                            HapticManager.shared.impact(.medium)
                            
                            // Check location permission first
                            if !locationManager.isAuthorized {
                                locationManager.requestLocationPermission()
                            } else {
                                viewModel.saveParkingLocation()
                            }
                        },
                        isLoading: viewModel.isLoading
                    )
                    .padding(.horizontal, 20)
                    
                }
                // Toast Notification
                VStack {
                    Spacer()
                    
                    if viewModel.showToast {
                        ToastView(message: viewModel.toastMessage, isShowing: $viewModel.showToast)
                            .padding(.bottom, 50)
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear(perform: {
                viewModel.refreshData()
            })
            .alert("Location Error", isPresented: .constant(locationManager.locationError != nil)) {
                Button("Settings") {
                    locationManager.openLocationSettings()
                }
                Button("OK") {
                    locationManager.locationError = nil
                }
            } message: {
                Text(locationManager.locationError?.errorDescription ?? "")
            }
            .alert("Location Permission", isPresented: .constant(locationManager.authorizationStatus == .denied)) {
                Button("Settings") {
                    locationManager.openLocationSettings()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("ParkPing needs location access to save your parking spots. Please enable location services in Settings.")
            }
        }
    }
}

