//
//  CoreDataManager.swift
//  ParkPing
//
//  Created by Yasin Cetin on 10.09.2025.
//


import CoreData

class CoreDataManager: ObservableObject {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ParkingSpot")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data error: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            print("Failed to save Core Data context: \(error)")
        }
    }
    
    func fetchParkingSpots() -> [ParkingSpotEntity] {
        let request: NSFetchRequest<ParkingSpotEntity> = ParkingSpotEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ParkingSpotEntity.timestamp, ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch parking spots: \(error)")
            return []
        }
    }
    
    func createParkingSpot(latitude: Double, longitude: Double, title: String?, address: String?) -> ParkingSpotEntity {
        let entity = ParkingSpotEntity(context: context)
        entity.id = UUID()
        entity.latitude = latitude
        entity.longitude = longitude
        entity.timestamp = Date()
        entity.title = title
        entity.address = address
        save()
        return entity
    }
    
    func deleteParkingSpot(_ entity: ParkingSpotEntity) {
        context.delete(entity)
        save()
    }
}

extension ParkingSpotEntity {
    var toParkingSpot: ParkingSpot {
        ParkingSpot(
            latitude: self.latitude,
            longitude: self.longitude,
            timestamp: self.timestamp!,
            title: self.title,
            address: self.address
        )
    }
}

