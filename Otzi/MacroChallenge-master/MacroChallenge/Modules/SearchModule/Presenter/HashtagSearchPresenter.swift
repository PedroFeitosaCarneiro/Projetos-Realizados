//
//  SearchPresenter.swift
//  MacroChallenge
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 23/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit

class HashtagSearchPresenter: SearchPresenterToInteractor, SearchPresenterToView{
    
    
    
    var interactor: SearchInteractorToPresenter?
    var view: SearchViewToPresenter?
    var router: SearchRouterToPresenter?
    
    
    
    func dataSentToPresenter(value: String, from view: UIViewController) {
        let hashtag = interactor?.formatHashtagTattoo(hashtag: value)
        router?.pushToView(value: hashtag!, from: view)
    }
    
    func callRouterToSearchView(from: UIViewController) {
        router?.moveToSearchView(with: self, from: from)
    }
    
    func saveHashtagIntoDataBase(with hashtag: String) {
        interactor?.saveRecentSearch(with: hashtag)
    }
    
    func getRecentTags(completion: @escaping ([String]) -> ()) {
        interactor?.getRecentSearch(completion: { (result) in
            completion(result)
        })
    }
    func deleteHashtagFromDataBase(with hashtag: String) {
        interactor?.deleteRecentHashtag(with: hashtag)
    }
    
}
