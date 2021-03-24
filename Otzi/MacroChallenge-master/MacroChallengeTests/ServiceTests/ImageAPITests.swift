//
//  ImageAPITests.swift
//  MacroChallengeTests
//
//  Created by Fábio França on 21/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import XCTest
@testable import MacroChallenge

@available(iOS 13.0, *)
class ImageAPITests: XCTestCase {
    
    func getImageWith() {
        let api = ImageAPI(manager: RequestManagerMock(status: .apiError))
        
        _ = api.getImageWith(url: "") { (result) in
            
            
           
        }
        
        
    }



}
