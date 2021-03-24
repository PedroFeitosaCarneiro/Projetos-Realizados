//
//  InstaUserAPI.swift
//  MacroChallenge
//
//  Created by Fábio França on 28/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation

class InstaPostDetail {
    
    private let manager: RequestManager
    
    init(manager: RequestManager) {
        self.manager = manager
    }
    
    func getInstaPostDetail(_ post: Post,completion: @escaping (Result<GraphqlDetail,Error>)-> Void) {
        let url = InstaPostsAPISources.instaPostDetail(shortcode: post.node.shortcode).getURL()
        
        switch url {
        case .success(let url):
            _ = manager.request(url: url, method: .get, parameters: [:], headers: [:], completion: completion)
        case .failure(let error):
            completion(.failure(error))
        }
        
        
    }
}
