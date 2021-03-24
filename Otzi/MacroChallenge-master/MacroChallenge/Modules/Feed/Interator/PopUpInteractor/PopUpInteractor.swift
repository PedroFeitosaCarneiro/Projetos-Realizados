//
//  PopUpInteractor.swift
//  MacroChallenge
//
//  Created by Lelio Jorge Junior on 24/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation

/// PopUpInteractor faz chamdas internas e externas.
class PopUpInteractor: PopUpInteractorToPresenterProtocol {
    
    lazy var details: InstaPostDetail = {
        
        let details = InstaPostDetail(manager: RequestManagerFactory.alamofire.create())
        return details
    }()
}

extension PopUpInteractor {
    
    var core: CoreDataManager {
        CoreDataManager()
    }
    
    func save(image: ImageEntity, folder: FolderEntity, completion: ((DataControllerError?) -> Void)) {
        self.core.add(image: image, in: folder, completion: completion)
    }
    
    func fecthFolder(hadler: (([Folder]) -> Void)?, completion: ((DataControllerError) -> Void)?) {
        core.fetch(entity: Folder.self) { (result, error) in
            guard let result = result else {
                completion?(DataControllerError.NotFound)
                return
            }
            hadler?(result)
        }
    }
    
    func fetchImages(image: ImageEntity, handler: @escaping ([Image]) -> Void, completion: ((DataControllerError) -> Void)?) {
        let predicate = NSPredicate(format: "id = %@", image.id)
        self.core.fetch(entity: Image.self,predicate: predicate) { (results, error) in
            
            if let images = results {
                handler(images)
            }
            
            if let error = error {
                completion?(error)
            }
        }
    }
    
    func delete(image: ImageEntity, completion: @escaping ((Bool, DataControllerError?) -> Void)) {
        let predicate = NSPredicate(format: "id = %@", image.id)
        var folder: FolderEntity!

        self.core.fetch(entity: Image.self, predicate: predicate) { (results, error) in
            if let results = results {
                if let nameFolder = (results.first)?.folder?.name {
                        folder = FolderEntity(name: nameFolder)
                }
            }
        }
        
        let predicateFolder = NSPredicate(format: "name == %@", folder.name)
        
        self.core.fetch(entity: Folder.self,predicate: predicateFolder) { (results, error) in
            if let results = results {
                if let images = (results.first)?.images {
                    if images.count > 1 {
                        self.core.delete(entity: Image.self, predicate: predicate, completion: { error in
                            completion(true,error)
                        })
                    } else {
                        self.core.delete(entity: Image.self, predicate: predicate, completion: {_ in
                            self.core.delete(entity: Folder.self, predicate: predicateFolder, completion: { error in
                                completion(false,error)
                            })
                        })
                    }
                }
            }
        }
    }
    
    func save(folder: FolderEntity, completion: ((DataControllerError) -> Void)?) {
        self.core.insert(with: folder, completion: completion)
    }
    
    func instagram(user: String) {
        let instagram = InstagramManager(user: user)
        instagram.callInstagramProfileWebSite()
    }
    
    func bing(url: String) {
        let instagram = InstagramManager(user: url)
        instagram.callBingWebSite()
    }
    
    func getOwner(post: inout Post, _ completion: @escaping (GraphqlDetail?,ServiceError?) -> Void) {
        details.getInstaPostDetail(post) { (result) in
            switch result {
                
            case .success(let detail):
                completion(detail,nil)
            case .failure(let error):
                completion(nil,error as? ServiceError)
            }
        }
    }
    
}
