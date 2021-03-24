//import Foundation
//import MapKit
//
//class MapController: NSObject{
//    
//    var mapView : MKMapView
//    var mapPin : MKPointAnnotation
//    
//    weak var uiDelegate : UpdateUIMap?
//    
//    /// Inicialzizador da classe controller do mapa
//    /// - Parameters:
//    ///   - mapReference: Referencia da view do mapa
//    ///   - pin: Pin colocado no mapa
//    init(mapReference: MKMapView, pin: MKPointAnnotation) {
//        mapView = mapReference
//        mapPin = pin
////        self.uiDelegate = delegate as? updateUIMap
//        super.init()
//        setupGestureDelegate()
//    }
//    
//    func setDelegate(delegate: UIViewController){
//        self.uiDelegate = delegate as? UpdateUIMap
//    }
//    
//}
//
//extension MapController: HandleMapSearch, UIGestureRecognizerDelegate {
//
//    
//    func setupGestureDelegate() {
//        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(handleTap))
//        gestureRecognizer.delegate = self
//        mapView.addGestureRecognizer(gestureRecognizer)
//    }
//    
//    @objc func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
//        let location = gestureRecognizer.location(in: mapView)
//        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
//        mapPin.coordinate = coordinate
//        uiDelegate?.updateUI()
//    }
//    
//    func dropPin(placemark: MKPlacemark) {
//        mapPin.coordinate = placemark.coordinate
//        
//        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
//        mapView.setRegion(region, animated: true)
//        
//    }
//    
//    
//}
//
