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
    @ObservedObject var parkingSpot: ParkingSpotEntity
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ParkingDetailViewModel()
    
    private var isValid: Bool {
        parkingSpot.managedObjectContext != nil && !parkingSpot.isDeleted
    }
    
    @MainActor
    private func handleDelete() {
        HapticManager.shared.notification(.warning)
        do {
            try CoreDataManager.shared.delete(parkingSpot)
            // Silme tamamlandı → güvenle kapan
            dismiss()
        } catch {
            // Hata göstermek istersen burada alert state set edebilirsin
            print("Deletion failed: \(error)")
        }
    }
    
    var body: some View {
        // Silindikten sonra body içindeki hiçbir alt view, alanlara dokunmasın:
        if !isValid {
            // Otomatik kapanmayı garanti altına almak istersen:
            Color.clear.onAppear { dismiss() }
        } else {
            NavigationView {
                ZStack {
                    LinearGradient(
                        colors: [Color.black, Color.blue.opacity(0.1), Color.purple.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    
                    GeometryReader { geometry in
                        ScrollView {
                            VStack(spacing: 0) {
                                VStack(spacing: 16) {
                                    ZStack {
                                        MapView(parkingSpot: parkingSpot)
                                            .frame(height: geometry.size.height * 0.45)
                                            .clipShape(RoundedRectangle(cornerRadius: 20))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(.white.opacity(0.1), lineWidth: 1)
                                            )
                                        
                                        VStack {
                                            Spacer()
                                            HStack {
                                                Spacer()
                                                DirectionsButton {
                                                    HapticManager.shared.impact(.medium)
                                                    viewModel.openDirections(to: parkingSpot)
                                                }.padding(8)
                                            }.padding(8)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    
                                    VStack(spacing: 16) {
                                        ParkingInfoCard(parkingSpot: parkingSpot)
                                            .padding(.horizontal, 20)
                                        
                                        ActionsSection(
                                            parkingSpot: parkingSpot,
                                            onEditTap: {
                                                viewModel.beginEditing(parkingSpot: parkingSpot)
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
                                        
                                        LocationDetailsCard(parkingSpot: parkingSpot)
                                            .padding(.horizontal, 20)
                                        
                                        Spacer(minLength: 100)
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
            .navigationTitle(Txt.ParkingDetails.title)
            .alert(Txt.DeleteConfirm.title, isPresented: $viewModel.showDeleteAlert) {
                Button(Txt.Common.delete, role: .destructive) {
                    handleDelete() // ← async yok; ana context'te hızlı ve güvenli
                }
                Button(Txt.Common.cancel, role: .cancel) {
                    HapticManager.shared.selection()
                }
            } message: {
                Text(Txt.DeleteConfirm.message)
            }
            .sheet(isPresented: $viewModel.showShareSheet) {
                if let shareItem = viewModel.shareItem {
                    ActivityViewController(activityItems: [shareItem])
                }
            }
            .sheet(isPresented: $viewModel.isEditing) {
                EditParkingSheet(
                    title: $viewModel.editedTitle,
                    address: $viewModel.editedAddress,
                    onSave: {
                        viewModel.saveEdits(for: parkingSpot)
                    },
                    onCancel: {
                        viewModel.isEditing = false
                    }
                )
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
            Text(Txt.Common.actionsTitle)
                .font(.headline)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 12) {
                ActionButton(
                    icon: "pencil",
                    title: Txt.Common.edit,
                    color: .blue,
                    action: onEditTap
                )
                
                ActionButton(
                    icon: "square.and.arrow.up",
                    title: Txt.Common.share,
                    color: .green,
                    action: onShareTap
                )
                
                ActionButton(
                    icon: "trash",
                    title: Txt.Common.delete,
                    color: .red,
                    action: onDeleteTap
                )
            }
        }
    }
}



