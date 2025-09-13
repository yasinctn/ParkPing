//
//  ParkingDetailView.swift
//  ParkPing
//
//  Created by Yasin Cetin on 11.09.2025.
//

import SwiftUI
import MapKit
import CoreLocation

struct ParkingDetailView: View {
    let parkingSpot: ParkingSpotEntity
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ParkingDetailViewModel()
    @StateObject private var deletionCoordinator = DeletionCoordinator()
    
    @MainActor
        private func handleDelete() async {
            HapticManager.shared.notification(.warning)
            
            let success = await deletionCoordinator.deleteParkingSpot(with: parkingSpot.objectID)
            
            if success {
                // Sadece başarılı silme işleminden sonra dismiss et
                dismiss()
            }
            // Error durumunda alert otomatik gösterilecek
        }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
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
                
                VStack(spacing: 0) {
                    // Custom Navigation Bar
                    HStack {
                        Button {
                            HapticManager.shared.selection()
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.primary)
                                .frame(width: 44, height: 44)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                        
                        Text("Parking Details")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    // Map Section
                    VStack(spacing: 16) {
                        // Map
                        ZStack {
                            MapView(
                                parkingSpot: parkingSpot,
                                onDirectionsTap: {
                                    HapticManager.shared.impact(.medium)
                                    viewModel.openDirections(to: parkingSpot)
                                }
                            )
                            .frame(height: geometry.size.height * 0.45)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.white.opacity(0.1), lineWidth: 1)
                            )
                            
                            // Directions Button Overlay
                            VStack{
                                Spacer()
                                HStack {
                                    Spacer()
                                    
                                    DirectionsButton {
                                        HapticManager.shared.impact(.medium)
                                        viewModel.openDirections(to: parkingSpot)
                                    }.padding(8)
                                }
                                .padding(8)
                            }
                            
                            
                        }
                        .padding(.horizontal, 20)
                        
                        // Details Section
                        ScrollView {
                            VStack(spacing: 16) {
                                // Main Info Card
                                ParkingInfoCard(parkingSpot: parkingSpot)
                                    .padding(.horizontal, 20)
                                
                                // Actions Section
                                ActionsSection(
                                    parkingSpot: parkingSpot,
                                    onEditTap: {
                                        // Future: Edit functionality
                                        HapticManager.shared.selection()
                                    },
                                    onDeleteTap: {
                                        viewModel.showDeleteAlert = true
                                    },
                                    onShareTap: {
                                        viewModel.shareLocation(parkingSpot)
                                    }
                                )
                                .padding(.horizontal, 20)
                                
                                // Location Details
                                LocationDetailsCard(parkingSpot: parkingSpot)
                                    .padding(.horizontal, 20)
                                
                                Spacer(minLength: 100)
                            }
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .alert("Delete Parking Spot", isPresented: $viewModel.showDeleteAlert) {
            Button("Delete", role: .destructive) {
                Task {
                    await handleDelete()
                }
            }
            Button("Cancel", role: .cancel) {
                HapticManager.shared.selection()
            }
        } message: {
            Text("Are you sure you want to delete this parking spot? This action cannot be undone.")
        }
        .sheet(isPresented: $viewModel.showShareSheet) {
            if let shareItem = viewModel.shareItem {
                ActivityViewController(activityItems: [shareItem])
            }
        }
    }
}

struct ActionsSection: View {
    let parkingSpot: ParkingSpotEntity
    let onEditTap: () -> Void
    let onDeleteTap: () -> Void
    let onShareTap: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Actions")
                .font(.headline)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 12) {
                ActionButton(
                    icon: "pencil",
                    title: "Edit",
                    color: .blue,
                    action: onEditTap
                )
                
                ActionButton(
                    icon: "square.and.arrow.up",
                    title: "Share",
                    color: .green,
                    action: onShareTap
                )
                
                ActionButton(
                    icon: "trash",
                    title: "Delete",
                    color: .red,
                    action: onDeleteTap
                )
            }
        }
    }
}

struct ActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
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
}

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

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.trailing)
        }
    }
}
