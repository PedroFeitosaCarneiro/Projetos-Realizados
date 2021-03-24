//
//  ExplorePresenterMock.swift
//  MacroChallengeTests
//
//  Created by Rangel Cardoso Dias on 07/10/20.
//  Copyright © 2020 macro.com. All rights reserved.

import XCTest
@testable import MacroChallenge

class ExplorePresenterMock: ExplorePresenterToView, ExplorePresenterToInterator {
    
    
    var fetchHashtagsWasCalled = false
    var fetchImageWasCalled = false
    var cancelFetchImageWasCalled = false
    var goToFeedWasCalled = false
    var goToMapViewWasCalled = false
    var goToSearchViewWasCalled = false
    var fetchedHashTagsSucessefullyWasCalled = false
    var fetchHashtagFailedWasCalled = false
    
    func fetchHashtags() {
        fetchHashtagsWasCalled = true
    }
    
    func fetchImage(from hashtag: HashtagSuggest, completion: @escaping (UIImage) -> Void) -> UUID? {
        fetchImageWasCalled = true
        return nil
    }
    
    func cancelFetchImage(by uuid: UUID?) {
        cancelFetchImageWasCalled = true
    }
    
    func goToFeed(hashtags: [HashtagSuggest], from controller: UIViewController) {
        goToFeedWasCalled = true
    }
    
    func goToMapView(from controller: UIViewController) {
        goToMapViewWasCalled = true
    }
    
    func goToSearchView(from controller: UIViewController) {
        goToSearchViewWasCalled = true
    }
    
    func fetchedHashTagsSucessefully(hashtags: [HashtagSuggest]) {
        fetchedHashTagsSucessefullyWasCalled = true
    }
    
    func fetchHashtagFailed(error: Error) {
        fetchHashtagFailedWasCalled = true
    }
    
}
