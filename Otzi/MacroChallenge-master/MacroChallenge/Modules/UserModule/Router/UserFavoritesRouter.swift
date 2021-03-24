//
//  UserFavoritesRouter.swift
//  MacroChallenge
//
//  Created by Fábio França on 14/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

class UserFavoritesRouter {
    private let imageAPI: ImageAPI
    private let dataManager: CoreDataManager
    private let serviceAPI: InstaPostsAPI
    
    var mainViewController: FavoritesViewController!
    
    var postsViewController: UserFavoritesViewController!
    var hashtagViewController: FavoriteHashtagsViewController!
    var userPresenter: UserFavoritesPostsPresenter!
    var interactor: UserFavoritesInteractor!
    var favoritesPostsPresenter: FavoritesFolderPostsPresenter!
    
    init(imageAPI: ImageAPI,dataManager: CoreDataManager, serviceAPI: InstaPostsAPI) {
        self.imageAPI = imageAPI
        self.dataManager = dataManager
        self.serviceAPI = serviceAPI
        
        mainViewController = FavoritesViewController()
        postsViewController = UserFavoritesViewController()
        userPresenter = UserFavoritesPostsPresenter()
        interactor = UserFavoritesInteractor(imageAPI: imageAPI,dataManager: dataManager)
        favoritesPostsPresenter = FavoritesFolderPostsPresenter()
        hashtagViewController = FavoriteHashtagsViewController()
    }
    
    func startViewControllers() -> UIViewController {
        mainViewController.dataManager = dataManager
        mainViewController.imageAPI = imageAPI
        let postsViewController = startPostsViewController() as! UserFavoritesViewController
        mainViewController.postsViewController = postsViewController
        let hashtagsViewController = startHashtagViewController()
        mainViewController.hashtagsViewController = hashtagsViewController
        
        mainViewController.addChild(postsViewController)
        mainViewController.addChild(hashtagsViewController)
        
        return mainViewController
    }
    
    private func startPostsViewController() -> UIViewController{
        postsViewController.presenter = userPresenter
        userPresenter.interactor = interactor
        userPresenter.view = postsViewController
        userPresenter.router = self
        
        return postsViewController
    }
    
    private func startHashtagViewController() -> UIViewController {
        //        let tabbar = TabbarBuilder.build(submodules: submodules) as! TabbarController
        
        let presenterExplore = ExplorePresenter()
        let routerExplore = ExploreRouter(serviceAPI: serviceAPI, imageAPI: imageAPI, dataManger: dataManager)
        let interactorExplore = ExplorerInterator(serviceAPI: serviceAPI, imageAPI: imageAPI, dataManeger: dataManager)
        
        presenterExplore.interator = interactorExplore
        presenterExplore.view = hashtagViewController
        presenterExplore.router = routerExplore
        
        interactorExplore.presenter = presenterExplore
        
        hashtagViewController.presenter = presenterExplore
        
        return hashtagViewController
    }
}

extension UserFavoritesRouter: UserFavoritesRouterToPresenter {
    func goToFavoritesFolderPosts(with folder: Folder) {
        let postsController = FavoritesFolderPostsViewController(folder: folder)
        postsController.presenter = favoritesPostsPresenter
        favoritesPostsPresenter.view = postsController
        favoritesPostsPresenter.interactor = interactor
        
        postsViewController.navigationController?.pushViewController(postsController, animated: true)
    }
    
    func logout() {
        let logger = Logger()
        logger.delogar()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {[self] in
            
            
            
            let nav = OnboardingRouter().startModule() as! UINavigationController
            nav.modalPresentationStyle = .fullScreen
            //postsViewController.present(nav, animated: true, completion: nil)
            
            let appDel: SceneDelegate =  postsViewController.view.window?.windowScene?.delegate as! SceneDelegate
            appDel.window?.rootViewController = nav
            postsViewController = nil
            mainViewController = nil
            Cache.removeAllImages()
        }
    }
}


