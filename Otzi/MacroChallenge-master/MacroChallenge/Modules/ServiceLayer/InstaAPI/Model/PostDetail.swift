//
//  PostDetail.swift
//  MacroChallenge
//
//  Created by Fábio França on 28/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation

struct GraphqlDetail: Codable {
    let shortcode: ShortCode
    
    enum CodingKeys: String, CodingKey {
        case shortcode = "graphql"
    }
}

struct ShortCode: Codable {
    let detail: Detail
    
    enum CodingKeys: String, CodingKey {
        case detail = "shortcode_media"
    }
}

struct Detail: Codable {
    let owner: Owner
}

struct Owner: Codable {
    let imageUrl: String?
    let username: String
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "profile_pic_url"
        case username
        case name = "full_name"
    }
}
