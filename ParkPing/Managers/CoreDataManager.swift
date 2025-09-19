//
//  CoreDataManager.swift
//  ParkPing
//
//  Created by Yasin Cetin on 10.09.2025.
//


import CoreData

final class CoreDataManager: ObservableObject {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ParkingSpot")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data error: \(error.localizedDescription)")
            }
        }
        
        // 🔧 ÖNEMLİ: Ana context, arka plan kayıtlardaki değişiklikleri otomatik merge etsin
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
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
    
    func delete(_ parkingSpot: ParkingSpotEntity) throws {
        let obj = context.object(with: parkingSpot.objectID)
        context.delete(obj)
        try context.save()
    }
    
    // Birden fazla silme için:
    func delete(with objectIDs: [NSManagedObjectID]) throws {
        for id in objectIDs {
            let obj = context.object(with: id)
            context.delete(obj)
        }
        try context.save()
    }
    
    func updateParkingSpot(_ parkingSpot: ParkingSpotEntity, title: String?, address: String?) {
        parkingSpot.title = title
        parkingSpot.address = address// güncellenme tarihi
        save()
    }
}

