//
//  BingKEYS.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 19/11/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation

struct BingKEYS {
    static let api_key = "fab6f5c8947c4731be887ff5e8d1b10b"
    static let subscription_key = "Ocp-Apim-Subscription-Key"
    static let search_url = "https://api.bing.microsoft.com/v7.0/images/search"
    static let search_term_key = "q"
    static let license_key = "license"
    static let offset_key = "offset"
    static let count_key = "count"
    static let language_key = "mkt"
    static let contentType = "imageType"
    
    
    
}



public enum LiceseType: String{
    
    
    case AnyType = "any"
    case Public = "public"
    case Share = "share"
    case ShareCommercially = "sharecommercially"
    case Modify = "modify"
    case ModifyCommercially = "modifycommercially"
    case All = "all"
    
    
    
}
