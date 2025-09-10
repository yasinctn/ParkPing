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
        let container = NSPersistentContainer(name: "ParkingModel")
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
}

