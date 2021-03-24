//
//  FeedRouter.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 08/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit

class FeedRouter: FeedRouterToPresenter{
    
    
    
    private let instaAPI:InstaPostsAPI
    private let imageAPI: ImageAPI
    
    
    init(serviceAPI: InstaPostsAPI, imageAPI: ImageAPI) {
        
        self.instaAPI = serviceAPI
        self.imageAPI = imageAPI
    }
    
    
    
    /// Método que inicializa o módulo do Feed
    /// - Parameter hashtags: As hashtags para ser buscadas
    /// - Returns: View Controller do feed
    func startViewController(with hashtags: [HashtagSuggest], on section: PreFeedSection?)-> UIViewController{
        let vc = FeedViewController()
        let interator = FeedInterator(serviceAPI: instaAPI, imageAPI: imageAPI, hashtagsSearched: hashtags)
        
        let presenter = FeedPresenter()
        interator.presenter = presenter
//        if let itens = section?.items, let endcursor = section?.endCursor{
//            for item in itens{
//                interator.cache.append(item.post)
//            }
//            interator.offsetBing = Int(endcursor) ?? 0
//            
//        }
//        
        
        presenter.interator = interator
        vc.presenter = presenter
        presenter.view = vc
        presenter.router = self
        vc.currentHashtag = hashtags.first?.text
        return vc
    }
    
    
    /// Função que vai para o explorer módule
    /// - Parameter view: de onde está vindo
    func goToExploreView(from view: UIViewController) {
        view.navigationController?.popToRootViewController(animated: true)
    }
    
}
