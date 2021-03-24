//
//  Task_Tests.swift
//  quarto-mini-challengeTests
//
//  Created by Antonio Carlos on 05/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import XCTest
@testable import quarto_mini_challenge

class Task_Tests: XCTestCase {
    
    func testBuildEmptyTask() {
        
        let taskBuilder = TaskConcreteBuilder()
        
        do {
            try taskBuilder.produceName("Lavar louca")
        } catch TaskError.noValidName {
            print("O nome não pode ser vazio")
        } catch {
            print("lascou")
        }
        taskBuilder.produceCategory(.Health)
        taskBuilder.produceDifficulty(.Easy)
        taskBuilder.producePriority(.High)
        
        let task = taskBuilder.build()
        
        XCTAssertNotNil(task)
    }
    
    func testBuildExistingTask() {
        
        let taskBuilder = TaskConcreteBuilder()
        
        do {
            try taskBuilder.produceName("Lavar louca")
        } catch TaskError.noValidName {
            print("O nome não pode ser vazio")
        } catch {
            print("lascou")
        }
        
        taskBuilder.produceUUID(UUID())
        taskBuilder.produceCategory(.Health)
        taskBuilder.produceDifficulty(.Easy)
        taskBuilder.producePriority(.High)
        
        let task = taskBuilder.build()
        
        XCTAssertNotNil(task)
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        testBuildEmptyTask()
        testBuildExistingTask()
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
        }
    }

}
