//
//  CoreDataHelper.swift
//  OneSkyTest
//
//  Created by UHP Mac 3 on 15/01/2019.
//  Copyright © 2019 UHP Mac 1. All rights reserved.
//

import CoreData

final class CoreDataHelper {
    
    static let instance = CoreDataHelper(coreDataStack: CoreDataStack.instance)
    
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    /// Saves all changes to current context
    func saveContext() {
        coreDataStack.saveContext()
    }
    
    /// Returns a single object by its id. Make sure the object has an 'id' property of type Int32.
    ///
    /// - Parameters:
    ///   - type: Class type of object to be returned
    ///   - id: id of the object
    /// - Returns: Core data object
    func getObjectByIdentifier<T: Persistable>(type: T.Type, identifier: String) -> T? {
        let predicate = NSPredicate(format: "\(T.identifierName) = %d", identifier)
        return getObjectBy(type, predicate: predicate)
    }
    
    /// Returns a new NSManagedObject instance of the specified class type contained within the context.
    ///
    /// - Parameter type: Class type of object to be returned
    /// - Returns: New instance of core data object
    func create<T: Persistable>(type: T.Type) -> T {
        let context = coreDataStack.context
        let entity = NSEntityDescription.entity(forEntityName: String(describing: type), in: context)!
        return type.init(entity: entity, insertInto: context)
    }
    
    /// Tries to find an object of type 'type' by its id.
    /// If it does not exist, creates a new one instead with the specified id.
    /// Make sure the object has an 'id' property of type Int32.
    /// Use this method for saving objects (creating or updating).
    ///
    /// - Parameters:
    ///   - type: Class type of object to be returned
    ///   - id: id of an existing object (if it does not exist, returns a new object)
    /// - Returns: New (or existing) core data object
    func getExistingOrNew<T: Persistable>(type: T.Type, identifier: String) -> T {
        var object = getObjectByIdentifier(type: type, identifier: identifier)
        if object == nil {
            object = create(type: type)
            object?.setValue(identifier, forKey: "\(T.identifierName)")
        }
        return object!
    }
    
    /// Returns a single object matching specified predicate.
    ///
    /// - Parameters:
    ///   - type: Class type of object to be returned
    ///   - predicate: Predicate to be matched by
    /// - Returns: Core data object
    func getObjectBy<T: Persistable>(_ type: T.Type,
                                     predicate: NSPredicate? = nil) -> T? {
        return getObjects(type, sortDescriptors: nil, predicate: predicate).first
    }
    
    /// Returns a list of objects matching specified class type, sorting order and predicate
    ///
    /// - Parameters:
    ///   - type: Class type of object to be returned
    ///   - sortDescriptors: Sorting rules
    ///   - predicate: Filtering rules
    /// - Returns: List of core data objects
    func getObjects<T: Persistable>(_ type: T.Type,
                                    sortDescriptors: [NSSortDescriptor]? = nil,
                                    predicate: NSPredicate? = nil) -> [T] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: String(describing: type))
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        return (try? coreDataStack.context.fetch(fetchRequest)) as? [T] ?? [T]()
    }
    
    /// Delete an object from Core Data
    ///
    /// - Parameter object: Object to be deleted
    func delete<T: Persistable>(object: T) {
        coreDataStack.context.delete(object)
    }
    
    /// Deletes all core data objects of specified model class
    ///
    /// - Parameter entity: Class type of object to be deleted
    func deleteAllEntities<T: Persistable>(entity: T.Type) {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: entity))
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try coreDataStack.context.execute(request)
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
}

