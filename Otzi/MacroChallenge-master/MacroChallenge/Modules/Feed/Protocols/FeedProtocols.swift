//
//  FeedProtocols.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 08/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit
//Primeiro é quem implementa e o segundo é onde terar uma referência.
protocol FeedPresenterToInterator: class {
    
    var interator: FeedInteratorToPresenter? {get set}
    
    /// Método quando a requisição é completada com suceddo
    /// - Parameter data: [Post] - uma coleção de posts
    func fetchedDataSucessefully(data: [Post])
    
    /// Método para quando ocorre um erro na requisição
    /// - Parameter error: ServiceError
    func fetchDataFailed(error: ServiceError)
    
    func updateFavoriteButton(status: FaviteButtonStatus)

    func cancelLoadRequest(url: String)
    
    
    func didFinishDownload(img: UIImage, post: Post, index: IndexPath)
    
}

protocol FeedInteratorToPresenter: class {
    
    var presenter: FeedPresenterToInterator? {get set}
   
    
    func isTattoo(image: UIImage)->Bool
    
    func nextPost(completion:@escaping (Post?)->())->Void
    
    ///Método quando o presenter precisa de mais data
    func fetchData() -> Void
    
    /// Método para fazer o fetch de uma imagem
    func fetchImage(with post: Post,from index: IndexPath)
    
    func getImageOnCache(by url: String) -> UIImage?
    
    func viewWillDismiss()
    
    /// Método para salver uma hashtag
    func saveHashtag()
    
    func cancelLoadRequest(url: String)
    
    func pauseImageRequest(at index: IndexPath)
    
    func suspendAllOperations()
    func resumeAllOperations()
    func loadImagesForOnscreenCells(indexPathsForVisibleRows: [IndexPath]?)
}

protocol FeedViewToPresenter: class{
    
    var presenter: FeedPresenterToView? {get set}
    
    /// Esse método é chamado a requisição é finalizada
    /// - Parameter posts: uma coleção de posts
    /// - Returns: Void
    func showData(posts: [Post])->Void
    
    /// Esse método é chamado quando ocorre um alguem erro na requisição
    /// - Parameter error: ServiceError
    /// - Returns: Void
    func showErrorMsg(_ error: ServiceError)->Void
    func updatePost(from index: IndexPath, post: Post, image: UIImage?)
    
    func updateFavoriteButton(status: FaviteButtonStatus)
    
}

protocol FeedPresenterToView: class{
    
    var view: FeedViewToPresenter? {get set}
    var router: FeedRouterToPresenter?{get set}
    var interator: FeedInteratorToPresenter?{get set}
    
    /// Método que chama o interator para fazer a requisição da data
    func fetchData() -> Void
    
    
    /// Método para fazer o fetch de uma imagem
    func fetchImage(with post: Post?,from index: IndexPath)
    
    func getImageOnCache(by url: String?) -> UIImage?
    
    func viewWillDismiss(from view: UIViewController)
    
    /// Método para salver uma hashtag
    func saveHashtag()
        
    func pauseImageRequest(at index: IndexPath)
    func suspendAllOperations()
    func resumeAllOperations()
    func loadImagesForOnscreenCells(indexPathsForVisibleRows: [IndexPath]?)
}

protocol FeedRouterToPresenter{
    
    func goToExploreView(from view: UIViewController)
}
