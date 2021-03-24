//
//  ManagedObject.swift
//  MacroChallenge
//
//  Created by Lelio Jorge Junior on 15/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import  CoreData

enum NSPredicateFormat: String{
    
    case name = "name = %@"
    
}


// MARK: - Extension NSManagedObject
public extension NSManagedObject {
    
    /// Formata a *entityName* para passar para a função fetch.
    class var entityName: String {
        var name = NSStringFromClass(self)
        name = name.components(separatedBy: ".").last!
        return name
    }
    
    /// Configura a entity para salvar no context.
    /// - Returns: NSFetchRequest<NSFetchRequestResult>
    static func fetch() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
    }
    
}
