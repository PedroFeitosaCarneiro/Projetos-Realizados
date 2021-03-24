//
//  SearchService.swift
//  MacroChallenge
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 23/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation

enum SearchError: Error{
    case notFound
}

class SearchService {
    
    static func doSearchOn(_ values: [String], text: String,completionHandler: @escaping ([String], SearchError?) -> Void){
        var possible : [String] = []
        for i in values{
            if i.contains(text.lowercased()){
                    possible.append("\(i)")
            }
        }
        
        if possible.isEmpty{
            completionHandler(possible,.notFound)
        }
        completionHandler(possible,nil)
    }
    
    
}
