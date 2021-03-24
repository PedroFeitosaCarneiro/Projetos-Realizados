//import Foundation
//import MapKit
//
//class MapInteractor : MapInteractorToPresenter{
//    
//    weak var presenter: MapPresenterToInteractor?
//    
//    func informPlaceToHandler(_ place: MKPlacemark, from: UIViewController) {
//        let data = LocationParser(with: place.coordinate)
//        data.handleLocation { (result) in
//            let hashTag = HashtagSuggest(text: data.currentLocation)
//            self.presenter?.informPlaceBackToView(hashTag, from: from)
//        }
//        
//    }
//    
//    
//    
//}
