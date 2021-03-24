//
//  CoreDataManager.swift
//  MacroChallenge
//
//  Created by Lelio Jorge Junior on 18/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import CoreData

/// Especialista em Core Data, gerencia os modos de insert, fetch, update e delete para todos as entitys
class CoreDataManager {
    
    private lazy var dataController: DataController = {
        DataController()
    }()
}

// MARK: - Insert
extension CoreDataManager {
    
    /// Insere o User no banco.
    /// - Parameters:
    ///   - user: UserEntity
    ///   - completion: (DataControllerError) -> Void)?
    func insert(with user: UserEntity, completion: ((DataControllerError) -> Void)?) {
        let dataController = self.dataController
        
        dataController.insertData(handler: { (context) in
            let newUser = User(context: context)
            newUser.name = user.name
            newUser.email = user.email
            newUser.accountType = user.accountType
            
        }) { error in
            completion?(error)
        }
    }
    
    /// Insere o Tag no banco.
    /// - Parameters:
    ///   - user: TagEntity
    ///   - completion: (DataControllerError) -> Void)?
    func insert(with tag: TagEntity, completion: ((DataControllerError) -> Void)?) {
        let dataController = self.dataController
        
        dataController.insertData(handler: { (context) in
            
            let newTag = Tag(context: context)
            newTag.name = tag.name
            newTag.rating = tag.rating
            newTag.isSeachedTag = tag.isSeachedTag
            newTag.date = tag.date

        }) { error in
            completion?(error)
        }
    }
    
    /// Insere o Folder no banco.
    /// - Parameters:
    ///   - user: FolderEntity
    ///   - completion: (DataControllerError) -> Void)?
    func insert(with folder: FolderEntity, completion: ((DataControllerError) -> Void)?) {
        let dataController = self.dataController
        
        dataController.insertData(handler: { (context) in
            
            let newfolder = Folder(context: context)
            newfolder.name = folder.name
            
        }) { error in
            completion?(error)
        }
    }
    
    /// Adicionar imagem no Folder. Necessario  o Folder.
    /// - Parameters:
    ///   - image: ImageEntity
    ///   - folder: FolderEntity
    ///   - completion: (DataControllerError) -> Void)?
    func add(image: ImageEntity, in folder: FolderEntity, completion: ((DataControllerError?) -> Void)) {
    let dataController = self.dataController
    let predicate = NSPredicate(format: "name = %@", folder.name)
        
        dataController.updateData(predicate: predicate, fetch: Folder.fetch(), handler: { (results,context) in
            
            let results = results as! [Folder]
            let newImage = Image(context: context)
            newImage.id = image.id
            newImage.descriptionPost = image.description
            newImage.link = image.link
            newImage.owner = image.owner
            newImage.isPostInstagram = image.isPostInstagram
            
            results.forEach { folder in
                folder.addToImages(newImage)
                newImage.folder = folder
            }
            
        }) { (error) in
            completion(error)
        }
    }
    
    /// Adiciona um Array de imagens no Folder. Necessario o da Folder.
    /// - Parameters:
    ///   - images: [ImageEntity]
    ///   - folder: FolderEntity
    ///   - completion: (DataControllerError) -> Void)?
    func add(images: [ImageEntity], in folder: FolderEntity, completion: ((DataControllerError?) -> Void)) {
        let dataController = self.dataController
        let predicate = NSPredicate(format: "name = %@", folder.name)
        
        dataController.updateData(predicate: predicate, fetch: Folder.fetch(), handler: { (results,context) in
            
            let results = results as! [Folder]
            images.forEach { image in
                let newImage = Image(context: context)
                newImage.id = image.id
                newImage.descriptionPost = image.description
                newImage.link = image.link
                newImage.owner = image.owner
                newImage.isPostInstagram = image.isPostInstagram

                results.forEach { folder in
                    folder.addToImages(newImage)
                    newImage.folder = folder
                }
            }
            
        }) { (error) in
            completion(error)
        }
    }
    

}

