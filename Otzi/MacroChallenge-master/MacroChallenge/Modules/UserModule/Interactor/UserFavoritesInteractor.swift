//
//  UserFavoritesInteractor.swift
//  MacroChallenge
//
//  Created by Fábio França on 14/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

class UserFavoritesInteractor {
    let imageAPI: ImageAPI
    let dataManager: CoreDataManager
    
    init(imageAPI: ImageAPI,dataManager: CoreDataManager) {
        self.imageAPI = imageAPI
        self.dataManager = dataManager
    }
}

extension UserFavoritesInteractor : UserFavoritesInteractorToPresenter {
    func updateFolder(folder: Folder,completion: @escaping FoldersCompletion) {
        dataManager.fetch(entity: Folder.self, predicate: NSPredicate(format: "name == %@", folder.name!)) { (folders, error) in
            guard let folders = folders else {
                completion([])
                return
            }
            completion(folders)
        }
    }
    
    func fetchUserFolders(completion: @escaping FoldersCompletion) {
        dataManager.fetch(entity: Folder.self) { (folders, error) in
            guard let folders = folders else {
                completion([])
                return
            }
            completion(folders)
        }
    }
    
    func deleteUserFolder(folder: Folder, completion: @escaping deleteCompletion) {
        dataManager.delete(entity: Folder.self, predicate: NSPredicate(format: "name == %@", folder.name ?? "")) { (error) in
            guard error != nil else {
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
    
    func deleteUserImage(image: Image, completion: @escaping deleteCompletion) {
        dataManager.delete(entity: Image.self, predicate: NSPredicate(format: "id == %@", image.id!)) { (error) in
            guard error != nil else {
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
//    func fetchFavoritesHashtags(completion: @escaping TagsCompletion){
//        dataManager.fetch(entity: Tag.self) { (tags, error) in
//            guard let tags = tags else {
//                completion([])
//                return
//            }
//            completion(tags)
//        }
//    }
    
    func fetchFavoritesPosts(completion: @escaping PostsCompletion){
        dataManager.fetch(entity: Image.self) { (posts, error) in
            guard let posts = posts else {
                completion([])
                return
            }
            completion(posts)
        }
    }
    
    func dowloadImage(with url: String,completion: @escaping ImageDowloadCompletion)-> UUID? {
        return imageAPI.getImageWith(url: url, completion: completion)
    }
        
    func cancelFetchImage(by uuid: UUID?) {
        guard let id = uuid else {
            return
        }
        imageAPI.cancelLoadRequest(uuid: id)
    }
}

