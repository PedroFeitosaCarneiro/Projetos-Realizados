//
//  ExploreProtocols.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 24/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit

//Primeiro é quem implementa e o segundo é onde terar uma referência.
protocol ExplorePresenterToInterator: class {
    
//    var interator: ExploreInteratorToPresenter? {get set}
    
    /// Método quando a requisição é completada com sucessoo
    /// - Parameter data: [HashtagSuggest] - uma coleção de hashtagSuggest
    func fetchedHashTagsSucessefully(hashtags: [HashtagSuggest])
    
    /// Método para quando ocorre um erro no fetch de hashtgas
    /// - Parameter error: Error
    func fetchHashtagFailed(error: ExploreError)

}

protocol ExploreInteratorToPresenter: class {
    
    var presenter: ExplorePresenterToInterator? {get set}
    
    
   
    ///Método quando o presenter da fetch nas hashtags
    func fetchHashtags(_ type: HashtagsType, reloadContent: Bool)-> Void
    
    /// Método para fazer o fetch de uma imagem
    /// - Parameters:
    ///   - url: URL - url da image
    ///   - completion: callback assychronous com a image
    /// - Returns: UUID - indentificador da request
    func fetchImage(with url: String, completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID?
    
    func fetchHashtagImage(from hashtag: HashtagSuggest, completion: @escaping (UIImage, String) -> Void) -> UUID?
    
    /// Método para cancelar a requisição de uma imagem
    /// - Parameter uuid: UUID - identificador da request
    func cancelFetchImage(by uuid: UUID?) -> Void
    
    
    func getImageOnCache(by url: String?) -> UIImage?
}

protocol ExploreViewToPresenter: class{
    
    
    /// Esse método é chamado a requisição é finalizada
    /// - Parameter posts: uma coleção de hashtags
    /// - Returns: Void
    func showHashtags(hashtags: [HashtagSuggest])->Void
    
    /// Esse método é chamado quando ocorre um alguem erro na requisição
    /// - Parameter error: ServiceError
    /// - Returns: Void
    func showErrorMsg(_ error: String)->Void
    
    
    /// Método para atualizaar a view quando termina de baixar a image
    /// - Parameters:
    ///   - index: indexpath da célula  a ser adicionada
    ///   - url: url da iamge
    ///   - image: a imagem baixada
    func updateCell(from index: IndexPath, url: String, image: UIImage?)
}

protocol ExplorePresenterToView: class{
    
    /// Método que chama o interator para fazer a requisição da hashtags
    func fetchHashtags(_ type: HashtagsType, reloadContent: Bool) -> Void
    
    
    /// Método para fazer o fetch de uma imagem
    /// - Parameters:
    ///   - url: url da imagem a ser baixada
    ///   - index: indexpath da celula
    func fetchImage(from hashtag: HashtagSuggest,index: IndexPath)
    
    
    /// Método que retorna uma imagem do cache se tiver
    /// - Parameter url: url da imagem
    func getImageOnCache(by url: String?) -> UIImage?
    
    
    /// Método para cancelar a requisição de uma imagem
    /// - Parameter uuid: UUID - identificador da request
    func cancelFetchImage(by uuid: UUID?) -> Void
    
    
    /// Método para ir para a tela de feed
    /// - Parameters:
    ///   - hashtag: HashtagSuggest -  a hashtag buscada no feed
    ///   - controller: da qual controller está vindo
    func goToFeed(hashtags: [HashtagSuggest], from controller: UIViewController) -> Void
    
    // Método para ir para a tela do map
    /// - Parameters:
    ///   - controller: da qual controller está vindo
    func goToMapView(from controller: UIViewController) -> Void
    
    /// Método para ir para a tela de search hashtag
    /// - Parameters:
    ///   - controller: da qual controller está vindo
    func goToSearchView(from controller: UIViewController) -> Void
    
    /// Método para ir para a tela de pre feed
    /// - Parameters:
    ///   - hashtag: HashtagSuggest -  a hashtag buscada no feed
    ///   - controller: da qual controller está vindo
    func goToPreFeed(hashtags: [HashtagSuggest], from controller: UIViewController)
    
    
}

protocol ExploreRouterToPresenter{
    
    /// Método para ir para a tela de feed
    /// - Parameters:
    ///   - hashtag: HashtagSuggest -  a hashtag buscada no feed
    ///   - controller: da qual controller está vindo
    func goToFeed(hashtags: [HashtagSuggest], from controller: UIViewController) -> Void
    
    
    /// Método para ir para a tela do map
    /// - Parameters:
    ///   - controller: da qual controller está vindo
    func goToMapView(from controller: UIViewController) -> Void
    
    /// Método para ir para a tela de search hashtag
    /// - Parameters:
    ///   - controller: da qual controller está vindo
    func goToSearchView(from controller: UIViewController) -> Void
    
    
    /// Método para ir para a tela de pre feed
    /// - Parameters:
    ///   - hashtag: HashtagSuggest -  a hashtag buscada no feed
    ///   - controller: da qual controller está vindo
    func goToPreFeed(hashtags: [HashtagSuggest], from controller: UIViewController)
}
