//
//  UserCD+CoreDataProperties.swift
//  quarto-mini-challenge
//
//  Created by Antonio Carlos on 11/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//
//

import Foundation
import CoreData


extension UserCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserCD> {
        return NSFetchRequest<UserCD>(entityName: "UserCD")
    }

    @NSManaged public var categorieLevel_ids: Int16    
    @NSManaged public var pointsAmount: Int16
    @NSManaged public var profile_picture: Data?
    @NSManaged public var tasks_amount_performed: Int16
    @NSManaged public var user_rec_id: String?
    @NSManaged public var username: String?
    @NSManaged public var backgroundPhoto: Data?

}
