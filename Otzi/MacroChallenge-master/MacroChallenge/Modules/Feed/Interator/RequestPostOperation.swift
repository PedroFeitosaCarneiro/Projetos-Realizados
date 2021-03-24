//
//  RequestPostOperation.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 14/11/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation

/// Operation async para fazer o requisição de posts
class RequestPostOperation: AsyncOperation {
    
    var cache: [Post]? = nil
    
    let hashtag : HashtagSuggest
    var endcursor: (hasPage: Bool, endcursor:String)
    var completion: ((Post?) -> ())? = nil
    let serviceAPI: InstaPostsAPI
    
    
    /// Init da RequestPostOperation
    /// - Parameters:
    ///   - serviceAPI: uma service API
    ///   - hashtag: hashtag a ser buscada
    ///   - endcursor: o endcursor da requisição
    ///   - completion: Uma completion option para pegar um post
    init(serviceAPI: InstaPostsAPI,hashtag: HashtagSuggest, endcursor: (hasPage: Bool, endcursor:String),completion: ((Post?) -> ())? = nil) {
        self.hashtag = hashtag
        self.endcursor = endcursor
        self.completion = completion
        self.serviceAPI = serviceAPI
  }
  
  override func main () {
    if isCancelled {
        return
    }
      
    if endcursor.hasPage{
        
        serviceAPI.getPostsWith(hashtag: hashtag.text, endCursor: endcursor.endcursor) { [self] (result) in
            
            
            let result = try? result.get()
            
            guard let newResult = result else {
                cache = nil
                return
            }
            
            var temPosts =  newResult.graphql.hashtag.edge.posts
            
            temPosts = temPosts.filter({$0.node.isVideo == false})
            
            if let completion = completion, let post = temPosts.first{
                completion(post)
                temPosts.removeFirst()
            }
            
            endcursor.endcursor = newResult.graphql.hashtag.edge.page.endCursor
            endcursor.hasPage = newResult.graphql.hashtag.edge.page.nextPage
            
            let auxPosts =  Array(Set(temPosts))
            
            cache = auxPosts
            
            self.finish()
        }
    }
    
  }
}
