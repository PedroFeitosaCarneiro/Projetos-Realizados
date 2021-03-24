//
//  UserFavoritesProtocols.swift
//  MacroChallenge
//
//  Created by Fábio França on 14/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

protocol UserFavoritesViewToPresenter {
    func updateFolders(folders: [Folder])
    func imageWasFetched(image: UIImage, indexPath: IndexPath, folder: Folder)
    func folderWasDeletes(folder: Folder)
    func postWasDeletes(post: Image)
}

protocol UserFavoritesPresenterToView {
    func viewDidLoad()
    func requestDowloadImage(with path: String, at indexPath: IndexPath, folder: Folder)
    func goToFavoritesFoldersPosts(with folder: Folder)
    func logout()
    func deleteUserFolder(folder: Folder)
    func deleteImage(image: Image)
}

protocol UserFavoritesInteractorToPresenter {
    func updateFolder(folder: Folder,completion: @escaping FoldersCompletion)
    func fetchUserFolders(completion: @escaping FoldersCompletion)
    func fetchFavoritesPosts(completion: @escaping PostsCompletion)
    func dowloadImage(with url: String,completion: @escaping ImageDowloadCompletion)-> UUID?
    func cancelFetchImage(by uuid: UUID?)
    func deleteUserFolder(folder: Folder, completion: @escaping deleteCompletion)
    func deleteUserImage(image: Image, completion: @escaping deleteCompletion)
}

protocol UserFavoritesRouterToPresenter {
    func goToFavoritesFolderPosts(with folder: Folder)
    func logout()
}

protocol FavoritesFolderPostsViewToPresenter {
    func updateFolder(folder: Folder)
    func imageWasFetched(image: UIImage, indexPath: IndexPath)
    func postWasDeletes(post: Image)
    func folderWasDeletes()
}

protocol FavoritesFolderPostsPresenterToView {
    func updateFolder(folder: Folder)
    func requestDowloadImage(with url: String, at indexPath: IndexPath)
    func createPost(image: Image) -> Post
    func deleteImage(image: Image)
    func deleteUserFolder(folder: Folder)
}




