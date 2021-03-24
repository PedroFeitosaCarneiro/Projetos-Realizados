//
//  ExplorePresenter.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 24/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit



class ExplorePresenter: ExplorePresenterToView{
   
    
    
    
    
    
    var view: ExploreViewToPresenter?
    var router: ExploreRouterToPresenter?
    var interator: ExploreInteratorToPresenter?



    func goToFeed(hashtags: [HashtagSuggest], from controller: UIViewController){
        router?.goToFeed(hashtags: hashtags, from: controller)
    }
    
    func goToMapView(from controller: UIViewController) {
        router?.goToMapView(from: controller)
    }
    
    func goToSearchView(from controller: UIViewController) {
        router?.goToSearchView(from: controller)
    }
    
    func goToPreFeed(hashtags: [HashtagSuggest], from controller: UIViewController) {
        router?.goToPreFeed(hashtags: hashtags, from: controller)
    }
    
    func fetchHashtags(_ type: HashtagsType, reloadContent: Bool) {
        interator?.fetchHashtags(type, reloadContent: reloadContent)
    }
    
    func fetchImage(from hashtag: HashtagSuggest, completion: @escaping (UIImage) -> Void) -> UUID? {
        return nil
       
    }
    
    
    func fetchImage(from hashtag: HashtagSuggest, index: IndexPath) {
        
        let _ = interator?.fetchHashtagImage(from: hashtag, completion: { [weak self] (image, url)  in
                self?.view?.updateCell(from: index, url: url, image: image)
        })
    }
    
    
    func cancelFetchImage(by uuid: UUID?) {
        interator?.cancelFetchImage(by: uuid)
    }
    
    func getImageOnCache(by url: String?) -> UIImage? {
        return interator?.getImageOnCache(by: url)
    }
    
    
}

//MARK: -> Presenter to interator
extension ExplorePresenter: ExplorePresenterToInterator{
   
 
    
    func fetchedHashTagsSucessefully(hashtags: [HashtagSuggest]) {
        view?.showHashtags(hashtags: hashtags)
    }
    
    func fetchHashtagFailed(error: ExploreError) {
        
        view?.showErrorMsg(error.localizedDescription)
    }
    
    
}
