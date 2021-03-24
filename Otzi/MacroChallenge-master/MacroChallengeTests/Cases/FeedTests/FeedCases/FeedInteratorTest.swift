//
//  FeedInteratorTest.swift
//  MacroChallengeTests
//
//  Created by Rangel Cardoso Dias on 08/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import XCTest
@testable import MacroChallenge
class FeedInteratorTest: XCTestCase {

    func testFetchDataShouldAskServiceNetworkLayerToFetch(){
        
        let serviceLayer = ServiceAPILayer(manager: RequestManagerFactory.alamofire.create())
        
        let sut = FeedInterator(serviceAPI: serviceLayer, imageAPI: ImageAPILayer(manager: RequestManagerFactory.alamofire.create()), hashtagsSearched: [HashtagSuggest]())
        
        
        sut.fetchData()
        
        
        XCTAssertTrue(serviceLayer.getPostWasCalled, "Método da serviceLayer reques deve ser chamado")
        
        
    }
    
    
    func testgetImageShouldAskImageApiLayerToGet(){
        
        let serviceLayer = ServiceAPILayer(manager: RequestManagerFactory.alamofire.create())
        let imageAPI = ImageAPILayer(manager: RequestManagerFactory.alamofire.create())
        let sut = FeedInterator(serviceAPI: serviceLayer, imageAPI: imageAPI, hashtagsSearched: [HashtagSuggest]())
        
        
        let _ = sut.fetchImage(with: "") { (result) in }
        
        
        XCTAssertTrue(imageAPI.getImageWasCalled,"ImageLayer GetImage método deve ser invocado")
        
        
    }
    
    
    func testCancelImageRequestLayerWasCalledWhenPresenterNeedsIt(){
        let serviceLayer = ServiceAPILayer(manager: RequestManagerFactory.alamofire.create())
        let imageAPI = ImageAPILayer(manager: RequestManagerFactory.alamofire.create())
        let sut = FeedInterator(serviceAPI: serviceLayer, imageAPI: imageAPI, hashtagsSearched: [HashtagSuggest]())
        let presenter = FeedPresenter()
        sut.presenter = presenter
        presenter.interator = sut
        
        presenter.cancelFetchImage(by: UUID())
        
        
        XCTAssertTrue(imageAPI.cancelImageRequestWasCalled,"O método de cancelar a request da image Api deve ser chamado quando o presenter solicitar para o interator")
    }
    
}





public class ServiceAPILayer:  InstaPostsAPI{
   
    var getPostWasCalled: Bool = false
    
    public override func getPostsWith(hashtag tag: String, endCursor: String, completion: @escaping (Result<Graphql, Error>) -> Void) {
        
        getPostWasCalled = true
    }

}


public class ImageAPILayer:  ImageAPI{
   
    var getImageWasCalled: Bool = false
    var cancelImageRequestWasCalled: Bool = false
    public override func getImageWith(url baseURL: String, completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        getImageWasCalled = true
        return nil
    }
    
    override public func cancelLoadRequest(uuid: UUID) {
        cancelImageRequestWasCalled = true
    }

}
