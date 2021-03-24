//
//  ExploreRouterTest.swift
//  MacroChallengeTests
//
//  Created by Rangel Cardoso Dias on 06/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import XCTest
@testable import MacroChallenge

class ExploreRouterTest: XCTestCase {

    
    var naviController: UINavigationController!
    var sut: ExploreRouter!

    override func setUp() {
       
        
        
        
        sut = ExploreRouter(tabBarDelegate: MockTabBar(), dataManger: CoreDataManager())
        let vc = sut.startViewController()
//        vc.viewDidLoad()
        naviController = UINavigationController(rootViewController:vc)
        
        if let appWindow = UIApplication.shared.delegate?.window {
            
            appWindow?.rootViewController = naviController
        }
    }
    override func tearDown() {
        naviController = nil
        sut = nil
    }
    
    
    
    func testGoToFeed(){
        sut.goToFeed(hashtags: [HashtagSuggest](), from: naviController.viewControllers.first!)
        XCTAssertTrue(naviController.visibleViewController! is FeedViewController)
    }
    
    func testGoToMap(){
        
        sut.goToMapView(from: naviController.viewControllers.first!)
        RunLoop.current.run(until: Date())//Espero para que a animação de transição seja completa
        XCTAssertTrue(naviController.topViewController is MapView)
    }
    
    func testGoToSeachByText(){
        sut.goToSearchView(from: naviController.viewControllers.first!)
        RunLoop.current.run(until: Date())//Espero para que a animação de transição seja completa
        XCTAssertTrue(naviController.topViewController is HashtagIntermediateView)
    }
    
    
    func testCreateModuleExplore(){
        let vc = sut.startViewController()
        XCTAssertTrue(vc is ExploreViewController)
    }
}

fileprivate class MockTabBar: TabBarToView{
    func showTabBar() {
        print("")
    }
    
    func hideTabBar() {
        print("")
    }
    
    func changeTabBarState(tabBar state: TabBarState) {
        print("")
    }
    
    var didTapConfirmButton: (() -> ()) = {}
    
    
    public init(){}
    
}
