//
//  ParkingViewModel.swift
//  ParkPing
//
//  Created by Yasin Cetin on 10.09.2025.
//

import Foundation
import CoreLocation
import Combine
import CoreData

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
            handleError("\(Txt.Messages.failedToLoadSpots): \(error.localizedDescription)")
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
                    title: String(format: Txt.MockData.parkingSpotTitle, "\(self.parkingSpots.count + 1)"),
                    address: await self.getAddressFromLocation(currentLocation)
                )
                
                loadParkingSpots()
                showSuccessToast(Txt.Messages.parkingLocationSaved)
                
            } catch let error as LocationError {
                handleError(error.errorDescription ?? Txt.Messages.failedToGetLocation)
            } catch {
                handleError("\(Txt.Messages.failedToSaveLocation): \(error.localizedDescription)")
            }
            
            isLoading = false
        }
    }
    
    // Tek silme
    func deleteParkingSpot(_ entity: ParkingSpotEntity) async {
        do {
            try coreDataManager.delete(entity)
            loadParkingSpots()
            showSuccessToast(Txt.Messages.parkingSpotDeleted)
        } catch {
            handleError("\(Txt.Messages.failedToDeleteSpot): \(error.localizedDescription)")
        }
    }
    
    // Çoklu silme
    func deleteMultipleParkingSpots(at offsets: IndexSet) async {
        do {
            let ids = offsets.map { parkingSpots[$0].objectID }
            try coreDataManager.delete(with: ids)
            loadParkingSpots()
            let count = offsets.count
            let message = count > 1 ? Txt.Messages.parkingSpotsDeleted : Txt.Messages.parkingSpotDeleted
            showSuccessToast(message)
        } catch {
            handleError("\(Txt.Messages.failedToDeleteSpots): \(error.localizedDescription)")
        }
    }
    
    /*
     /// Clear all parking spots FEATURE
     func clearAllParkingSpots() async {
     do {
     for entity in parkingSpots {
     try await coreDataManager.delete(with: entity.objectID)
     }
     loadParkingSpots()
     showSuccessToast("All parking spots cleared")
     } catch {
     handleError("Failed to clear parking spots: \(error.localizedDescription)")
     }
     }
     */
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
        print(String(format: Txt.Debug.errorPrefix, message))
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
            print(String(format: Txt.Debug.reverseGeocodingFailed, "\(error)"))
        }
        
        // Fallback to coordinates
        return String(format: Txt.Messages.locationPrefix, location.coordinatesString)
    }
    
    /// Create initial mock data for first app launch
    func createInitialMockData() {
        let mockSpots: [(title: String, address: String, hoursAgo: Int)] = [
            (
                title: Txt.MockData.downtownParking,
                address: "456 Market St, San Francisco, CA",
                hoursAgo: 2
            ),
            (
                title: Txt.MockData.mallParking,
                address: "789 Shopping Center, Oakland, CA",
                hoursAgo: 25 // 1+ day ago
            ),
            (
                title: Txt.MockData.officeParking,
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
            handleError("\(Txt.MockData.failedToCreateMockData): \(error.localizedDescription)")
        }
    }
}
