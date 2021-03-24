//
//  BingResult.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 19/11/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation



struct BingImage: Codable {
    let name: String?
    let hostPageDisplayUrl: String?
    let hostPageUrl: String?
    let contentUrl: String?
    let thumbnailUrl: String?
    let imageId: String?
    let contentSize: String?
//    init(dictionary: Dictionary<String, A?ny>) {
//        name = dictionary["name"] as? String ?? ""
//        hostPageDisplayUrl = dictionary["hostPageDisplayUrl"] as? String ?? ""
//        contentUrl = dictionary["contentUrl"] as? String ?? ""
//        thumbnailUrl = dictionary["thumbnailUrl"] as? String ?? ""
//    }
}





struct BingWrapper: Codable {
    let nextOffset: Int
    let currentOffset: Int
    let value: [BingImage]?
}
