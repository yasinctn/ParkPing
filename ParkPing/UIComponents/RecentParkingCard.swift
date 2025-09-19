//
//  RecentParkingCard.swift
//  ParkPing
//
//  Created by Yasin Cetin on 10.09.2025.
//

import SwiftUI

struct RecentParkingCard: View {
    @ObservedObject var parkingSpot: ParkingSpotEntity
    
    private var isValid: Bool {
        parkingSpot.managedObjectContext != nil && !parkingSpot.isDeleted
    }

    private var formattedDate: String {
        guard isValid else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: parkingSpot.timestamp)
    }
    
    private var timeAgo: String {
        guard isValid else { return "" }
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        return formatter.localizedString(for: parkingSpot.timestamp, relativeTo: Date())
    }
    
    var body: some View {
        NavigationLink {
            if isValid {
                ParkingDetailView(parkingSpot: parkingSpot)
            } else {
                EmptyStateView()
            }
            
        } label: {
            VStack(spacing: 0) {
                // Header Section
                headerView
                
                // Content Section
               
                contentView(spot: parkingSpot)
                
            }
            .background(glassBackground)
            .overlay(borderOverlay)
            .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 8)
        }

        
      
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack(spacing: 12) {
            // Icon with gradient background
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.green.opacity(0.8), .mint.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 32, height: 32)
                
                Image(systemName: "location.circle.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .semibold))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Recent Parking")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                
                Text(timeAgo)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
            }
            
            Spacer()
            
            // Action button
            Button(action: {
                // Navigate to map or parking details
            }) {
                Image(systemName: "arrow.up.right.circle.fill")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.8))
                    .background(Circle().fill(.ultraThinMaterial))
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 16)
    }
    
    // MARK: - Content View
    private func contentView(spot: ParkingSpotEntity) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Mini map placeholder (you can replace with actual Map)
            MapView(parkingSpot: spot)
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
            
            // Location details
            VStack(alignment: .leading, spacing: 8) {
                if let title = spot.title, !title.isEmpty {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                }
                
                if let address = spot.address, !address.isEmpty {
                    HStack(spacing: 6) {
                        Image(systemName: "mappin")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(address)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                }
                
                // Date badge
                HStack {
                    Text(formattedDate)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    Capsule()
                                        .stroke(.white.opacity(0.2), lineWidth: 0.5)
                                )
                        )
                    
                    Spacer()
                    
                    
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    
    // MARK: - Empty State
    
    
    // MARK: - Glass Background
    private var glassBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.ultraThinMaterial)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.1),
                                .white.opacity(0.05),
                                .clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
    }
    
    // MARK: - Border Overlay
    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(
                LinearGradient(
                    colors: [
                        .white.opacity(0.3),
                        .white.opacity(0.1),
                        .clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 1
            )
    }
}
