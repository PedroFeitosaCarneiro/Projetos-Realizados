//import Foundation
//import MapKit
//import UIKit
//
//
//
///// Protocolo responsável para conectar o output do interactor para o presenter
//protocol MapPresenterToInteractor : class{
//    var interactor: MapInteractorToPresenter? {get set}
//    
//    /// Método responsável para enviar o place de volta para a View
//    /// - Parameter place: Nome do local
//    func informPlaceBackToView(_ place: HashtagSuggest, from view: UIViewController)
//}
//
///// Protocolo responsável para conectar o input do presenter para o interator
//protocol MapInteractorToPresenter : class {
//    var presenter: MapPresenterToInteractor? {get set}
//    
//    /// Método responsável para enviar o dado do local marcado para o handler.
//    /// - Parameter place: Placemark do local marcado
//    func informPlaceToHandler(_ place: MKPlacemark, from view: UIViewController)
//}
//
///// Protocolo responsável para conectar o input da View para o presenter
//protocol MapViewToPresenter : class {
//    var presenter: MapPresenterToView? {get set}
//    var sendButton : UIButton? {get set}
//    
//    /// Método responsável por enviar os dados da view para o presenter
//    func sendToPresenter()
//}
//
///// Protocolo responsável para conectar o output do Presenter para a View, e para a conexão com o Router
//protocol MapPresenterToView : class {
//    var view: MapViewToPresenter? {get set}
//    var router: MapRouterToPresenter? {get set}
//    
//    /// Método responsável para informar o place ao interactor
//    /// - Parameter place: Placemark do local marcado
//    func informPlaceToInteractor(_ place: MKPlacemark, from view: UIViewController)
//    
//    
//    /// Método responsável por chamar a View de lógica da pesquisa de mapas
//    /// - Parameters:
//    ///   - view: Referência da ViewController
//    ///   - to: ViewController que será apresentada
//    func callRouterToShowSearch(from view: UIViewController, to: SearchViewController)
//    
//    
//}
//
///// Protocolo responsável para a criação do router
//protocol MapRouterToPresenter : class {
//    
//    /// Método responsável por criar o módulo do mapa
//    func createMapModule() -> UIViewController
//    
//    
//    /// Método responsável por enviar os dados para o Feed
//    /// - Parameters:
//    ///   - hashtag: Hashtag a ser pesquisada
//    ///   - view: Referência da ViewController
//    func sendDataToNextView(hashtag: HashtagSuggest, from view: UIViewController)
//    
//    
//    /// Método responsável por chamar a View de busca por escrita do mapa
//    /// - Parameters:
//    ///   - view: Referência da ViewController
//    ///   - to: View a ser apresentada
//    func callSearchView(from view: UIViewController, to: SearchViewController)
//    
//    
//}
//
///// Protocolo responsável para lidar com os eventos referentes ao mapa
//protocol HandleMapSearch: class {
//    
//    /// Método responsável por colocar o pin no mapa
//    /// - Parameter placemark: Local, coordenada geográfica e suas características.
//    func dropPin(placemark: MKPlacemark)
//        /// Método responsável por lidar com os eventos de toque no mapa.
//    /// - Parameter gestureRecognizer: Reconhecimento de toque na tela.
//    func setupGestureDelegate()
//    
//    /// Método responsável por lidar com o toque do usuário no mapa
//    /// - Parameter gestureRecognizer: Toque do usuário
//    func handleTap(gestureRecognizer: UILongPressGestureRecognizer)
//    
//}
//
//
//
//protocol UpdateUIMap : class {
//    func updateUI()
//    func hideUI()
//}
//
