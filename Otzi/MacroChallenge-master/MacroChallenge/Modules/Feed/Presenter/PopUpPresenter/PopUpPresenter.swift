//
//  PopUpPresenter.swift
//  MacroChallenge
//
//  Created by Lelio Jorge Junior on 24/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
/// PopUpPresenter formata dados e devolve para View
class PopUpPresenter:  PopUpPresenterToViewProtocol {
    
    var interactor: PopUpInteractorToPresenterProtocol?
    
    func instagram(owner: String?) {
        
        guard let owner = owner else { return }
        self.interactor?.instagram(user: owner)
        
    }
    
    func bing(url: String) {
        self.interactor?.bing(url: url)
    }
    
    func owner(post: inout Post, _ completion: @escaping (String?, ServiceError?) -> Void) {
        self.interactor?.getOwner(post: &post, { (result, error) in
            if let result = result {
                let owner = result.shortcode.detail.owner.username
                completion(owner,nil)
            } else {
                completion(nil,error)
            }
            
        })
    }
    
    func favoriteAddImage(post: inout Post, owner: String, folderName: String, completion: ((DataControllerError?) -> Void)){
        let image = createImageEntity(post: post, owner: owner)
        let folder = FolderEntity(name: folderName)
        self.interactor?.save(image: image, folder: folder, completion: { error in
            completion(error)
        })
    }
    
    func favoriteFolder(folderName: String, completion: ((DataControllerError) -> Void)?){
        let folder = FolderEntity(name: folderName)
        self.interactor?.save(folder: folder, completion: { error in
            completion?(error)
        })
    }
    
    func getFolders(handler: @escaping ([FolderEntity]) -> Void, completion: ((DataControllerError) -> Void)?){
        self.interactor?.fecthFolder(hadler: { (results) in
            var folders: [FolderEntity] = [FolderEntity]()
            for result in results {
                if let name = result.name {
                    let folder = FolderEntity(name: name)
                    folders.append(folder)
                }
            }
            handler(folders)
        },completion: completion)
    }
    
    func wasFavorited(post: inout Post, owner: String) -> Bool {
        let image = createImageEntity(post: post, owner: owner)
        var wasFavotite: Bool = false
        
        self.interactor?.fetchImages(image: image, handler: { _ in
            wasFavotite = true
        }, completion: nil)
        return wasFavotite
        
    }
    
    
    func hashtags(of post: inout Post) -> [String]? {
        var hashtags = [String]()
        let descriptions = post.node.descriptions.descriptions
        
        for description in descriptions {
            hashtags.append(contentsOf: workInText(text: description.node.descriptionText))
        }
        hashtags.sort { (str1, str2) -> Bool in
            str1.count < str2.count ? true : false
        }
        return hashtags
    }
    
    func setup(description: String) -> String {
        var find = false
        var newString: String = String()
        description.forEach({
            if $0 == "#" {
                find = true
            }
            if find {
                return
            }
            newString.append($0)
        })
        return newString
    }
    
    func deleteImage(post: inout Post, completion: @escaping ((Bool, DataControllerError?) -> Void)) {
        let image = createImageEntity(post: post, owner: nil)
        self.interactor?.delete(image: image, completion: completion)
    }
    
    private func createImageEntity(post: Post, owner: String?) -> ImageEntity {
        return ImageEntity(id: post.node.shortcode, owner: owner ?? " ", description: post.node.descriptions.descriptions[0].node.descriptionText, link: post.node.imageUrl, isPostInstagram: post.isPostInstagram)
    }
    /// Implemnta lógica para encontra e separa de um texto as hashtags.
    /// - Parameter text: String
    /// - Returns: [String]
    private func workInText(text: String) -> [String] {
        
        var newText: String = ""
        var words: [String] = []
        var find = false
        
        for i in text {
            if !find {
                if i == "#" {
                    find = true
                }
            } else {
                if i.isNumber || i.isLetter {
                    newText.append(i)
                } else {
                    appendWord(text: newText, array: &words)
                    newText = ""
                    find = (i == "#" ? true : false)
                }
            }
        }
        
        appendWord(text: newText, array: &words)
        
        return words
    }
    
    /// Implementa uma lógica para saber se o dado  é valido ou não
    /// - Parameters:
    ///   - text: String
    ///   - array: inout [String]
    private func appendWord(text: String, array: inout [String]) {
        if text != " " && text.count >= 1 {
            array.append(text)
        }
    }
    
    
}
