//
//  TaskCD+CoreDataProperties.swift
//  quarto-mini-challenge
//
//  Created by Antonio Carlos on 11/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//
//

import Foundation
import CoreData


extension TaskCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskCD> {
        return NSFetchRequest<TaskCD>(entityName: "TaskCD")
    }

    @NSManaged public var category_id: Int16
    @NSManaged public var difficulty_id: Int16
    @NSManaged public var done_amount: Int16
    @NSManaged public var is_done: Bool
    @NSManaged public var name: String?
    @NSManaged public var priority_id: Int16
    @NSManaged public var score: Int16
    @NSManaged public var task_uuid: UUID?

}
