//
//  SearchRouter.swift
//  MacroChallenge
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 23/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit


class HashtagSearchRouter : SearchRouterToPresenter{


    private let instaAPI: InstaPostsAPI
    private let imageAPI: ImageAPI


    init(instaAPI: InstaPostsAPI, imageAPI: ImageAPI) {
        self.instaAPI = instaAPI
        self.imageAPI = imageAPI
    }

    func createSearchModule() -> UIViewController {
        let view = HashtagSearchView(fileParser: FileReader())
        let presenter: SearchPresenterToView & SearchPresenterToInteractor = HashtagSearchPresenter()
        let interactor = HashtagSearchInteractor()

        view.presenter = presenter
        view.presenter?.router = self
        view.presenter?.view = view
        

        presenter.interactor = interactor
        interactor.presenter = presenter
        
        interactor.getRecentSearch { (result) in
            print(result)
        }

//        let intermediateView = HashtagIntermediateView()
//        intermediateView.presenter = presenter
//        intermediateView.presenter?.router = self

      return view
    }


    func pushToView(value: HashtagSuggest, from view: UIViewController){

//        let prefeedRouter = PreFeedRouterModule(serviceAPI: instaAPI, imageAPI: imageAPI)
//        let view = view as! HashtagSearchView
//        let vc = prefeedRouter.createPreFeedModule(with: [value])
//
        
        var vc: UIViewController
        
        
        if Logger.isLogged{
            let preFeedRouter = PreFeedRouterModule(serviceAPI: instaAPI, imageAPI: imageAPI)
            vc = preFeedRouter.createPreFeedModule(with: [value])
        }else{
            let feedRouter = FeedRouter(serviceAPI: instaAPI, imageAPI: imageAPI)

            vc = feedRouter.startViewController(with: [value], on: nil)
        }
        view.navigationController?.pushViewController(vc, animated: true)

    }


    func moveToSearchView(with Reference: SearchPresenterToInteractor & SearchPresenterToView, from: UIViewController) {

        let view = HashtagSearchView(fileParser: FileReader())
        view.presenter = Reference
        view.presenter?.router = self
        view.presenter?.view = view

        from.pushDownFading(view)

    }


}