// MARK: - Fetch
extension CoreDataManager {
    
    /// Busca todos os dados de qualquer entidade.
    /// - Parameters:
    ///   - entity: T.Type
    ///   - completion: ([T]?,DataControllerError?) -> Void)?
    func fetch<T: NSManagedObject>(entity: T.Type, completion: (([T]?,DataControllerError?) -> Void)?) {
        let dataController = self.dataController
        
        
        dataController.retrieveData(fetch: entity.fetch(), handler: { results in
            completion?(results as? [T],nil)
        }) { error in
            completion?(nil,error)
        }
    }
    
    /// Busca os dados de qualquer entidade, por um predicate.
    /// - Parameters:
    ///   - entity: T.Type
    ///   - completion: ([T]?,DataControllerError?) -> Void)?
    func fetch<T: NSManagedObject>(entity: T.Type,predicate: NSPredicate, completion: (([T]?,DataControllerError?) -> Void)?) {
        let dataController = self.dataController
        
        dataController.retrieveData(predicate: predicate, fetch: entity.fetch(), handler: { results in
            completion?(results as? [T],nil)
        }) { error in
            completion?(nil,error)
        }
    }
    
}

// MARK: - Update
extension CoreDataManager {
    
    /// Altera dados do User.
    /// - Parameters:
    ///   - user: UserEntity
    ///   - predicate: NSPredicate
    ///   - completion: (DataControllerError) -> Void)?
    func update(user: UserEntity, predicate: NSPredicate, completion: ((DataControllerError?) -> Void)) {
        let dataController = self.dataController
        
        dataController.updateData(predicate: predicate, fetch: User.fetch(), handler: { (results,context) in
            
            let results = results as! [User]
            
            for result in results {
                
                result.name = user.name
                result.email = user.email
                result.accountType = user.accountType
                
            }
            
        }) { (error) in
            completion(error)
        }
    }
    
    /// Altera dados do Tag.
    /// - Parameters:
    ///   - tag: TagEntity
    ///   - predicate: NSPredicate
    ///   - completion: (DataControllerError) -> Void)?
    func update(tag: TagEntity, predicate: NSPredicate, completion: ((DataControllerError?) -> Void)) {
        let dataController = self.dataController
        
        dataController.updateData(predicate: predicate, fetch: Tag.fetch(), handler: { (results,context) in
            
            let results = results as! [Tag]
            
            for result in results {
                
                result.name = tag.name
                result.rating = tag.rating
                result.isSeachedTag = tag.isSeachedTag
                result.date = tag.date
            }
            
        }) { (error) in
            completion(error)
        }
    }
    
    /// Altera dados do Folder.
    /// - Parameters:
    ///   - folder: FolderEntity
    ///   - predicate: NSPredicate
    ///   - completion: (DataControllerError) -> Void)?
    func update(folder: FolderEntity, predicate: NSPredicate, completion: ((DataControllerError?) -> Void)) {
        let dataController = self.dataController
        
        dataController.updateData(predicate: predicate, fetch: Folder.fetch(), handler: { (results,context) in
            
            let results = results as! [Folder]
            
            for result in results {
                result.name = folder.name
            }
            
        }) { (error) in
            completion(error)
        }
    }
    
}

// MARK: - Delete
extension CoreDataManager {
    
    
    /// Deleta dados do banco.
    /// - Parameters:
    ///   - entity: NSManagedObject.Type
    ///   - predicate: NSPredicate
    ///   - completion: (DataControllerError) -> Void)?
    func delete(entity: NSManagedObject.Type, predicate: NSPredicate, completion: ((DataControllerError?) -> Void)) {
        let dataController = self.dataController
        
        dataController.deleteData(predicate: predicate, fetch: entity.fetch(), handler: { (results) -> NSManagedObject in
            
            return results[0]
            
        }) { (error) in
            completion(error)
        }
    }
    
}
