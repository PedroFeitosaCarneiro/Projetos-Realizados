//
//  HashtahSuggestTest.swift
//  MacroChallengeTests
//
//  Created by Rangel Cardoso Dias on 06/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import XCTest
@testable import MacroChallenge
class HashtahSuggestTest: XCTestCase {

    func testInitHashtagSuggest(){
        let text = "Text"
        
        let hastag = HashtagSuggest(text: text)
        
        XCTAssertEqual(text, hastag.text)
        XCTAssertNil(hastag.urlImage)
    }

}
