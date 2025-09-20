//
//  HomeView.swift
//  ParkPing
//
//  Created by Yasin Cetin on 10.09.2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewModel: ParkingViewModel
    @StateObject private var locationManager = LocationManager.shared
    
    var body: some View {
        NavigationView {
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
                        Text(Txt.App.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text(Txt.App.tagline)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Recent Parking Section
                    if viewModel.parkingSpots.isEmpty {
                        EmptyStateView()
                            .padding()
                    }else {
                        
                        if let spot = viewModel.parkingSpots.first,!spot.isDeleted,
                           spot.managedObjectContext != nil {
                            RecentParkingCard(parkingSpot: spot)
                                .padding(10)
                        } else {
                            EmptyStateView()
                                .padding(10)
                        }
                    }
                    
                    // Main Save Button
                    GlassmorphicButton(
                        title: Txt.Home.saveParkingLocation,
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
            .alert(Txt.Alerts.locationError, isPresented: .constant(locationManager.locationError != nil)) {
                Button(Txt.Common.settings) {
                    locationManager.openLocationSettings()
                }
                Button(Txt.Common.ok) {
                    locationManager.locationError = nil
                }
            } message: {
                Text(locationManager.locationError?.errorDescription ?? "")
            }
            .alert(Txt.Alerts.locationPermission, isPresented: .constant(locationManager.authorizationStatus == .denied)) {
                Button(Txt.Common.settings) {
                    locationManager.openLocationSettings()
                }
                Button(Txt.Common.cancel, role: .cancel) {}
            } message: {
                Text(Txt.Alerts.locationPermissionMessage)
            }
        }
    }
}

