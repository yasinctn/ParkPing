//
//  ParkingInfoCard.swift
//  ParkPing
//
//  Created by Yasin Cetin on 11.09.2025.
//

import SwiftUI

// MARK: - Detail Cards
struct ParkingInfoCard: View {
    let parkingSpot: ParkingSpotEntity
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter.string(from: parkingSpot.timestamp)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "car.fill")
                        .foregroundColor(.primary)
                        .font(.title2)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(parkingSpot.title ?? "Parking Spot")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Saved on \(formattedDate)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            if let address = parkingSpot.address {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.blue)
                    
                    Text(address)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.regularMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.white.opacity(0.1), lineWidth: 1)
        )
    }
}
