//
//  ClassesMock.swift
//  MacroChallengeTests
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 21/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import XCTest
import MapKit
@testable import MacroChallenge

//ok
class MockViewDelegate: MapViewToPresenter {
    var presenter: MapPresenterToView?
    var isTested = false
    
    func sendToPresenter() {
        isTested = true
    }
    
    func load(){
        sendToPresenter()
    }
    
}

//ok
class MockPresenterDelegate: MapPresenterToView, MapPresenterToInteractor{
    
    
    var view: MapViewToPresenter?
    var router: MapRouterToPresenter?
    var interactor: MapInteractorToPresenter?
    
    var isTested = false
    var isTestedOne = false
    
    
    func informPlaceToInteractor(_ place: MKPlacemark) {
        isTestedOne = true
    }
    
    func informPlaceBackToView(_ place: String) {
        isTested = true
    }
    

    func load(placeS: String, placeT: MKPlacemark){
        informPlaceBackToView(placeS)
        informPlaceToInteractor(placeT)
    }
    
    func informPlaceToInteractor(_ place: MKPlacemark, from view: UIViewController) {
        print("arruma aqui")
    }
    
    func callRouterToShowSearch(from view: UIViewController, to: SearchViewController) {
        print( "arruma aqui")
    }
    
    func informPlaceBackToView(_ place: HashtagSuggest, from view: UIViewController) {
        print("arruma aqui")
    }
    
}

//ok
class MockInteratorDelegate: MapInteractorToPresenter{
    func informPlaceToHandler(_ place: MKPlacemark, from view: UIViewController) {
        print("arruma aqui")
    }
    
    var presenter: MapPresenterToInteractor?
    
    func informPlaceToHandler(_ place: MKPlacemark) {
        isTested = true
    }
    
    var isTested = false
    
    func load(place: MKPlacemark){
        informPlaceToHandler(place)
    }
    
}

//ok
class MockRouter: MapRouterToPresenter{

    
    func sendDataToNextView(hashtag: HashtagSuggest, from view: UIViewController) {
        print("arruma aqui")
    }
    
    func callSearchView(from view: UIViewController, to: SearchViewController) {
        print("arruma aqui")
    }
    
    static var isTested = false
    
    func createMapModule() -> UIViewController {
        MockRouter.isTested = true
        return UIViewController()
    }
    
    static func load(){
//        createMapModule()
    }
    
}

//ok
class MockMapHandler: HandleMapSearch{
    
    var isTested = false
    var isTestedOne = false
    var isTestedTwo = false
    
    func dropPin(placemark: MKPlacemark) {
        isTested = true
    }
    
    func setupGestureDelegate() {
        isTestedOne = true
    }
    
    func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        isTestedTwo = true
    }
    
    func load(placeMark: MKPlacemark){
        dropPin(placemark: placeMark)
        setupGestureDelegate()
        handleTap(gestureRecognizer: UILongPressGestureRecognizer())
    }
    
}

class MockController {
    var view: MapViewToPresenter?
    var router: MapRouterToPresenter?
    var interactor: MapInteractorToPresenter?
    var presenter: MapPresenterToView?
    
    
    
    
    
}
