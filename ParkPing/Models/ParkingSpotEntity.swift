//
//  ParkingSpotEntity.swift
//  ParkPing
//
//  Created by Yasin Cetin on 13.09.2025.
//


import CoreData

final class ParkingSpotEntity: NSManagedObject {
    
}


extension ParkingSpotEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ParkingSpotEntity> {
        return NSFetchRequest<ParkingSpotEntity>(entityName: "ParkingSpotEntity")
    }

    @NSManaged public var address: String?
    @NSManaged public var id: UUID
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var timestamp: Date
    @NSManaged public var title: String?

}

extension ParkingSpotEntity : Identifiable {

}

extension ParkingSpotEntity {
    var toParkingSpot: ParkingSpot {
        ParkingSpot(
            latitude: self.latitude,
            longitude: self.longitude,
            timestamp: self.timestamp,
            title: self.title,
            address: self.address
        )
    }
}

