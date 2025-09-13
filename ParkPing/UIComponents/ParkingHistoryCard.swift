//
//  ParkingHistoryCard.swift
//  ParkPing
//
//  Created by Yasin Cetin on 10.09.2025.
//

import SwiftUI

struct ParkingHistoryCard: View {
    let parkingSpot: ParkingSpotEntity
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: parkingSpot.timestamp)
    }
    
    var body: some View {
        NavigationLink(destination: ParkingDetailView(parkingSpot: parkingSpot)){
            HStack(spacing: 16) {
                // Location icon with gradient background
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "car")
                        .foregroundColor(.primary)
                        .font(.system(size: 18, weight: .medium))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(parkingSpot.title ?? "Parking Spot")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    if let address = parkingSpot.address {
                        Text(address)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    
                    Text(formattedDate)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.regularMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.white.opacity(0.05), lineWidth: 1)
        )
    }
}
