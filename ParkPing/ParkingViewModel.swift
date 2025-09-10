//
//  ParkingViewModel.swift
//  ParkPing
//
//  Created by Yasin Cetin on 10.09.2025.
//

import Foundation
import Combine

@MainActor
class ParkingViewModel: ObservableObject {
    @Published var parkingSpots: [ParkingSpot] = []
    @Published var isLoading = false
    @Published var showToast = false
    @Published var toastMessage = ""
    
    var mostRecentSpot: ParkingSpot? {
        parkingSpots.sorted { $0.timestamp > $1.timestamp }.first
    }
    
    init() {
        loadMockData()
    }
    
    func saveParkingLocation() {
        isLoading = true
        
        // Simulate API call or location fetching
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Mock location data (San Francisco)
            let newSpot = ParkingSpot(
                latitude: 37.7749 + Double.random(in: -0.01...0.01),
                longitude: -122.4194 + Double.random(in: -0.01...0.01),
                timestamp: Date(),
                title: "Parking Spot #\(self.parkingSpots.count + 1)",
                address: "123 Main St, San Francisco, CA"
            )
            
            self.parkingSpots.insert(newSpot, at: 0)
            self.isLoading = false
            self.showToast(message: "Parking location saved!")
        }
    }
    
    private func showToast(message: String) {
        toastMessage = message
        showToast = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.showToast = false
        }
    }
    
    private func loadMockData() {
        // Mock data for preview and testing
        parkingSpots = [
            ParkingSpot(
                latitude: 37.7749,
                longitude: -122.4194,
                timestamp: Calendar.current.date(byAdding: .hour, value: -2, to: Date()) ?? Date(),
                title: "Downtown Parking",
                address: "456 Market St, San Francisco, CA"
            ),
            ParkingSpot(
                latitude: 37.7849,
                longitude: -122.4094,
                timestamp: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
                title: "Mall Parking",
                address: "789 Shopping Center, San Francisco, CA"
            ),
            ParkingSpot(
                latitude: 37.7649,
                longitude: -122.4294,
                timestamp: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
                title: "Office Parking",
                address: "321 Business Ave, San Francisco, CA"
            )
        ]
    }
}
