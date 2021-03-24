//
//  Router.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 27/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//


import UIKit

class OnboardingRouter: OnboardingRouterToPresenter {
    
    var navi: UINavigationController?
    var myView: UIViewController?
    let dataManager:  CoreDataManager = CoreDataManager()
    func startModule() -> UIViewController {
        let presenter = OnboardingPresenter()
        let interator = OnboardingInterator(dataManager: dataManager)
        presenter.router = self
        presenter.interator = interator
        interator.presenter = presenter
        let vc = PageViewController(pageModel: PageOnBoardingModel())
        vc.presenter = presenter
        self.navi = UINavigationController(rootViewController: vc)
        self.myView = vc
        return self.navi ?? vc
    }
    
    
    func goToExplore(){
       
        let navi = UINavigationController()
        navi.title = "Feed"
        let naviFavorites = UINavigationController()
        naviFavorites.title = "Star"
        
        let router = ExploreRouter(dataManger: dataManager)
        
        let vcExplorer = router.startViewController() as! ExploreViewController
        vcExplorer.modalPresentationStyle = .fullScreen
        //let serviceAPI = InstaPostsAPI(manager: RequestManagerFactory.alamofire.create())
        
        let serviceAPI = InstaPostsAPI(manager: RequestManagerFactory.alamofire.create())
        let imageAPI = ImageAPI(manager: RequestManagerFactory.alamofire.create())
        let dataManager = CoreDataManager()
        
        let routerFavorites = UserFavoritesRouter(imageAPI: imageAPI, dataManager: dataManager, serviceAPI: serviceAPI)
       
        let vcFavorites = routerFavorites.startViewControllers() as! FavoritesViewController
        
//        vcExplorer.tabBarDelegate = tabbar
//        tabbar.modalPresentationStyle = .fullScreen
        
        naviFavorites.setViewControllers([vcFavorites], animated: false)
        navi.setViewControllers([vcExplorer], animated: false)
        
        let tabBar = TabBarFactory.createTabBar(with: [navi,naviFavorites])
        tabBar.modalPresentationStyle = .fullScreen
        
        self.navi?.present(tabBar, animated: true, completion: nil)

        
    }
}
