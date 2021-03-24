//
//  GetImagesURL.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 23/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit

class GetImagesURL {
    
    private let serviceAPI: InstaPostsAPI = InstaPostsAPI(manager: RequestManagerFactory.alamofire.create())
  
    private let imageAPI :ImageAPI = ImageAPI(manager: RequestManagerFactory.alamofire.create())
    let group = DispatchGroup()
    var hashtags : [HashtagSuggest] = [HashtagSuggest]()
    var i = 0
    init(hashtags: [String]) {
        hashtags.forEach { (hh) in
            self.hashtags.append(HashtagSuggest(text: hh))
        }
        Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(callback), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 50, target: self, selector: #selector(imprimir), userInfo: nil, repeats: true)
    }
    
    

    @objc func imprimir() {
        
        for e in self.dicitonary{
            print("\(e.key):\(e.value)")
        }
    }
    

    @objc func callback() {
        
       pegarURL()
    }
    
    
    
    
    static func pegarAsQueFalta(){
        var dicitonary : [String] = [String]()
        let f = FileReader()
        let a = try! f.loadFileFromBundle(name: "hashtagsuggest", fileExtension: ".txt")
        
        for linha in a{
            let s = linha.split(maxSplits: 1, omittingEmptySubsequences: true) { (c) -> Bool in
                return c == ":"
            }
            
            if s.count >= 1{
                dicitonary.append(String(s[0]))
            }
            
            
//            if s.count == 2{
//                dicitonary[String(s[0])] = String(s[1])
//            }
            
            
        }
        
        
        let arquivoBase = try! f.loadFileFromBundle(name: "texto", fileExtension: ".txt")
        var array = [String]()
        for tag in arquivoBase{
            if !dicitonary.contains(tag){
                array.append(tag)
            }
            
                
            
        }
        
        
        for h in array{
            print(h)
        }
        
    }
    
    static func getHashtags() -> [String]{
         let f = FileReader()
         let a = try! f.loadFileFromBundle(name: "texto", fileExtension: ".txt")
        
         
         return a
     }
    
    func pegarURL(){
        if i > (hashtags.count-1) {return}
            group.enter()
            print("rangel")
                let tag = hashtags[i]
                let _ = self.fetchHashtagImage(from: tag) { (_) in
                }
            



        i+=1
        
        
        
        group.notify(queue: .main){ [self] in
            print("Terminou a request numero \(self.i)")
            if self.i >= (self.hashtags.count-1){
                for e in self.dicitonary{
                    print("\(e.key) : \(e.value)")
                }
            }
            
          
        }
    }
    
    
    
    
    var dicitonary : [String: String] = [:]
    func fetchHashtagImage(from hashtag: HashtagSuggest, completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID?{
     
        
        let dispatchQueue = DispatchQueue(label: "ExploreFetchImage", qos: .utility, attributes: .concurrent)

        dispatchQueue.async { [self] in
       //     sleep(1000)

            self.serviceAPI.getPostsWith(hashtag: hashtag.text, endCursor: "") { (result) in
                

                let result = try? result.get()
                
                guard let newResult = result else {
                    return
                }
                let temPosts = newResult.graphql.hashtag.edge.posts
                
                dispatchQueue.async { [self] in
                    self.addToDictionary(posts: temPosts, chave: hashtag)
                }
                
              
            }
        }
                
      
        return nil
    }

    func addToDictionary(posts: [Post], chave: HashtagSuggest){
        var temp = posts
        guard let post = posts.first else {return}
        let _ = self.imageAPI.getImageWith(url: post.node.imageUrl) { (result) in
            
            let image = try? result.get()
            
            if FilterTattoo.shared.isTattoo(image: image ?? UIImage()){
                self.dicitonary[chave.text] = post.node.imageUrl
                self.group.leave()
                print("Baixou umaa")
                return
            }else{
                temp.removeFirst()
                self.addToDictionary(posts: temp, chave: chave)
            }
            
        }
    }
}

