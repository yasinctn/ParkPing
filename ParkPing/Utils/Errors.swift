//
//  Errors.swift
//  ParkPing
//
//  Created by Yasin Cetin on 11.09.2025.
//

import CoreLocation

enum LocationError: LocalizedError, Equatable {
    case permissionDenied
    case locationServicesDisabled
    case locationUnavailable
    case networkError
    case timeout
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Location permission denied. Please enable location access in Settings."
        case .locationServicesDisabled:
            return "Location services are disabled. Please enable them in Settings."
        case .locationUnavailable:
            return "Current location is unavailable. Please try again."
        case .networkError:
            return "Network error while getting location. Check your internet connection."
        case .timeout:
            return "Location request timed out. Please try again."
        case .unknown:
            return "An unknown error occurred while getting your location."
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .permissionDenied, .locationServicesDisabled:
            return "Go to Settings > Privacy & Security > Location Services to enable location access."
        case .locationUnavailable, .networkError, .timeout:
            return "Please try again in a moment."
        case .unknown:
            return "Please try again or restart the app."
        }
    }
    
    static func from(_ error: Error) -> LocationError {
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                return .permissionDenied
            case .locationUnknown:
                return .locationUnavailable
            case .network:
                return .networkError
            default:
                return .unknown
            }
        }
        return .unknown
    }
}
