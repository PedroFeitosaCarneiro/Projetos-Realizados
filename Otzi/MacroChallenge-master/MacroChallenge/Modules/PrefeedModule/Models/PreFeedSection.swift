//
//  PreFeedSection.swift
//  MacroChallenge
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 19/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation

struct PreFeedSection : Hashable {
    
    private let id = UUID()
    let hashtagTittle : String
    var items : [PreFeedData]
    var endCursor : String
    
    
}
