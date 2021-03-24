//import Foundation
//import MapKit
//
//class MapPresenter: MapPresenterToView{
//    
//    
//    
//    
//    weak var view: MapViewToPresenter?
//    var router: MapRouterToPresenter?
//    var interactor: MapInteractorToPresenter?
//    
//    var hashtag : HashtagSuggest = .init(text: "nil") {
//        didSet{
//            
//        }
//    }
//    
//    func informPlaceToInteractor(_ place: MKPlacemark, from: UIViewController) {
//        interactor?.informPlaceToHandler(place, from: from)
//        
//    }
//    
//    
//    func callRouterToShowSearch(from view: UIViewController) {
////        router?.callSearchView(from: view, to: <#SearchViewController#>)
//    
//    }
//    
//    func callRouterToShowSearch(from view: UIViewController, to: SearchViewController) {
//        router?.callSearchView(from: view, to: to)
//    }
//    
//    
//}
//
//extension MapPresenter: MapPresenterToInteractor{
//    func informPlaceBackToView(_ place: HashtagSuggest, from: UIViewController) {
//        
//        if place.text == "niltattoo"{
//            print("VALOR NULO")
//            let v = view as! UpdateUIMap
//            v.updateUI()
//        } else {
//            router?.sendDataToNextView(hashtag: place, from: from)
//        }
//        
//        
//    }
//}
