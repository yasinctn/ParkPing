//
//  CLLocation+Extension.swift
//  ParkPing
//
//  Created by Yasin Cetin on 11.09.2025.
//

import CoreLocation
// MARK: - Location Extensions
extension CLLocation {
    
    /// Get formatted coordinates string
    var coordinatesString: String {
        return String(format: "%.6f, %.6f", coordinate.latitude, coordinate.longitude)
    }
    
    /// Get location accuracy description
    var accuracyDescription: String {
        let accuracy = horizontalAccuracy
        if accuracy < 0 {
            return "Invalid"
        } else if accuracy < 5 {
            return "Excellent"
        } else if accuracy < 10 {
            return "Good"
        } else if accuracy < 50 {
            return "Fair"
        } else {
            return "Poor"
        }
    }
}
