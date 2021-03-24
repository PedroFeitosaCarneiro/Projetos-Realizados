//
//  ExploreRouter.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 24/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit
class ExploreRouter: ExploreRouterToPresenter{
   
   
    
    private let instaAPI:InstaPostsAPI
    private let imageAPI: ImageAPI
    private var interator: ExplorerInterator!
    private let dataManger: CoreDataManager
    init(serviceAPI: InstaPostsAPI = InstaPostsAPI(manager: RequestManagerFactory.alamofire.create()), imageAPI: ImageAPI = ImageAPI(manager: RequestManagerFactory.alamofire.create()), dataManger: CoreDataManager) {
        
        self.instaAPI = serviceAPI
        self.imageAPI = imageAPI
        self.dataManger = dataManger
        interator = ExplorerInterator(serviceAPI: instaAPI, imageAPI: imageAPI, dataManeger: dataManger)
    }
    
    func goToFeed(hashtags: [HashtagSuggest], from controller: UIViewController) {
        
        let feedRouter = FeedRouter(serviceAPI: instaAPI, imageAPI: imageAPI)
        
        
        
        let vc = feedRouter.startViewController(with: hashtags, on: nil)
        
        vc.modalPresentationStyle = .fullScreen
        
        controller.pushDownFading(vc)
                
    }
    
    func goToPreFeed(hashtags: [HashtagSuggest], from controller: UIViewController) {
        
        var vc: UIViewController
        
//        
//        if Logger.isLogged{
//            let preFeedRouter = PreFeedRouterModule(serviceAPI: instaAPI, imageAPI: imageAPI)
//            vc = preFeedRouter.createPreFeedModule(with: hashtags)
//        }else{
//            let feedRouter = FeedRouter(serviceAPI: instaAPI, imageAPI: imageAPI)
//
//
//
//            vc = feedRouter.startViewController(with: hashtags, on: nil)
//        }
        
        let preFeedRouter = PreFeedRouterModule(serviceAPI: instaAPI, imageAPI: imageAPI)
        vc = preFeedRouter.createPreFeedModule(with: hashtags)
        
        vc.modalPresentationStyle = .fullScreen
        
        controller.pushDownFading(vc)
    }
    
    
    
    func goToMapView(from controller: UIViewController) {
//        let router  = MapRouter(instaAPI: instaAPI, imageAPI: imageAPI)
//        let vc  = router.createMapModule()
//        
//        vc.modalPresentationStyle = .fullScreen
//        controller.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func goToSearchView(from controller: UIViewController) {

        let router  = HashtagSearchRouter(instaAPI: instaAPI, imageAPI: imageAPI)
        let vc  = router.createSearchModule()
        vc.modalPresentationStyle = .fullScreen
        controller.navigationController?.pushViewController(vc, animated: true)
    }
    

    
    func startViewController()-> UIViewController{
        let vc = ExploreViewController()
        let presenter = ExplorePresenter()
        vc.presenter = presenter
        presenter.router = self
        presenter.interator = interator
        interator.presenter = presenter
        presenter.view = vc
        return vc
    }
    
    
}
