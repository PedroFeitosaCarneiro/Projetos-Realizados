//
//  PreFeedRouter.swift
//  MacroChallenge
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 08/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit


class PreFeedRouterModule: PreFeedRouter{

    private let instaAPI:InstaPostsAPI
    private let imageAPI: ImageAPI
    
    
    init(serviceAPI: InstaPostsAPI, imageAPI: ImageAPI) {
        
        self.instaAPI = serviceAPI
        self.imageAPI = imageAPI
    }
    
    func createPreFeedModule(with hashtags: [HashtagSuggest]) -> UIViewController {
        
        let view = PreFeedView()
        let presenter : PreFeedPresenterToInteractor & PreFeedPresenterToView = PreFeedPresenter()
        let interactor = PreFeedInteractor(serviceAPI: instaAPI, imageAPI: imageAPI, hashtagsSearched: hashtags)
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.interactor?.presenter = presenter
        presenter.view = view
        presenter.router = self
        view.hashtags = hashtags
//        interactor.getPreFeedPosts(hashtag: hashtags[0].text)
        
        
        return view
        
    }
    
    func goToFeedModule(with hashtag: [HashtagSuggest], from view: PreFeedView, with section: PreFeedSection?) {
        
        DispatchQueue.main.async { [self] in
            let feedRouter = FeedRouter(serviceAPI: self.instaAPI , imageAPI: self.imageAPI)
    //        view.navigationController?.pushViewController(feedRouter.startViewController(with: hashtag), animated: true)
            view.pushDownFading(feedRouter.startViewController(with: hashtag, on: section))
            
        }
    }
    
    
}
