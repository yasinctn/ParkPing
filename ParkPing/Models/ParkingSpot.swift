//
//  ParkingSpot.swift
//  ParkPing
//
//  Created by Yasin Cetin on 10.09.2025.
//

import Foundation

struct ParkingSpot: Identifiable, Codable {
    var id = UUID()
    let latitude: Double
    let longitude: Double
    let timestamp: Date
    let title: String?
    let address: String?
    
    init(latitude: Double, longitude: Double, timestamp: Date = Date(), title: String? = nil, address: String? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
        self.title = title
        self.address = address
    }
}
