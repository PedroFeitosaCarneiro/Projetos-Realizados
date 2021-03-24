//
//
//import Foundation
//import MapKit
//
//class LocationParser {
//
//    /// Localização marcada no mapa com um pin
//    private var location: CLLocation?
//
//    /// Localização em forma de string da atual posição do pin
//    private (set) var currentLocation : String = "nil"
//
//
//    /// Inicializador da classe Parser
//    /// - Parameter location: Coordenadas do ponto a ser procurado
//    init(with location: CLLocationCoordinate2D) {
//        self.location = CLLocation(latitude: location.latitude, longitude: location.longitude)
//    }
//
//
//    /// Método responsável por lidar com a lógica de transformar uma localização geográfica em sua cidade, estado e País.
//    /// - Parameter then: Closure que retorna a localização formatada.
//    public func handleLocation(then: @escaping (_ data: String) -> Void){
//        CLGeocoder().reverseGeocodeLocation(location!) { placemarks, error in
//            guard let placemark = placemarks?.first else {
//                print(error?.localizedDescription ?? "error")
//                return
//            }
//            let parsedLocation = Location(with: placemark)
//            self.currentLocation = parsedLocation.formatedLocation
//
//            if self.currentLocation == "nil"{
//                return
//            } else {
//                then(self.currentLocation)
//            }
//        }
//    }
//
//}
//
//extension LocationParser {
//
//
//    /// Nested struct Location utilizada para separar a cidade estado e País de uma localização.
//    private struct Location{
//        let city: String
//        let state: String
//        let country: String
//
//
//        /// Inicializador da struct Location
//        /// - Parameter placemark: Uma placemark de um local marcado no mapa.
//        init(with placemark: CLPlacemark) {
//            self.city = placemark.locality ?? "nil"
//            self.state = placemark.administrativeArea ?? "nil"
//            self.country = placemark.country ?? "nil"
//        }
//
//        var formatedLocation: String {
//            let text = "\(self.country.forSorting)tattoo"
//            return text.removeSpecialCharacters
//        }
//
//    }
//}
//
