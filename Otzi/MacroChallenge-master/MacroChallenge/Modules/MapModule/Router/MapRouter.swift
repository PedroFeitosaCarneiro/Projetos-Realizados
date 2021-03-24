//import Foundation
//import UIKit
//
//class MapRouter: MapRouterToPresenter{
//    
//    private let instaAPI:InstaPostsAPI
//    private let imageAPI: ImageAPI
//    
//    
//    init(instaAPI: InstaPostsAPI, imageAPI: ImageAPI) {
//        self.instaAPI = instaAPI
//        self.imageAPI = imageAPI
//    }
//    
//    func createMapModule() -> UIViewController {
//        let reference = MapView()
//        let presenter: MapPresenterToView & MapPresenterToInteractor = MapPresenter()
//        let interactor = MapInteractor()
//        
//        reference.presenter = presenter
//        reference.presenter?.router = self
//        reference.presenter?.view = reference
//        presenter.interactor = interactor
//        interactor.presenter = presenter
//        
//        return reference //as UIViewController
//    }
//    
//    func sendDataToNextView(hashtag: HashtagSuggest, from: UIViewController) {
//        
//        let feedRouter = FeedRouter(serviceAPI: instaAPI, imageAPI: imageAPI)
//        let vc = feedRouter.startViewController(with: [hashtag], on: nil)
//        from.navigationController?.pushViewController(vc, animated: true)
//        
//    }
//    
//    func callSearchView(from view: UIViewController, to: SearchViewController) {
//        view.pushDownFading(to)
//        
//    }
//    
//}
