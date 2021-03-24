//
//  PreFeedData.swift
//  MacroChallenge
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 19/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit

struct PreFeedData : Hashable{

    let id = UUID()
    var postURL : String
    var post: Post
    
}
