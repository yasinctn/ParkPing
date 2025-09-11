//
//  LocationManager.swift
//  ParkPing
//
//  Created by Yasin Cetin on 11.09.2025.
//

import Foundation
import CoreLocation
import Combine
import UIKit

@MainActor
final class LocationManager: NSObject, ObservableObject {
    
    // MARK: - Singleton
    static let shared = LocationManager()
    
    // MARK: - Published Properties
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var isLocationServicesEnabled = false
    @Published var locationError: LocationError?
    @Published var isLoading = false
    
    // MARK: - Private Properties
    private let locationManager = CLLocationManager()
    private var locationContinuation: CheckedContinuation<CLLocation, Error>?
    
    // MARK: - Computed Properties
    var isAuthorized: Bool {
        authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    }
    
    var canRequestLocation: Bool {
        isLocationServicesEnabled && isAuthorized
    }
    
    // MARK: - Initialization
    override init() {
        super.init()
        setupLocationManager()
        checkLocationServicesStatus()
    }
    
    // MARK: - Public Methods
    
    /// Request location permission from user
    func requestLocationPermission() {
        guard authorizationStatus == .notDetermined else { return }
        locationManager.requestWhenInUseAuthorization()
    }
    
    /// Get current location asynchronously
    func getCurrentLocation() async throws -> CLLocation {
        guard isLocationServicesEnabled else {
            throw LocationError.locationServicesDisabled
        }
        
        guard isAuthorized else {
            throw LocationError.permissionDenied
        }
        
        // Clear previous error
        locationError = nil
        isLoading = true
        
        defer { isLoading = false }
        
        return try await withCheckedThrowingContinuation { continuation in
            locationContinuation = continuation
            locationManager.requestLocation()
        }
    }
    
    /// Get current location with completion handler (alternative approach)
    func getCurrentLocation(completion: @escaping (Result<CLLocation, LocationError>) -> Void) {
        Task {
            do {
                let location = try await getCurrentLocation()
                completion(.success(location))
            } catch {
                completion(.failure(error as? LocationError ?? .unknown))
            }
        }
    }
    
    /// Check if location services are available
    func checkLocationServicesStatus() {
        DispatchQueue.global(qos: .utility).async {
            let servicesEnabled = CLLocationManager.locationServicesEnabled()
            
            DispatchQueue.main.async {
                self.isLocationServicesEnabled = servicesEnabled
                self.authorizationStatus = self.locationManager.authorizationStatus
            }
        }
    }
    
    /// Open device settings if permission denied
    func openLocationSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL)
    }
}

// MARK: - Private Methods
private extension LocationManager {
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10 // meters
    }
    
    func handleLocationUpdate(_ location: CLLocation) {
        self.location = location
        locationContinuation?.resume(returning: location)
        locationContinuation = nil
    }
    
    func handleLocationError(_ error: Error) {
        let locationError = LocationError.from(error)
        self.locationError = locationError
        locationContinuation?.resume(throwing: locationError)
        locationContinuation = nil
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        handleLocationUpdate(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        handleLocationError(error)
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        checkLocationServicesStatus()
    }
}


