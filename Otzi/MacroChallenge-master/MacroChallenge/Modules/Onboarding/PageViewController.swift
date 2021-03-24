//
//  PageViewController.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 26/10/20.
//  Copyright © 2020 macro.com. All rights reserved.

import UIKit
import AVKit
/// Enum que representa as páginas do onboarding
public enum OnboardingPages{
    
    case initial
    case step1
    case step2
    case loginPage
  
    
    /// A viewController referente a cada page
    var vc: UIViewController {
        switch self {
        case .initial:
            return FirstViewController(pageModel: OnboardingPages.modelInitial)
        case .step1:
            return FirstViewController(pageModel: OnboardingPages.model1)
        case .step2:
            return OnBoardViewController(pageModel: OnboardingPages.model2)
        case .loginPage:
            return OnBoardViewController(pageModel: OnboardingPages.model2)//LoginViewController(pageModel: OnboardingPages.model2)
        }
    }

    var index: Int {
        switch self {
        case .initial:
          return 0
          case .step1:
            return 1
          case .step2:
              return 2
        case .loginPage:
            return 2
     
        }
      }
    
    //MARK: -> Models de cada página
    fileprivate static let modelInitial = PageModel(content: [], title: "How about exploring a new universe?", subTitle: "Drag to the side", onboarding: .initial)
    fileprivate static let model1 = PageModel(content: [], title: "Meet thousands of artists and find the best real references.", subTitle: nil, onboarding: .step1)

    fileprivate static let hashtags: [HashtagSuggest] = [HashtagSuggest(text: "MinimalistTattoo"),HashtagSuggest(text: "WaterColorTattoo"),HashtagSuggest(text: "RealismTattoo"),HashtagSuggest(text: "OldSchoolTattoo"),HashtagSuggest(text: "TribalTattoo"),HashtagSuggest(text: "CartoonTattoo")]
    fileprivate static let model2 = PageModel(content: OnboardingPages.hashtags, title: "Which tattoo style do you like most?", subTitle: "You can choose more than one!", onboarding: .step2)
    
//    fileprivate static let loginModel = PageModel(content: OnboardingPages.hashtags, title: "To use our app you need to log in your Intagram account.", subTitle: "We will never post anything without your permission", onboarding: .loginPage)
    
}

    
    




class PageViewController: UIViewController {

    var pageView: UIPageViewController!
    var pageModel: PageOnBoardingModel!
    
    var userItens: [HashtagSuggest] = []
    
    var presenter: OnboardingPresenterToView? = nil
    
    private var currentView: OnboardingPages?
    private var scrollView: UIScrollView?
    
    var playerController = AVPlayerViewController()

    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.pageModel.getVC(by: .initial),
                self.pageModel.getVC(by: .step1),
                self.pageModel.getVC(by: .step2)
                ]//self.pageModel.getVC(by: .loginPage)
    }()
    
    
//    let logger = Logger()
//    var isLogged = false
    init(pageModel: PageOnBoardingModel) {
        self.pageModel = pageModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        logger.delegate = self
//
//        logger.certificate()
        
        pageView = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageView.view.isUserInteractionEnabled = true
        
        pageView.dataSource = self
        pageView.delegate = self
        pageView.view.backgroundColor = .clear
        pageView.view.frame = CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height)
        self.addChild(pageView)
        self.view.addSubview(pageView.view)
        pageView.didMove(toParent: self)
        let vc = pageModel.getVC(by: .initial)
        vc.pageDelegate = self
        currentView = .initial
        pageView.setViewControllers([vc as UIViewController], direction: .forward, animated: true, completion: nil)
    
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
        
//        DispatchQueue.main.asyncAfter(deadline: time) {
//            self.presenter?.didFinishProcessAllData()
//            self.playerController.dismiss(animated: false) {
//                completion?()
//            }
//        }
        
    }

}
extension PageViewController: notifyInstagram, LoginAutheticated{
   
    
    func isLogged(_ result: Bool) {
//        self.isLogged = result
    }
    
    func didLogin() {
        self.view.addSubview(LoadingScreen(frame: self.view.frame))
        presenter?.userInformationCollected(data: userItens)
    }
    
    
}


extension PageViewController: UIPageViewControllerDelegate,UIPageViewControllerDataSource, WalkThroughOnBoardDelegate{
    func skipOnboarding() {
        presenter?.didFinishProcessAllData()
    }
    
    
    func didFinishPage(with data: [HashtagSuggest]) {
        userItens = data
    }
    
    
    /// Implementação do WalkThroughOnBoardDelegate chamado quando o botão de próximo é clicado
    /// - Parameter page: página que deve ir
    func goNextPage(fowardTo page: OnboardingPages?) {
//        if let p = page, p == .loginPage{
//            pageView.scrollView?.isScrollEnabled = false
//        }
        scrollView?.isScrollEnabled = true
        guard let page = page else {
            
            self.view.addSubview(LoadingScreen(frame: self.view.frame))
            presenter?.userInformationCollected(data: userItens)

            loadInicialVideo(time: .now() + .seconds(4))
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
                self.playerController.dismiss(animated: false)
                self.presenter?.didFinishProcessAllData()
            }
//            let vc = pageModel.getVC(by: .loginPage) as! LoginViewController
//            if !isLogged, !vc.didTapLogInAsGuest{
//                let router = LoginRouter()
//                let vc = router.createLoginModule() as! LoginView
//                vc.delegage = self
//                self.present(vc, animated: true, completion: nil)
//            }else{
//                self.view.addSubview(LoadingScreen(frame: self.view.frame))
//                presenter?.userInformationCollected(data: userItens)
//            }
            return
        }
        let viewController = pageModel.getVC(by: page)
        viewController.pageDelegate = self
        pageView.setViewControllers([viewController], direction:
                 UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        
    }
    
    /// Implementação do WalkThroughOnBoardDelegate chamado quando o botão de voltar é clicado
    /// - Parameter page: página que deve ir
    func goBeforePage(reverseTo page: OnboardingPages?) {
        guard let page = page else {return}
        let viewController = pageModel.getVC(by: page)
        viewController.pageDelegate = self
        pageView.setViewControllers([viewController], direction:
            UIPageViewController.NavigationDirection.reverse, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        let vc = orderedViewControllers[nextIndex]
        (vc as! OnboardingPage).pageDelegate = self
        return vc
    }

    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let vc = previousViewControllers.first, let viewControllerIndex = orderedViewControllers.firstIndex(of: vc) else {
            pageView.scrollView?.isScrollEnabled = true
            return
        }
        
        if completed,viewControllerIndex == 0 {
            pageView.scrollView?.isScrollEnabled = false
        }
        
    }
    
}




extension UIPageViewController {

    public var scrollView: UIScrollView? {
        for view in self.view.subviews {
            if let scrollView = view as? UIScrollView {
                return scrollView
            }
        }
        return nil
    }

}
