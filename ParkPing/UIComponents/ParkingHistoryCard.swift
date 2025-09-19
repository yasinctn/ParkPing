//
//  ParkingHistoryCard.swift
//  ParkPing
//
//  Created by Yasin Cetin on 10.09.2025.
//

import SwiftUI

struct ParkingHistoryCard: View {
    @ObservedObject var parkingSpot: ParkingSpotEntity
    
    // Silinmiş/bağlamsız obje kontrolü
    private var isValid: Bool {
        parkingSpot.managedObjectContext != nil && !parkingSpot.isDeleted
    }
    
    private var safeTimestamp: Date? {
        guard isValid else { return nil }
        return parkingSpot.timestamp
    }
    
    private var safeTitle: String {
        guard isValid else { return "Parking Spot" }
        return parkingSpot.title?.isEmpty == false ? parkingSpot.title! : "Parking Spot"
    }
    
    private var safeAddress: String? {
        guard isValid else { return nil }
        return parkingSpot.address
    }

    private var formattedDate: String {
        guard let date = safeTimestamp else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var body: some View {
        // Objeyi her kullanım noktasında guard et
        if isValid {
            NavigationLink(destination: ParkingDetailView(parkingSpot: parkingSpot)) {
                rowContent
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
        } else {
            // Silme animasyonunda/yeniden yüklemede kısa süreliğine boş yer tutucu
            EmptyView().frame(height: 0)
        }
    }
    
    private var rowContent: some View {
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
                Text(safeTitle)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                if let address = safeAddress, !address.isEmpty {
                    Text(address)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                if !formattedDate.isEmpty {
                    Text(formattedDate)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 4, leading: 20, bottom: 4, trailing: 20))
    }
}
