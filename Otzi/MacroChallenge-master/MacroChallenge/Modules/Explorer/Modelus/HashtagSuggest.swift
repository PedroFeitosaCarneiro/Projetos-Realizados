//
//  HashtagSuggest.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 23/09/20.
//  Copyright © 2020 macro.com. All rights reserved.

//

import Foundation


/// Model que representa as hashtags sugeridas
class HashtagSuggest: NSObject {
    
    var text: String
    var urlImage: String?
    init(text: String) {
        self.text = text
    }

}
