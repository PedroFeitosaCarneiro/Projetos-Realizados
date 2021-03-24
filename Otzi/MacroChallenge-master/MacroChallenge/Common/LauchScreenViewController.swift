//
//  LauchScreenViewController.swift
//  MacroChallenge
//
//  Created by Lelio Jorge Junior on 19/11/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit
import AVKit

class LauchScreenViewController: UIViewController {
    
    var playerController = AVPlayerViewController()
    
    let log = Logger()
    let router = LoginRouter()
    var vc: SplashScreenViewController? = nil
    
    override func viewDidLoad() {
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        
        loadInicialVideo(time: .now() + .seconds(4), completion: {
        self.view.backgroundColor = UIColor(red: 228/255, green: 227/255, blue: 223/255, alpha: 1.0)
            hasSeenOnboarding ?  self.goToFeed() : self.goToOnboard()
        })
    }
    
    func loadInicialVideo(time: DispatchTime, completion: (() -> ())? = nil) {
        DispatchQueue.main.async { [self] in
            guard let path = Bundle.main.path(forResource: "LauchScreenVideo", ofType:".mp4") else {
                debugPrint("video.m4v not found")
                return
            }
            
            let player = AVPlayer(url: URL(fileURLWithPath: path))
            
            playerController.player = player
            playerController.videoGravity = .resizeAspectFill
            playerController.showsPlaybackControls = false
            present(playerController, animated: false) {
                player.isMuted = true
                player.play()
            }
        }
        
        guard completion != nil else {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: time) { [self] in
            playerController.dismiss(animated: false) {
                completion?()
            }
        }
        
    }
    
    func goToOnboard() {
        
        let OBController = OnboardingRouter().startModule()
        OBController.modalPresentationStyle = .fullScreen
        self.present(OBController, animated: false, completion: nil)
    }
    
    func goToConnect() {
        log.delegate = self
        log.certificate()
        
        vc = SplashScreenViewController(logger: log)
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: false, completion: nil)
        
        if !Connectivity.isConnectedToInternet{
            self.vc?.setupNetWithoutInternet()
        }
        
        NetStatus.shared.netStatusChangeHandler = { [self] in
            if !Connectivity.isConnectedToInternet{
                self.vc?.setupNetWithoutInternet()
            }else{
                self.vc?.reloadScreen()
            }
        }
        
    }
    func goToFeed() {
        let naviExplorer = UINavigationController()
        naviExplorer.title = "Feed"
        let naviFavorites = UINavigationController()
        naviFavorites.title = "Star"
        
        
        let serviceAPI = InstaPostsAPI(manager: RequestManagerFactory.alamofire.create())
        let imageAPI = ImageAPI(manager: RequestManagerFactory.alamofire.create())
        let dataManager = CoreDataManager()
        
        let routerFavorites = UserFavoritesRouter(imageAPI: imageAPI, dataManager: dataManager, serviceAPI: serviceAPI)
        let routerExplore = ExploreRouter(serviceAPI: serviceAPI, imageAPI: imageAPI, dataManger: dataManager)
        
        let vcExplorer = routerExplore.startViewController() as! ExploreViewController
        let vcFavorites = routerFavorites.startViewControllers() as! FavoritesViewController
        
        
        naviExplorer.setViewControllers([vcExplorer], animated: false)
        naviFavorites.setViewControllers([vcFavorites], animated: false)
        
        
        let v = TabBarFactory.createTabBar(with: [naviExplorer,naviFavorites])
        v.modalPresentationStyle = .fullScreen
        self.present(v, animated: false, completion: nil)
    }
}

extension LauchScreenViewController: notifyInstagram, LoginAutheticated{
    func didLogin() {
//        print("dd")
    }
    
    
    
    
    
    func isLogged(_ result: Bool) {
        Logger.isLogged = result
        if result {
            
            let naviExplorer = UINavigationController()
            naviExplorer.title = "Feed"
            let naviFavorites = UINavigationController()
            naviFavorites.title = "Star"
            
            
            let serviceAPI = InstaPostsAPI(manager: RequestManagerFactory.alamofire.create())
            let imageAPI = ImageAPI(manager: RequestManagerFactory.alamofire.create())
            let dataManager = CoreDataManager()
            
            let routerFavorites = UserFavoritesRouter(imageAPI: imageAPI, dataManager: dataManager, serviceAPI: serviceAPI)
            let routerExplore = ExploreRouter(serviceAPI: serviceAPI, imageAPI: imageAPI, dataManger: dataManager)
            
            let vcExplorer = routerExplore.startViewController() as! ExploreViewController
            let vcFavorites = routerFavorites.startViewControllers() as! FavoritesViewController
            
            
            naviExplorer.setViewControllers([vcExplorer], animated: false)
            naviFavorites.setViewControllers([vcFavorites], animated: false)
            
            
            let v = TabBarFactory.createTabBar(with: [naviExplorer,naviFavorites])
            v.modalPresentationStyle = .fullScreen
            vc?.present(v, animated: true, completion: nil)
            
        }else{
            
            let page = OnboardingRouter().startModule()
            page.modalPresentationStyle = .fullScreen
            vc?.present(page, animated: true, completion: nil)
            
            
        }
        
        
        
    }
    
    
}


