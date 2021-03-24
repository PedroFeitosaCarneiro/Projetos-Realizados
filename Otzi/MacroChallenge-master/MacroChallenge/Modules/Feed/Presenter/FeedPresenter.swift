//
//  FeedPresenter.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 08/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit
class FeedPresenter: FeedPresenterToView{

    
    
  
    
   
   
  
    
    //MARK: -> Properties
    var interator: FeedInteratorToPresenter?
    
    var view: FeedViewToPresenter?
    
    var router: FeedRouterToPresenter?
    
    

    
   
    func fetchData() {
        interator?.fetchData()
    }

   
    
    func fetchImage(with post: Post?, from index: IndexPath) {
        guard let post = post else {return}
        interator?.fetchImage(with: post, from: index)
    }
    
    
    func viewWillDismiss(from view: UIViewController) {
        interator?.viewWillDismiss()
        router?.goToExploreView(from: view)
    }
    
    func saveHashtag() {
        interator?.saveHashtag()
    }
    
    func getImageOnCache(by url: String?) -> UIImage? {
        guard let url = url else {return nil}
        return interator?.getImageOnCache(by: url)
    }
    
    func cancelLoadRequest(url: String){
        interator?.cancelLoadRequest(url: url)
    }
    
    func pauseImageRequest(at index: IndexPath) {
        interator?.pauseImageRequest(at: index)
    }
    
    func suspendAllOperations() {
        interator?.suspendAllOperations()
    }
    
    func resumeAllOperations() {
        interator?.resumeAllOperations()
    }
    
    func loadImagesForOnscreenCells(indexPathsForVisibleRows: [IndexPath]?) {
        interator?.loadImagesForOnscreenCells(indexPathsForVisibleRows: indexPathsForVisibleRows)
    }
    
   
    
    
}



//MARK: -> Presenter para o interator
extension FeedPresenter: FeedPresenterToInterator{
    
    
    func didFinishDownload(img: UIImage, post: Post, index: IndexPath) {
        view?.updatePost(from: index, post: post, image: img)
    }
    
   
    
    func fetchedDataSucessefully(data: [Post]) {
        
        
        if data.isEmpty{
            view?.showErrorMsg(.emptyData)
        }else{
            view?.showData(posts: data)
        }
    }

    func fetchDataFailed(error: ServiceError) {
        
        view?.showErrorMsg(error)
    }
    
    func updateFavoriteButton(status: FaviteButtonStatus) {
        view?.updateFavoriteButton(status: status)
    }
    
    
}
