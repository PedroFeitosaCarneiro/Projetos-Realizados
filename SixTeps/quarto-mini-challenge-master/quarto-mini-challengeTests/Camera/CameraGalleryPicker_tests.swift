//
//  CameraGalleryPicker_tests.swift
//  quarto-mini-challengeTests
//
//  Created by Guilherme Martins Dalosto de Oliveira on 04/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import XCTest

class CameraGalleryPicker_tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let app = XCUIApplication()
        
        let photosApp = XCUIApplication(bundleIdentifier: "quarto-mini-challenge.Utils-Camera")
         let continueButton = photosApp.buttons["Continue"]
         let _ = app.tables
       
        
        photosApp.launch()
        
        if continueButton.waitForExistence(timeout: 2) {
          continueButton.tap()
        }
        
        photosApp.collectionViews["PhotosGridView"].cells.firstMatch.tap()
        

       
        app.sheets.buttons["Choose From Library"].tap()
        app.cells["Camera Roll"].tap()
        app.cells["Photo, Landscape, March 12, 2011, 7:17 PM"].tap()
        
    }

}
