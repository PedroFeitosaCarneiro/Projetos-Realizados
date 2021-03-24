//
//  SceneDelegate.swift
//  MacroChallenge
//
//  Created by Fábio França on 01/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
//    let log = Logger()
//    let router = LoginRouter()
//    var vc: SplashScreenViewController? = nil
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        //self.window =  UIWindow(frame: UIScreen.main.bounds)
        //        layout.itemSize = CGSize(width: 170, height: 200)
        //        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        //        let l = FeedCustomLayout()
        //                l.delegate = vc
        
        NetStatus.shared.startMonitoring()
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let windowScene:UIWindowScene = scene as! UIWindowScene;
        self.window = UIWindow(windowScene: windowScene)
        //self.window =  UIWindow(frame: UIScreen.main.bounds)
        
        let lauchScreenController = LauchScreenViewController()
        self.window?.rootViewController = lauchScreenController
        self.window?.makeKeyAndVisible()
        
//
//
//        let naviExplorer = UINavigationController()
//        naviExplorer.title = "Feed"
//        let naviFavorites = UINavigationController()
//        naviFavorites.title = "Star"
//
//
//        let serviceAPI = InstaPostsAPI(manager: RequestManagerFactory.alamofire.create())
//        let imageAPI = ImageAPI(manager: RequestManagerFactory.alamofire.create())
//        let dataManager = CoreDataManager()
//
//        let routerFavorites = UserFavoritesRouter(imageAPI: imageAPI, dataManager: dataManager, serviceAPI: serviceAPI)
//        let routerExplore = ExploreRouter(serviceAPI: serviceAPI, imageAPI: imageAPI, dataManger: dataManager)
//
//        let vcExplorer = routerExplore.startViewController() as! ExploreViewController
//        let vcFavorites = routerFavorites.startViewControllers() as! FavoritesViewController
//
//
//        naviExplorer.setViewControllers([vcExplorer], animated: false)
//        naviFavorites.setViewControllers([vcFavorites], animated: false)
        
//        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        
 
        
        
//        return
//
//
//
//        if hasSeenOnboarding{
//            log.delegate = self
//            log.certificate()
//
//            vc = SplashScreenViewController(logger: log)
//            self.window?.rootViewController = vc
//            self.window?.makeKeyAndVisible()
////            vc?.loadInicialVideo(time: .now() + .seconds(6))
//
//            if !Connectivity.isConnectedToInternet{
//                self.vc?.setupNetWithoutInternet()
//            }
//
//            NetStatus.shared.netStatusChangeHandler = { [self] in
//                if !Connectivity.isConnectedToInternet{
//                    self.vc?.setupNetWithoutInternet()
//                }else{
//                    self.vc?.reloadScreen()
//                }
//            }
//
//
//            return
//        }else{
//
//        }
//
//        if !hasSeenOnboarding{
////            vc?.loadInicialVideo(time: .now() + .seconds(6), completion: {
//                self.window?.rootViewController = OnboardingRouter().startModule()
////            })
//        }else{
//
//            self.window?.rootViewController = TabBarFactory.createTabBar(with: [naviExplorer,naviFavorites])
//        }
//
//
//
//        //        let view = LoginRouter().createLoginModule()
//        //
//        //        self.window?.rootViewController = view
//
//        //self.window?.rootViewController = tabbar
//        self.window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? CoreDataStack)?.saveContext()
    }
    
    
}


//
//extension SceneDelegate: notifyInstagram, LoginAutheticated{
//    func didLogin() {
//        print("dd")
//    }
//
//
//
//
//
//    func isLogged(_ result: Bool) {
//
//        if result {
//
//            let naviExplorer = UINavigationController()
//            naviExplorer.title = "Feed"
//            let naviFavorites = UINavigationController()
//            naviFavorites.title = "Star"
//
//
//            let serviceAPI = InstaPostsAPI(manager: RequestManagerFactory.alamofire.create())
//            let imageAPI = ImageAPI(manager: RequestManagerFactory.alamofire.create())
//            let dataManager = CoreDataManager()
//
//            let routerFavorites = UserFavoritesRouter(imageAPI: imageAPI, dataManager: dataManager, serviceAPI: serviceAPI)
//            let routerExplore = ExploreRouter(serviceAPI: serviceAPI, imageAPI: imageAPI, dataManger: dataManager)
//
//            let vcExplorer = routerExplore.startViewController() as! ExploreViewController
//            let vcFavorites = routerFavorites.startViewControllers() as! FavoritesViewController
//
//
//            naviExplorer.setViewControllers([vcExplorer], animated: false)
//            naviFavorites.setViewControllers([vcFavorites], animated: false)
//
//
//            let v = TabBarFactory.createTabBar(with: [naviExplorer,naviFavorites])
//            v.modalPresentationStyle = .fullScreen
//            vc?.present(v, animated: true, completion: nil)
//
//        }else{
//
//            let page = OnboardingRouter().startModule()
//            page.modalPresentationStyle = .fullScreen
//            vc?.present(page, animated: true, completion: nil)
//
//
//        }
//
//
//
//    }
//
//
//}
//
//

