//
//  TaskBlockCD+CoreDataProperties.swift
//  quarto-mini-challenge
//
//  Created by Antonio Carlos on 11/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//
//

import Foundation
import CoreData


extension TaskBlockCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskBlockCD> {
        return NSFetchRequest<TaskBlockCD>(entityName: "TaskBlockCD")
    }

    @NSManaged public var creation_date: String?
    @NSManaged public var difficulty_limit: Int16
    @NSManaged public var taskBlock_uuid: UUID?
    @NSManaged public var tasks_uuid: [UUID]?
    @NSManaged public var current: Bool

}
