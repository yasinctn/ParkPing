//
//  ParkingAnnotation.swift
//  ParkPing
//
//  Created by Yasin Cetin on 11.09.2025.
//

import MapKit

class ParkingAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    
    init(parkingSpot: ParkingSpotEntity) {
        self.coordinate = CLLocationCoordinate2D(
            latitude: parkingSpot.latitude,
            longitude: parkingSpot.longitude
        )
        self.title = parkingSpot.title ?? "Parking Spot"
        self.subtitle = parkingSpot.address ?? "Tap for directions"
    }
}
