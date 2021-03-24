//
//  PreFeedPresenter.swift
//  MacroChallenge
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 08/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit


class PreFeedPresenter: PreFeedPresenterToView{
    

    
    var router: PreFeedRouter?
    var view: PreFeedViewToPresenter?
    var interactor: PreFeedInteractorToPresenter?
    
    func requestHashtagImages(with post: PreFeedData, from section: String, at indexPath: IndexPath) {
        interactor?.getHashtagImage(with: post,from: section, at: indexPath)
    }
    
    func goToFeed(with hashtag: [HashtagSuggest], with section: PreFeedSection?) {
        let vc = view as! PreFeedView
        router?.goToFeedModule(with: hashtag, from: vc, with: section)
    }
    
    
    func willDismiss() {
        interactor?.willDismiss()
    }
    
    func getPostsCache(from section: String) -> [PreFeedData]? {
        return interactor?.getPostsCache(from: section)
    }
    
    func pauseImageRequest(at index: IndexPath) {
        interactor?.pauseImageRequest(at: index)
    }
    
    func getPosts(with hashtag: [HashtagSuggest]) {
        interactor?.getPreFeedPosts(hashtag: hashtag[0].text)
    }
    
}


extension PreFeedPresenter: PreFeedPresenterToInteractor{
    func sendErrorMessage() {
        self.view?.showErrorMessage()
    }
    
    
    func preFeedImageFetched(with image: UIImage, at indexPath: IndexPath,post: PreFeedData) {
        self.view?.getFetchedImage(with: image, at: indexPath, post: post)
    }
    
    func preFeedSectionsFetched(with section: [PreFeedSection]) {
        self.view?.getFetchedSections(with: section)
    }
    
    func internetFailed() {
        interactor?.internetFailed()
    }
    

    
}
