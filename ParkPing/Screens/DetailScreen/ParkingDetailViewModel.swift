//
//  ParkingDetailViewModel.swift
//  ParkPing
//
//  Created by Yasin Cetin on 11.09.2025.
//

import SwiftUI
import MapKit

@MainActor
final class ParkingDetailViewModel: ObservableObject {
    @Published var showDeleteAlert = false
    @Published var showShareSheet = false
    @Published var shareItem: String?
    
    @Published var isEditing = false
    @Published var editedTitle: String = ""
    @Published var editedAddress: String = ""
    
    func openDirections(to parkingSpot: ParkingSpotEntity, preferredApp: String) {
        let coordinate = CLLocationCoordinate2D(
            latitude: parkingSpot.latitude,
            longitude: parkingSpot.longitude
        )
        let name = parkingSpot.title ?? "Parking Spot"

        if preferredApp == Txt.RoutingApps.googleMaps {
            // Google Maps tercih edilmiş
            let daddr = "\(coordinate.latitude),\(coordinate.longitude)"
            let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

            // Önce uygulama scheme'i deneyelim
            if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
                let urlString = "comgooglemaps://?daddr=\(daddr)&directionsmode=driving&q=\(encodedName)"
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url)
                    return
                }
            }

            // Fallback: Web
            let webString = "https://www.google.com/maps/dir/?api=1&destination=\(daddr)&travelmode=driving&destination_place_id=\(encodedName)"
            if let url = URL(string: webString) {
                UIApplication.shared.open(url)
                return
            }
        }

        // Apple Maps (default)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
    
    func shareLocation(_ parkingSpot: ParkingSpotEntity) {
        let title = parkingSpot.title ?? "Parking Spot"
        let coordinates = String(format: "%.6f, %.6f", parkingSpot.latitude, parkingSpot.longitude)
        let address = parkingSpot.address ?? "Location coordinates"
        
        let shareText = """
        📍 \(title)
        
        Address: \(address)
        Coordinates: \(coordinates)
        
        https://maps.apple.com/?ll=\(parkingSpot.latitude),\(parkingSpot.longitude)
        """
        
        shareItem = shareText
        showShareSheet = true
    }
    
    // Edit işlemi başlatılırken mevcut veriler doldurulsun
    func beginEditing(parkingSpot: ParkingSpotEntity) {
        editedTitle = parkingSpot.title ?? ""
        editedAddress = parkingSpot.address ?? ""
        isEditing = true
    }
    // Değişiklikleri kaydet
    func saveEdits(for parkingSpot: ParkingSpotEntity) {
        CoreDataManager.shared.updateParkingSpot(
            parkingSpot,
            title: editedTitle.isEmpty ? nil : editedTitle,
            address: editedAddress.isEmpty ? nil : editedAddress
        )
        
        isEditing = false
    }
}

// MARK: - ActivityViewController for Sharing
struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiView: UIActivityViewController, context: Context) {}
}
