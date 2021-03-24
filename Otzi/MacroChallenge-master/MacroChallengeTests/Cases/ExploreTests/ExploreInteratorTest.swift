//
//  ExploreInteratorTest.swift
//  MacroChallengeTests
//
//  Created by Rangel Cardoso Dias on 07/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import XCTest
@testable import MacroChallenge
class ExploreInteratorTest: XCTestCase {

    var presenter: ExplorePresenterMock!
    var serviceLayer: ServiceAPILayer!
    var imageAPI: ImageAPILayer!
    override func setUp() {
        presenter = ExplorePresenterMock()
        serviceLayer = ServiceAPILayer(manager: RequestManagerFactory.alamofire.create())
        imageAPI = ImageAPILayer(manager: RequestManagerFactory.alamofire.create())
    }
    override func tearDown() {
        presenter = nil
        serviceLayer = nil
        imageAPI = nil
    }
    func createSUT(hasError:Bool = false) -> ExplorerInterator{
        
        let sut = ExplorerInterator(serviceAPI: serviceLayer, imageAPI: imageAPI, fileReader: MockFileReader(hasError: hasError))
        
        sut.presenter = presenter
        return sut
    }
    
    
    
    func testFetchHastagCallPresenterWhenfinishSucessefully(){
        let sut = createSUT()
        sut.fetchHashtags()
        XCTAssertTrue(presenter.fetchedHashTagsSucessefullyWasCalled)
    }
    func testFetchHastagCallPresenterErrorWhenIsUnsucessefully(){
        let sut = createSUT(hasError: true)
        sut.fetchHashtags()
        XCTAssertTrue(presenter.fetchHashtagFailedWasCalled)
    }
    
//    func testGetImageWasCalled(){
//        let sut = createSUT()
//        let _ = sut.fetchHashtagImage(from: HashtagSuggest(text: "")) { (result) in }
//        XCTAssertTrue(imageAPI.getImageWasCalled)
//    }
    
    
    func testCancelImageWasCalled(){
        let sut = createSUT()
        let _ = sut.cancelFetchImage(by: UUID())
        XCTAssertTrue(imageAPI.cancelImageRequestWasCalled)
    }
}


fileprivate class  MockFileReader: FileReaderble {
    let hasError: Bool
    init(hasError:Bool = false) {
        self.hasError = hasError
    }
    
    func loadFile(name: String, fileExtension: String) throws -> [String] {
        if !hasError{
            return [String]()
        }else{
            throw FileReaderError.invalidFileName
        }
    }
    
    
}
