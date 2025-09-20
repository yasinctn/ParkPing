//
//  ParkingHistoryView.swift
//  ParkPing
//
//  Created by Yasin Cetin on 18.09.2025.
//

import SwiftUI
import CoreData

struct ParkingHistoryView: View {
    @EnvironmentObject private var viewModel: ParkingViewModel
    
    // Silinmiş/bağlamsız objeyi filtrele
    private var recentSpot: ParkingSpotEntity? {
        guard let spot = viewModel.parkingSpots.first,
              spot.managedObjectContext != nil,
              !spot.isDeleted else { return nil }
        return spot
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.black, Color.blue.opacity(0.1), Color.purple.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Kayıt yoksa Empty state (opsiyonel)
                if viewModel.parkingSpots.isEmpty {
                    Section {
                        EmptyStateView()
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    }
                }else {
                    
                    VStack {
                        if let spot = recentSpot {
                            RecentParkingCard(parkingSpot: spot)
                                .padding(10)
                        }
                        HStack {
                            Text(Txt.ParkingHistory.title) // "Parking History" / "Park Geçmişi"
                            Spacer()
                            Text(Txt.Common.spotsCount(viewModel.parkingSpots.count))
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.ultraThinMaterial)
                                .clipShape(Capsule())
                        }.padding(12)
                        
                        List {
                            ForEach(viewModel.parkingSpots, id: \.objectID) { spot in
                                ParkingHistoryCard(parkingSpot: spot)
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                                    .listRowInsets(EdgeInsets(top: 4, leading: 10, bottom: 4, trailing: 10))
                            }
                            .onDelete { indexSet in
                                Task {
                                    for index in indexSet {
                                        let spot = viewModel.parkingSpots[index]
                                        await viewModel.deleteParkingSpot(spot)
                                    }
                                }
                            }
                        }.frame(height: CGFloat(max(100, viewModel.parkingSpots.count * 100)))
                            .listStyle(.plain)
                            .onAppear { Task { await viewModel.refreshParkingSpots() } }
                            .refreshable { await viewModel.refreshParkingSpots() }
                            .modifier(ScrollBGClearIfAvailable())
                    }
                    
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// iOS 16+: List/Form arka planını şeffaf yap, iOS 15’te zarifçe yok say
private struct ScrollBGClearIfAvailable: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .scrollContentBackground(.hidden)
                .background(Color.clear)
        } else {
            content.background(Color.clear)
        }
    }
}

