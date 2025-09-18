//
//  LocationDetailsCard.swift
//  ParkPing
//
//  Created by Yasin Cetin on 18.09.2025.
//

import SwiftUI

struct LocationDetailsCard: View {
    let parkingSpot: ParkingSpotEntity?
    
    private var formattedDate: String {
        guard let spot = parkingSpot else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: spot.timestamp)
    }
    private var coordinatesString: String {
        String(format: "%.6f, %.6f", parkingSpot!.latitude, parkingSpot?.longitude ?? 0.000)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Location Details")
                .font(.headline)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                DetailRow(
                    icon: "location",
                    title: "Coordinates",
                    value: coordinatesString
                )
                
                DetailRow(
                    icon: "clock",
                    title: "Saved",
                    value: formattedDate
                )
                
                if let address = parkingSpot?.address {
                    DetailRow(
                        icon: "mappin.circle",
                        title: "Address",
                        value: address
                    )
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
