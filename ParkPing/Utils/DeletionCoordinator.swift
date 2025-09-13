//
//  DeletionCoordinator.swift
//  ParkPing
//
//  Created by Yasin Cetin on 13.09.2025.
//

import Foundation
import CoreData

class DeletionCoordinator: ObservableObject {
    @Published var isDeleting = false
    @Published var deletionError: Error?
    
    @MainActor
    func deleteParkingSpot(with objectID: NSManagedObjectID) async -> Bool {
        isDeleting = true
        deletionError = nil
        
        do {
            try await CoreDataManager.shared.deleteParkingSpot(with: objectID)
            isDeleting = false
            return true
        } catch {
            deletionError = error
            isDeleting = false
            print("Deletion failed: \(error)")
            return false
        }
    }
}
