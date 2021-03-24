//
//  FavoritesFolderPostsPresenter.swift
//  MacroChallenge
//
//  Created by Fábio França on 26/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation

class FavoritesFolderPostsPresenter {
    var view: FavoritesFolderPostsViewToPresenter?
    var interactor: UserFavoritesInteractorToPresenter?

}

extension FavoritesFolderPostsPresenter: FavoritesFolderPostsPresenterToView {
    func updateFolder(folder: Folder) {
        interactor?.updateFolder(folder: folder, completion: { (folder) in
            self.view?.updateFolder(folder: folder[0])
        })
    }
    
    func deleteUserFolder(folder: Folder) {
        interactor?.deleteUserFolder(folder: folder, completion: { (error) in
            self.view?.folderWasDeletes()
        })
    }
    
    func requestDowloadImage(with url: String, at indexPath: IndexPath) {
        let _ = interactor?.dowloadImage(with: url, completion: { (response) in
            switch response {
            case .success(let image):
                self.view?.imageWasFetched(image: image, indexPath: indexPath)
            case .failure(let error):
                debugPrint(error)
                return
            }
        })
    }
    
    
    func createPost(image: Image) -> Post {
        let description = Description(node: DescriptionPost(descriptionText: image.descriptionPost!))
        let descriptions = Descriptions(descriptions: [description])
        let node = NodePost(imageUrl: image.link!, isVideo: false, descriptions: descriptions, shortcode: image.id!)
        return Post(node: node)
    }
    
    func deleteImage(image: Image) {
        interactor?.deleteUserImage(image: image, completion: { (error) in
            self.view?.postWasDeletes(post: image)
        })
    }
}
