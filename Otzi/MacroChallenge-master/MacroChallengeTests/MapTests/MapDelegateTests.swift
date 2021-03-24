//
//  MapControllerTest.swift
//  MacroChallengeTests
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 21/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import XCTest
@testable import MacroChallenge
import MapKit

class DelegateTests: XCTestCase {
    
    var controller = MockController()
    
    var interactor = MockInteratorDelegate()
    var presenter = MockPresenterDelegate()
    var view = MockViewDelegate()
    
    
    
    
    func testViewDelegate(){
        controller.view = view
        view.load()
        
        XCTAssert(view.isTested)
        
        
    }
    
    func testPresenterDelegate(){
        presenter.load(placeS: "", placeT: MKPlacemark(coordinate: .init(latitude: 1, longitude: 1)))
        controller.presenter = presenter
        
        
        XCTAssert(presenter.isTested)
        XCTAssert(presenter.isTestedOne)
        
    }
    
    func testInteractorDelegate(){
        controller.interactor = interactor
        interactor.load(place: MKPlacemark(coordinate: .init(latitude: 1, longitude: 1)))
        
        XCTAssert(interactor.isTested)
        
    }
    
    func testRouterDelegate(){
        MockRouter.load()
        
        XCTAssert(MockRouter.isTested)
        
    }
    
    
}

