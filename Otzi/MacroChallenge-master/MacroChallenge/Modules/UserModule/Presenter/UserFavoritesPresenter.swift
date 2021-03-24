//
//  UserFavoritesPresenter.swift
//  MacroChallenge
//
//  Created by Fábio França on 14/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation

class UserFavoritesPostsPresenter {
    var view: UserFavoritesViewToPresenter?
    var router: UserFavoritesRouterToPresenter?
    var interactor: UserFavoritesInteractorToPresenter?
    
    private func getFavoritesFolders() {
        interactor?.fetchUserFolders(completion: { (folders) in
            self.view?.updateFolders(folders: folders)
        })
    }
}

extension UserFavoritesPostsPresenter: UserFavoritesPresenterToView {
    func goToFavoritesFoldersPosts(with folder: Folder) {
        router?.goToFavoritesFolderPosts(with: folder)
    }
    
    func viewDidLoad() {
        getFavoritesFolders()
    }
    
    func deleteFolder(folder: Folder) {
        interactor?.deleteUserFolder(folder: folder, completion: { (error) in
            self.view?.folderWasDeletes(folder: folder)
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
}


