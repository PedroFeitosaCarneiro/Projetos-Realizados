//
//  FeedPresenterTest.swift
//  MacroChallengeTests
//
//  Created by Rangel Cardoso Dias on 09/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import XCTest
@testable import MacroChallenge
class FeedPresenterTest: XCTestCase {

    
    private func makeViewSUT()->FeedViewController{
        return FeedViewController()
    }
    
    private func makeSUT(hasError: Bool = false, isDataEmpty: Bool = false)-> FeedPresenter{
        let presenter = FeedPresenter()
        presenter.interator = FeedInteratorMockTest(presenter: presenter, with: hasError,isDataEmpty: isDataEmpty)
        return presenter
    }
    
    func testPreseterUpdateViewWhenSucessefullFetched(){
        let view = makeViewSUT()
        let presenter = makeSUT()
        presenter.view = view
        
        presenter.fetchData()
        
        XCTAssertEqual(view.appState, ViewState.finished)
    }
    
    
    func testPreseterUpdateViewWhenFetchFailed(){
           let view = makeViewSUT()
           let presenter = makeSUT(hasError: true)
           presenter.view = view
           
           presenter.fetchData()
           
        XCTAssertEqual(view.appState, ViewState.error)
       }
    
    func testPresenterEmptyDataShouldShowError(){
        let view = makeViewSUT()
        let presenter = makeSUT(isDataEmpty: true)
        presenter.view = view
        
        presenter.fetchData()
    
        XCTAssertEqual(view.appState, ViewState.emptyData)
    }
}
