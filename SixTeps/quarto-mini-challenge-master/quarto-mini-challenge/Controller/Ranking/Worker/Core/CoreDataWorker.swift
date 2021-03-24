//
//  CoreDataWorker.swift
//  quarto-mini-challenge
//
//  Created by Guilherme Martins Dalosto de Oliveira on 13/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation
import CoreData

class CoreDataWorker{
    
    let coreManager = CoreDataManager.shared
    
    // Fazer ligação com o logado
    func fetchUserID() -> String{
        var userID: String = ""
        
        let context = coreManager.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserCD")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                userID = data.value(forKey: "user_rec_id") as! String
            }
            
        } catch {
            
            print("Failed")
        }
        
        UserDefaultLogic().userId = userID
        return userID
    }
}
