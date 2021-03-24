//
//  SearchInteractor.swift
//  MacroChallenge
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 23/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation


class HashtagSearchInteractor : SearchInteractorToPresenter{
    
    
    
    weak var presenter: SearchPresenterToInteractor?
    
    private let dataBase = CoreDataManager()
    
    func formatHashtagTattoo(hashtag: String) -> HashtagSuggest {
        
        if hashtag == "" {
            return HashtagSuggest(text: HashtagCases.DEFAULT.rawValue)
        }
        
        let hashtagCopy = hashtag.lowercased()
      
        
        var definitiveHashtag = hashtagCopy.replacingOccurrences(of: HashtagCases.DEFAULT.rawValue, with: "")
        definitiveHashtag = definitiveHashtag.replacingOccurrences(of: " ", with: "")
        definitiveHashtag = definitiveHashtag.removeSpecialCharacters
        definitiveHashtag = "\(definitiveHashtag)\(HashtagCases.DEFAULT.rawValue)"
        
        return HashtagSuggest(text: definitiveHashtag)
    }
    
    func formatHashtagString(hashtag: String) -> String {
        
        if hashtag == "" {
            return "Tattoo"
        }
        
        let hashtagCopy = hashtag.lowercased()
      
        
        var definitiveHashtag = hashtagCopy.replacingOccurrences(of: HashtagCases.DEFAULT.rawValue, with: "")
        definitiveHashtag = definitiveHashtag.replacingOccurrences(of: " ", with: "")
        definitiveHashtag = definitiveHashtag.removeSpecialCharacters
        definitiveHashtag = "\(definitiveHashtag)\(HashtagCases.DEFAULT.rawValue)"
        
        return definitiveHashtag
    }
    
    
    func getRecentSearch(completion: @escaping (_: [String]) -> Void){
        

        
        dataBase.fetch(entity: Tag.self) { (result, error) in
            var array : [Tag] = []
            var stringArray : [String] = []
            guard let result = result else {return}
            for item in result{
                if item.date != nil {
                    array.append(item)
                }
            }

           array = array.sorted { (old, new) -> Bool in
                
                if old.date!.timeIntervalSince1970 < new.date!.timeIntervalSince1970{
                    return true
                } else {
                    return false
                }
            }
            
            for i in array{
                var text = i.name
                text = text?.lowercased()
                text = text?.replacingOccurrences(of: "tattoo", with: "tattoo")
                stringArray.append(text!)
            }
            
            completion(stringArray)
        }
        
        
    }
    
    func deleteRecentHashtag(with hashtag: String) {
        
        let hashtagText = hashtag.lowercased()
        
        let predicate = NSPredicate(format: "name = %@ AND isSeachedTag == %@", argumentArray: [hashtagText,true])
        dataBase.delete(entity: Tag.self, predicate: predicate) { (error) in
            
        }
        
        
    }
    
    func saveRecentSearch(with hashtag: String){
        
        var text = hashtag.lowercased()
        text = text.replacingOccurrences(of: "tattoo", with: "")
        
        let nHashtag = formatHashtagString(hashtag: text)
        
        let tag = TagEntity(name: nHashtag, rating: 0.0, isSeachedTag: true, date: Date())
        
        let predicate = NSPredicate(format: "name = %@ AND isSeachedTag == %@", argumentArray: [nHashtag,true])
        
        
        dataBase.fetch(entity: Tag.self, predicate: predicate) { [self] (result, error) in
            
            var updatedTag : TagEntity? = nil
            
            if result?.count != nil {
                
                for item in result!{
                    updatedTag = TagEntity(name: item.name!, rating: item.rating, isSeachedTag: item.isSeachedTag, date: Date())
                }
                
                dataBase.update(tag: updatedTag!, predicate: predicate) { (error) in
                }
                
                
            } else {
                dataBase.insert(with: tag) { (error) in
                }
            }
            
            
        }
        
        
    }
}

enum HashtagCases : String{
    case DEFAULT = "tattoo"
}
