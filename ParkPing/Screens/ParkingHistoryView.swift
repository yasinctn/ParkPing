//
//  ParkingHistoryView.swift
//  ParkPing
//
//  Created by Yasin Cetin on 18.09.2025.
//

import SwiftUI

struct ParkingHistoryView: View {
    
    @StateObject private var viewModel = ParkingViewModel()
    
    var body: some View {
        NavigationStack{
            
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
                
                VStack{
                    RecentParkingCard(parkingSpot: viewModel.mostRecentSpot)
                        .padding()
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
                    }.onAppear {
                        Task { 
                            await viewModel.refreshParkingSpots()
                        }
                    }
                    .refreshable {
                        await viewModel.refreshParkingSpots()
                    }
                    .listStyle(.plain)
                    .frame(height: CGFloat(min(viewModel.parkingSpots.count, 5) * 80))
                    
                    
                    Spacer()
                }
            }
            
        }
    }
}


#Preview {
    ParkingHistoryView()
}
