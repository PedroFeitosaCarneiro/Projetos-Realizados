//
//  Entitys.swift
//  MacroChallenge
//
//  Created by Lelio Jorge Junior on 18/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import CoreData

/// Model da entidade User
public struct UserEntity {
    var name: String
    var email: String
    var accountType: Bool
}

/// Model da entidade Image
public struct ImageEntity {
    var id: String
    var owner: String
    var description: String
    var link: String
    var isPostInstagram: Bool
}

/// Model da Hashtag
public struct TagEntity {
    var name: String
    var rating: Double
    var isSeachedTag: Bool
    var date: Date?
}

/// Model da entidade Folder
public struct FolderEntity {
    var name: String
}
