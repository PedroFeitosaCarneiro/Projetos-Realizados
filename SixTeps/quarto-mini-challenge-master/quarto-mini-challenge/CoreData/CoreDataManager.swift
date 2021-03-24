//
//  PersistenceManager.swift
//  quarto-mini-challenge
//
//  Created by Antonio Carlos on 30/04/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    //MARK: Core Data Stack
    private init() {}
    
    public var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "quarto_mini_challenge")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    public func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    /// Method to fetch records from core data
    /// - Parameters:
    ///   - objectType: Type of object to be fetches
    ///   - predicate: Predicate to perform fetch (set nil if you dont want predicate)
    /// - Returns: array of results
    public func fetch<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate?, fetchLimit: Int?) -> [T] {
        
        //Recupera o nome da entidade
        let entityName = String(describing: objectType)
        
        //Cria o fetchRequest com a entidade
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        
        if let fetchLimit = fetchLimit {
            fetchRequest.fetchLimit = fetchLimit
        }
        
        //Recupera os objetos do banco de dados, retorna um array vazio se falhar na busca
        do {
            let fetchedObjects = try persistentContainer.viewContext.fetch(fetchRequest) as? [T]
            return fetchedObjects ?? [T]()
            
        } catch {
            print(error)
            return [T]()
        }
    }
    
    public func delete(_ object: NSManagedObject) {
        persistentContainer.viewContext.delete(object)
        saveContext()
    }
    
}
