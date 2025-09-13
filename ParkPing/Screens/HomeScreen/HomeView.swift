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
                        Text("ParkSpot")
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
                    
                    
                    // History Section
                    HStack {
                        Text("Parking History")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text("\(viewModel.parkingSpots.count) spots")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                    }
                    .padding(.horizontal, 20)
                    
                    
                    List {
                        ForEach(viewModel.parkingSpots.prefix(3)) { spot in
                            
                            ParkingHistoryCard(parkingSpot: spot)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 4, leading: 20, bottom: 4, trailing: 20))
                        }
                        .onDelete { indexSet in
                            Task {
                                await viewModel.deleteMultipleParkingSpots(at: indexSet)
                            }
                        }
                    }
                    .refreshable {
                        await viewModel.refreshParkingSpots()
                    }
                    .listStyle(.plain)
                    .frame(height: CGFloat(min(viewModel.parkingSpots.count, 5) * 80))
                    
                    
                    Spacer()
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

