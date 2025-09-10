//
//  HomeView.swift
//  ParkPing
//
//  Created by Yasin Cetin on 10.09.2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = ParkingViewModel()
    
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
                
                ScrollView {
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
                        
                        // Main Save Button
                        GlassmorphicButton(
                            title: "Save Parking Location",
                            action: {
                                HapticManager.shared.impact(.medium)
                                viewModel.saveParkingLocation()
                            },
                            isLoading: viewModel.isLoading
                        )
                        .padding(.horizontal, 20)
                        
                        // Recent Parking Section
                        RecentParkingCard(parkingSpot: viewModel.mostRecentSpot)
                            .padding(.horizontal, 20)
                        
                        // History Section
                        if !viewModel.parkingSpots.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
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
                                
                                LazyVStack(spacing: 8) {
                                    ForEach(viewModel.parkingSpots.prefix(5)) { spot in
                                        ParkingHistoryCard(parkingSpot: spot)
                                            .padding(.horizontal, 20)
                                            .onTapGesture {
                                                HapticManager.shared.selection()
                                                // Future: Navigate to detail view
                                            }
                                    }
                                }
                                
                                if viewModel.parkingSpots.count > 5 {
                                    Button("View All History") {
                                        // Future: Navigate to full history
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                    .padding(.horizontal, 20)
                                    .padding(.top, 8)
                                }
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                }
                .refreshable {
                    HapticManager.shared.selection()
                    // Future: Refresh data
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
        }
    }
}

