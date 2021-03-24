//
//  MapLogicTests.swift
//  MacroChallengeTests
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 21/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import XCTest
import MapKit
@testable import MacroChallenge



class LogicalTests: XCTestCase{

    
    let parser = LocationParser(with: .init(latitude: 1, longitude: 1))
    
    func testParser(){
        
        parser.handleLocation { (value) in
            XCTAssertNil(value)
        }
        
        
    }
}
