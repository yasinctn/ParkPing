//
//  ParkingInfoCard.swift
//  ParkPing
//
//  Created by Yasin Cetin on 11.09.2025.
//

import SwiftUI

struct ParkingInfoCard: View {
    @ObservedObject var parkingSpot: ParkingSpotEntity
    
    // Silinmiş/bağlamsız obje güvenlik kontrolü
    private var isValid: Bool {
        parkingSpot.managedObjectContext != nil && !parkingSpot.isDeleted
    }
    
    // Güvenli alan erişimleri
    private var safeTimestamp: Date? {
        guard isValid else { return nil }
        return parkingSpot.timestamp
    }
    
    private var safeTitle: String {
        guard isValid else { return Txt.ParkingSpot.defaultTitle }
        return (parkingSpot.title?.isEmpty == false ? parkingSpot.title! : Txt.ParkingSpot.defaultTitle)
    }
    
    private var safeAddress: String? {
        guard isValid else { return nil }
        return parkingSpot.address
    }
    
    private var formattedDate: String {
        guard let date = safeTimestamp else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var body: some View {
        Group {
            if isValid {
                content
            } else {
                // Silme/merge anında kısa süreliğine görünmesin
                EmptyView().frame(height: 0)
            }
        }
    }
    
    private var content: some View {
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
                    Text(safeTitle)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    if !formattedDate.isEmpty {
                        Text(Txt.Common.savedOn(formattedDate))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
            
            if let address = safeAddress, !address.isEmpty {
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
