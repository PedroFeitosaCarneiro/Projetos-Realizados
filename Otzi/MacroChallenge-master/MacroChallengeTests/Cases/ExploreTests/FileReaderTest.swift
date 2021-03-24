//
//  FileReaderTest.swift
//  MacroChallengeTests
//
//  Created by Rangel Cardoso Dias on 06/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import XCTest
@testable import MacroChallenge

class FileReaderTest: XCTestCase {

    let validFileName = "TestFile"
    let fileExtension = ".txt"
    var sut: FileReader!
    private  func createSUT()->FileReader{
        return FileReader(bundle: Bundle(for: type(of: self)))
    }
    
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    
    override func setUp() {
        super.setUp()
        sut = createSUT()
    }
    func testLoadFileWithInvalidFileName() -> Void {
        
        do{
            let _ = try sut.loadFile(name: "", fileExtension: ".txt")
        }catch let error{
            XCTAssertEqual(error as? FileReaderError, FileReaderError.invalidFileName)
        }
    }
    
    func testLoadFile() -> Void {
         
        do{
            let result = try sut.loadFile(name: validFileName, fileExtension: fileExtension)
            
            XCTAssertFalse(result.isEmpty)
            
        }catch let error{
            XCTFail()
        }
    }

}
