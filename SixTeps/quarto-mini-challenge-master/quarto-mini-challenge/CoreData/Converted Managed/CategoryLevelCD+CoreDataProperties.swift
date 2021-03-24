//
//  CategoryLevelCD+CoreDataProperties.swift
//  quarto-mini-challenge
//
//  Created by Antonio Carlos on 11/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//
//

import Foundation
import CoreData


extension CategoryLevelCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryLevelCD> {
        return NSFetchRequest<CategoryLevelCD>(entityName: "CategoryLevelCD")
    }

    @NSManaged public var category_id: Int16
    @NSManaged public var category_rec_id: String
    @NSManaged public var points_amount: Int16

}
