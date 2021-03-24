//
//  FeedViewControllerTest.swift
//  MacroChallengeTests
//
//  Created by Rangel Cardoso Dias on 10/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import XCTest
@testable import MacroChallenge

class FeedViewControllerTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    private func makeSUT()->FeedViewController{
        let sut = FeedViewController()
        return sut
    }
    
    
    func testViewShouldFetchDataWhenViewIsLoaded(){
        
        let sut = makeSUT()
        let presenter = FeedPresenterMock()
        sut.presenter = presenter
        
        sut.viewDidLoad()
        
        XCTAssertTrue(presenter.fetchDataWasCalled, "Should fetch data when the view is loaded")
        
    }
    
    func testCollectionViewIsPopulatedWhenDataisFetched(){
        
        let sut = makeSUT()
        sut.viewDidLoad()
        sut.showData(posts: getStubData())
        
        XCTAssertGreaterThan(sut.collectionView.numberOfItems(inSection: 0), 1)
        
        
    }
    
    
    
    private func getStubData()-> [Post]{
       
        return [Post(node: NodePost(imageUrl: "dsds", isVideo: false,descriptions:  Descriptions(descriptions: [Description]()), shortcode: "")), Post(node: NodePost(imageUrl: "dsds", isVideo: false,descriptions:  Descriptions(descriptions: [Description]()), shortcode: "")),Post(node: NodePost(imageUrl: "dsds", isVideo: false,descriptions:  Descriptions(descriptions: [Description]()), shortcode: ""))]
    }

}
