//
//  FeedPresenterMock.swift
//  MacroChallengeTests
//
//  Created by Rangel Cardoso Dias on 10/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit
@testable import MacroChallenge

class FeedPresenterMock: FeedPresenterToView, FeedPresenterToInterator{
   
    
    
  
   
    var view: FeedViewToPresenter?
    
    var router: FeedRouterToPresenter?
    
    var interator: FeedInteratorToPresenter?
    
    var fetchDataWasCalled = false
    var fetchedDataSucessefullyWasCalled = false
    var fetchDataFailedWasCalled = false
    var fetchedImageSucessefullyWasCalled = false
    var cancelFetchFetchImageWasCalled = false
    var viewWillDismissWasCalled = false
    func fetchData(page: Int) {
        fetchDataWasCalled = true
    }
    
    func fetchedDataSucessefully(data: [Post]) {
        fetchedDataSucessefullyWasCalled = true

    }
    
    func fetchDataFailed(error: ServiceError) {
        fetchDataFailedWasCalled = true
    }
    
    func fetchData() {
        fetchDataWasCalled = true
    }
    
    func fetchImage(with url: String, completion: @escaping (UIImage) -> Void) -> UUID? {
        fetchedImageSucessefullyWasCalled = true
        return nil
    }
    
    func cancelFetchImage(by uuid: UUID?) {
        cancelFetchFetchImageWasCalled = true
    }
    
    func viewWillDismiss(from view: UIViewController) {
        var viewWillDismissWasCalled = true
    }
    
    
}
