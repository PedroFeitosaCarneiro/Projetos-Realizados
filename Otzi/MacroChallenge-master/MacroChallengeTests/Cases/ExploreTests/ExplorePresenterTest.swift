//
//  ExplorePresenterTest.swift
//  MacroChallengeTests
//
//  Created by Rangel Cardoso Dias on 09/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import XCTest
@testable import MacroChallenge
class ExplorePresenterTest: XCTestCase {

    var sut: ExplorePresenter!
    fileprivate var router: ExploreRouterMock!
    fileprivate var interator: ExploreInteratorMock!
    override func setUp() {
        sut = ExplorePresenter()
        router = ExploreRouterMock()
        interator = ExploreInteratorMock()
        sut.router = router
        sut.interator = interator
    }
    override func tearDown() {
        sut = nil
        router = nil
        interator = nil
    }
    
    func testRouterWasCalledWhenGoToMapTrigged(){
        sut.goToMapView(from: UIViewController())
        XCTAssertTrue(router.goToMapViewWasCalled)
    }
    
    func testRouterWasCalledWhenGoToFeedTrigged(){
        sut.goToFeed(hashtags: [HashtagSuggest](), from: UIViewController())
        XCTAssertTrue(router.goToFeedWasCalled)
    }
    
    func testRouterWasCalledWhenGoToSearchView(){
        sut.goToSearchView(from: UIViewController())
        XCTAssertTrue(router.goToSearchViewWasCalled)
    }
    
    func testFetchHastagWasCalledInInterator(){
        sut.fetchHashtags()
        XCTAssertTrue(interator.fetchHashtagsWasCalled)
    }

}
fileprivate class ExploreRouterMock: ExploreRouterToPresenter{
    
    var goToFeedWasCalled = false
    var goToSearchViewWasCalled = false
    var goToMapViewWasCalled = false
    
    func goToFeed(hashtags: [HashtagSuggest], from controller: UIViewController) {
        goToFeedWasCalled = true
    }
    
    func goToMapView(from controller: UIViewController) {
        goToMapViewWasCalled = true
    }
    
    func goToSearchView(from controller: UIViewController) {
        goToSearchViewWasCalled = true
    }
    
    
}

fileprivate class ExploreInteratorMock: ExploreInteratorToPresenter{
    var presenter: ExplorePresenterToInterator?
    
    
    var fetchHashtagsWasCalled = false
    var fetchHashtagImageWasCalled = false
    var cancelFetchImageWasCalled = false
    var fetchImageWasCalled = false
    
    func fetchHashtags() {
        fetchHashtagsWasCalled = true
    }
    
    func fetchImage(with url: String, completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        fetchImageWasCalled = true
        return nil
    }
    
    func fetchHashtagImage(from hashtag: HashtagSuggest, completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        fetchHashtagImageWasCalled = true
        return nil
    }
    
    func cancelFetchImage(by uuid: UUID?) {
        cancelFetchImageWasCalled = true
    }
    
    
}
