//
//  RankingSort_tests.swift
//  quarto-mini-challengeTests
//
//  Created by Guilherme Martins Dalosto de Oliveira on 05/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import XCTest
import quarto_mini_challenge

class RankingSort_tests: XCTestCase {
    
    var orderRanking = Ranking()
    
    var users = [User(name: "gui", score: 2),User(name: "toin", score: 2),User(name: "Bernado", score: 5),User(name: "Predo", score: 3)]
    
    var array: Array = [2,3,1,4,6,5,6,2,9,6,8,7]
    var array2: Array = [1,2,3]
    
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        measure {
            array = orderRanking.mergeSort(array)
            XCTAssertNotNil(array)
            XCTAssert(array.isSorted(isOrderedBefore: <))
            
            
            users = users.sorted(by: {$0.score < $1.score})
            XCTAssertNotNil(users)
            XCTAssert(users.isSorted(isOrderedBefore: <))
            
        }
        
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
