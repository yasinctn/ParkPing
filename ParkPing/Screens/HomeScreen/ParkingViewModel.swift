//
//  ParkingViewModel.swift
//  ParkPing
//
//  Created by Yasin Cetin on 10.09.2025.
//

import Foundation
import CoreLocation
import Combine

@MainActor
class ParkingViewModel: ObservableObject {
    
    // MARK: - Published Properties (State Management)
    @Published var parkingSpots: [ParkingSpotEntity] = []
    @Published var isLoading = false
    @Published var showToast = false
    @Published var toastMessage = ""
    @Published var errorMessage: String?
    
    @Published var isRefreshing = false
    
    // MARK: - Dependencies
    private let locationManager = LocationManager.shared
    private let coreDataManager = CoreDataManager.shared
    
    // MARK: - Computed Properties
    var mostRecentSpot: ParkingSpotEntity? {
        parkingSpots.first
    }
    
    var parkingSpotsCount: Int {
        parkingSpots.count
    }
    
    var hasNoData: Bool {
        parkingSpots.isEmpty
    }
    
    // MARK: - Initialization
    init() {
        loadParkingSpots()
    }
    
    // MARK: - Public Methods (Business Logic)
    
    /// Load all parking spots from Core Data
    func loadParkingSpots() {
        do {
            parkingSpots = coreDataManager.fetchParkingSpots()
            /*
            // Create initial mock data if empty
            if parkingSpots.isEmpty {
                createInitialMockData()
            }
            */
            clearError()
        } catch {
            handleError("Failed to load parking spots: \(error.localizedDescription)")
        }
    }
    
    /// Save a new parking location
    func saveParkingLocation() {
        guard !isLoading else { return }
        
        isLoading = true
        clearError()
        
        Task {
            do {
                // Get current location
                let currentLocation = try await locationManager.getCurrentLocation()
                
                // Save to Core Data with real coordinates
                let _ = coreDataManager.createParkingSpot(
                    latitude: currentLocation.coordinate.latitude,
                    longitude: currentLocation.coordinate.longitude,
                    title: "Parking Spot #\(self.parkingSpots.count + 1)",
                    address: await self.getAddressFromLocation(currentLocation)
                )
                
                loadParkingSpots()
                showSuccessToast("Parking location saved successfully!")
                
            } catch let error as LocationError {
                handleError(error.errorDescription ?? "Failed to get location")
            } catch {
                handleError("Failed to save parking location: \(error.localizedDescription)")
            }
            
            isLoading = false
        }
    }
    
    /// Delete a specific parking spot
    func deleteParkingSpot(_ entity: ParkingSpotEntity) async {
        do {
            try await coreDataManager.deleteParkingSpot(with: entity.objectID)
            loadParkingSpots()
            showSuccessToast("Parking spot deleted")
        } catch {
            handleError("Failed to delete parking spot: \(error.localizedDescription)")
        }
    }
    
    /// Delete multiple parking spots
    func deleteMultipleParkingSpots(at offsets: IndexSet) async {
        do {
            for index in offsets {
                let entity = parkingSpots[index]
                try await coreDataManager.deleteParkingSpot(with: entity.objectID)
            }
            
            loadParkingSpots()
            let count = offsets.count
            showSuccessToast("Parking spot\(count > 1 ? "s" : "") deleted")
            
        } catch {
            handleError("Failed to delete parking spots: \(error.localizedDescription)")
        }
    }
    
    /// Clear all parking spots
    func clearAllParkingSpots() async {
        do {
            for entity in parkingSpots {
                try await coreDataManager.deleteParkingSpot(with: entity.objectID)
            }
            loadParkingSpots()
            showSuccessToast("All parking spots cleared")
        } catch {
            handleError("Failed to clear parking spots: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func refreshParkingSpots() async {
        isRefreshing = true
        refreshData()
        isRefreshing = false
    }
    
    /// Refresh data from Core Data
    func refreshData() {
        loadParkingSpots()
    }
    
    /// Dismiss current toast
    func dismissToast() {
        showToast = false
        toastMessage = ""
    }
    
    /// Clear error state
    func clearError() {
        errorMessage = nil
    }
}

// MARK: - Private Helper Methods
private extension ParkingViewModel {
    
    /// Show success toast message
    func showSuccessToast(_ message: String) {
        toastMessage = message
        showToast = true
        
        // Auto-dismiss after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.showToast = false
        }
    }
    
    /// Handle errors
    func handleError(_ message: String) {
        errorMessage = message
        print("❌ ParkingViewModel Error: \(message)")
    }
    
    /// Generate random address for mock data
    func generateRandomAddress() -> String {
        let streets = [
            "Main St", "Market St", "Oak Ave", "Pine Rd",
            "Broadway", "1st St", "Union St", "Mission St",
            "Castro St", "Valencia St", "Fillmore St"
        ]
        let numbers = Array(100...999)
        let cities = ["San Francisco", "Oakland", "Berkeley", "Palo Alto"]
        
        let randomStreet = streets.randomElement() ?? "Main St"
        let randomNumber = numbers.randomElement() ?? 123
        let randomCity = cities.randomElement() ?? "San Francisco"
        
        return "\(randomNumber) \(randomStreet), \(randomCity), CA"
    }
    
    private func getAddressFromLocation(_ location: CLLocation) async -> String {
        // Reverse geocoding için
        let geocoder = CLGeocoder()
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            if let placemark = placemarks.first {
                var address = ""
                
                if let streetNumber = placemark.subThoroughfare {
                    address += streetNumber + " "
                }
                if let streetName = placemark.thoroughfare {
                    address += streetName + ", "
                }
                if let city = placemark.locality {
                    address += city + ", "
                }
                if let state = placemark.administrativeArea {
                    address += state
                }
                
                return address.isEmpty ? generateRandomAddress() : address
            }
        } catch {
            print("Reverse geocoding failed: \(error)")
        }
        
        // Fallback to coordinates
        return "Location: \(location.coordinatesString)"
    }
    
    /// Create initial mock data for first app launch
    func createInitialMockData() {
        let mockSpots: [(title: String, address: String, hoursAgo: Int)] = [
            (
                title: "Downtown Parking",
                address: "456 Market St, San Francisco, CA",
                hoursAgo: 2
            ),
            (
                title: "Mall Parking",
                address: "789 Shopping Center, Oakland, CA",
                hoursAgo: 25 // 1+ day ago
            ),
            (
                title: "Office Parking",
                address: "321 Business Ave, Palo Alto, CA",
                hoursAgo: 72 // 3 days ago
            )
        ]
        
        for mockSpot in mockSpots {
            let timestamp = Calendar.current.date(
                byAdding: .hour,
                value: -mockSpot.hoursAgo,
                to: Date()
            ) ?? Date()
            
            let entity = ParkingSpotEntity(context: coreDataManager.context)
            entity.id = UUID()
            entity.latitude = 37.7749 + Double.random(in: -0.02...0.02)
            entity.longitude = -122.4194 + Double.random(in: -0.02...0.02)
            entity.timestamp = timestamp
            entity.title = mockSpot.title
            entity.address = mockSpot.address
        }
        
        do {
            try coreDataManager.context.save()
            loadParkingSpots()
        } catch {
            handleError("Failed to create initial mock data: \(error.localizedDescription)")
        }
    }
}
