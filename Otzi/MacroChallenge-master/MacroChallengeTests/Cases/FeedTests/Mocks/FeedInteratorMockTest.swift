//
//  FeedInteratorMockTest.swift
//  MacroChallengeTests
//
//  Created by Rangel Cardoso Dias on 09/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit
@testable import MacroChallenge



class FeedInteratorMockTest: FeedInteratorToPresenter {
   
    
   
    
    let hasError: Bool
    
    let isDataEmpty: Bool
    
    var cancelFetchFetchImageWasCalled = false
    var viewWillDismissWasCalled = false
    var presenter: FeedPresenterToInterator?
    
    func fetchImage(with url: String, completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        if hasError{
            completion(.failure(ServiceError.apiError))
        }else{
            completion(.success(UIImage()))
        }
        return nil
    }
    
    func cancelFetchImage(by uuid: UUID?) {
        cancelFetchFetchImageWasCalled = true
    }
    
    
    func viewWillDismiss() {
        viewWillDismissWasCalled = true
    }

    init(presenter: FeedPresenterToInterator?, with error: Bool = false,isDataEmpty: Bool = false) {
        self.presenter = presenter
        self.hasError = error
        self.isDataEmpty = isDataEmpty
    }
    
    func fetchData() {
        if hasError{
            self.presenter?.fetchDataFailed(error: .apiError)
        }else{
            self.presenter?.fetchedDataSucessefully(data: getStubData())
        }
    }
    
    
    
    private func getStubData()-> [Post]{
        return isDataEmpty ? [Post]() : [Post(node: NodePost(imageUrl: "dsds", isVideo: false,descriptions:  Descriptions(descriptions: [Description]()), shortcode: "")), Post(node: NodePost(imageUrl: "dsds", isVideo: false,descriptions:  Descriptions(descriptions: [Description]()), shortcode: "")),Post(node: NodePost(imageUrl: "dsds", isVideo: false,descriptions:  Descriptions(descriptions: [Description]()), shortcode: ""))]
    }
}
