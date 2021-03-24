//
//  PickerCameraGallery_tests.swift
//  quarto-mini-challengeTests
//
//  Created by Guilherme Martins Dalosto de Oliveira on 04/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import XCTest
import quarto_mini_challenge

class PickerCameraGallery_tests: XCTestCase{

    var camera: Camera?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        
        // Error, use for Learn later
        
//        self.camera = Camera(presentationController: self, delegate: self as ImagePickerDelegate)
//        self.camera.present(from: sender as UIView)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
