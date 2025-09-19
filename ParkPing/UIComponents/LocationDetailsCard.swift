//
//  LocationDetailsCard.swift
//  ParkPing
//
//  Created by Yasin Cetin on 18.09.2025.
//

import SwiftUI

struct LocationDetailsCard: View {
    @ObservedObject var parkingSpot: ParkingSpotEntity
    
    // MARK: - Validity check
    private var isValid: Bool {
        parkingSpot.managedObjectContext != nil && !parkingSpot.isDeleted
    }
    
    // MARK: - Safe accessors
    private var safeTimestamp: Date? {
        guard isValid else { return nil }
        return parkingSpot.timestamp
    }
    
    private var safeCoordinates: String? {
        guard isValid else { return nil }
        return String(format: "%.6f, %.6f", parkingSpot.latitude, parkingSpot.longitude)
    }
    
    private var safeAddress: String? {
        guard isValid else { return nil }
        return parkingSpot.address
    }
    
    private var formattedDate: String {
        guard let date = safeTimestamp else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    // MARK: - Body
    var body: some View {
        Group {
            if isValid {
                content
            } else {
                EmptyView().frame(height: 0)
            }
        }
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Location Details")
                .font(.headline)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                if let coords = safeCoordinates {
                    DetailRow(
                        icon: "location",
                        title: "Coordinates",
                        value: coords
                    )
                }
                
                if !formattedDate.isEmpty {
                    DetailRow(
                        icon: "clock",
                        title: "Saved",
                        value: formattedDate
                    )
                }
                
                if let address = safeAddress, !address.isEmpty {
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
