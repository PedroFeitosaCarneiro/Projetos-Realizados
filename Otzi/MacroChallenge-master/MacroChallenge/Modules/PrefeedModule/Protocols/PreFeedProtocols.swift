//
//  PreFeedProtocols.swift
//  MacroChallenge
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 08/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit

protocol PreFeedViewToPresenter: class {
    
    var presenter : PreFeedPresenterToView? {get set}
    
    var sections: [PreFeedSection] {get set}
    
    var hashtags : [HashtagSuggest]? {get set}
    
    
    func getFetchedSections(with section: [PreFeedSection])
    func getFetchedImage(with image: UIImage, at indexPath: IndexPath,post: PreFeedData)
    
    func showErrorMessage()
}

protocol PreFeedPresenterToView: class {
    
    var router : PreFeedRouter? {get set}
    var view : PreFeedViewToPresenter? {get set}
    
    func requestHashtagImages(with post: PreFeedData,from section: String, at indexPath: IndexPath)
    
    func goToFeed(with hashtag: [HashtagSuggest], with section: PreFeedSection?)
    
    func willDismiss()
    
    func getPostsCache(from section: String)->[PreFeedData]?
    
    func pauseImageRequest(at index: IndexPath)
    
    func getPosts(with hashtag : [HashtagSuggest])
    
    func internetFailed()
    
}

protocol PreFeedPresenterToInteractor: class {
    
    var interactor : PreFeedInteractorToPresenter? {get set}
    
    func preFeedSectionsFetched(with section: [PreFeedSection])
    
    func preFeedImageFetched(with image: UIImage, at indexPath: IndexPath, post: PreFeedData)
    
    func goToFeed(with hashtag: [HashtagSuggest], with section: PreFeedSection?)
    
    func sendErrorMessage()
    
    
//    func didFinishFetchRelatedHashtags(hashtags: [HashtagSuggest])
}

protocol PreFeedInteractorToPresenter: class {
    
    var presenter: PreFeedPresenterToInteractor? {get set}
    
    func getHashtagImage(with post: PreFeedData,from section: String, at indexPath: IndexPath)
    
    func willDismiss()
    
    func getPostsCache(from section: String)->[PreFeedData]?
    
    func pauseImageRequest(at index: IndexPath)
    
    func getPreFeedPosts(hashtag: String)
    func internetFailed()

}

protocol PreFeedRouter: class {
    
    func createPreFeedModule(with hashtags: [HashtagSuggest]) -> UIViewController
    
    func goToFeedModule(with hashtag: [HashtagSuggest], from view: PreFeedView, with section: PreFeedSection?)
    
}
