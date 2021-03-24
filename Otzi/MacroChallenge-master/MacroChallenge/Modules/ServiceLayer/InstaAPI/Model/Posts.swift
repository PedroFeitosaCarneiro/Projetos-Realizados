//
//  Post.swift
//  MacroChallenge
//
//  Created by Fábio França on 14/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation

struct Graphql: Codable {
    let graphql: Hashtag
}

struct Hashtag: Codable {
    let hashtag: Midia
}

struct Midia: Codable {
    let edge: HashtagResult
    
    enum CodingKeys: String, CodingKey {
        case edge = "edge_hashtag_to_media"
    }
}

struct HashtagResult: Codable {
    let page: Page
    let posts: [Post]
    
    enum CodingKeys: String, CodingKey {
        case page = "page_info"
        case posts = "edges"
    }
}

struct Page: Codable {
    let nextPage: Bool
    let endCursor: String
    
    enum CodingKeys: String, CodingKey {
        case nextPage = "has_next_page"
        case endCursor = "end_cursor"
    }
}

struct Post: Codable, Hashable {
    var node: NodePost
    var isPostInstagram: Bool = true
}

struct NodePost: Codable, Hashable {
    var imageUrl: String
    let isVideo: Bool
    let descriptions: Descriptions
    let shortcode: String
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "display_url"
        case isVideo = "is_video"
        case descriptions = "edge_media_to_caption"
        case shortcode
    }
}

struct Descriptions: Codable, Hashable {
    let descriptions: [Description]
    
    enum CodingKeys: String, CodingKey {
        case descriptions = "edges"
    }
}

struct Description: Codable, Hashable {
    let node: DescriptionPost
}

struct DescriptionPost: Codable, Hashable {
    let descriptionText: String
    
    enum CodingKeys: String, CodingKey {
        case descriptionText = "text"
    }
}
