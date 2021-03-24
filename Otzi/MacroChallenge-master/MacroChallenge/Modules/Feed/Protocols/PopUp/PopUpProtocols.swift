//
//  PopUpProtocols.swift
//  MacroChallenge
//
//  Created by Lelio Jorge Junior on 23/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

// MARK: - View

/// Delega a view funções de toque e formatação de dados.
protocol PopUpViewControllerDelegate: class {
    
    /// Implementa a função de toque nas Views.
    /// - Parameter status: TouchStatus
    func touch(status: TouchStatus) -> Void
    
    /// Implementa o pedido de hashtags para as Views
    func hashtags() -> [String]?
    
    /// Implementa verificação se o post já foi salvo.
    func checkWasFavorite() -> Bool
}

// MARK: - Presenter

/// Delega a implementação de funçõe responsaveis por formatar e chamar o intereitor para alguma chamada externa ou interna.
protocol PopUpPresenterToViewProtocol: class {
    
    /// Implementa a chamada do interaitor na intenção de fazer uma chamada externa. Chamar o instagram apartir do autor(Owner).
    /// - Parameter owner: String
    func instagram(owner: String?) -> Void
    func bing(url: String) -> Void
    
    /// Implementa a chamada do interaitor na intenção de fazer uma chamada interna e formata o dado. Prepara o dado para ser salvo na DB.
    /// - Parameters:
    ///   - post: inout Post
    ///   - owner: String
    ///   - folderName: String
    func favoriteAddImage(post: inout Post, owner: String, folderName: String, completion: @escaping ((DataControllerError?) -> Void)) -> Void
    
    /// Implementa a chamada da intereitor para salvar um folder.
    /// - Parameters:
    ///   - folderName: String
    ///   - completion: ((DataControllerError) -> Void)?
    func favoriteFolder(folderName: String, completion: ((DataControllerError) -> Void)?) -> Void
    
    /// Implementa a cahamda do intereitor para trazer todos as imagens e saber se o aquele post ja foi salvo.
    /// - Parameters:
    ///   - post: inout Post
    ///   - owner: String
    func wasFavorited(post: inout Post, owner: String) -> Bool
    
    /// Implementa as chamda para intereitor, que deleta o post passado.
    /// - Parameter post: inout Post
    /// - Parameter completion: ((Bool, DataControllerError?) -> Void)
    func deleteImage(post: inout Post, completion: @escaping ((Bool, DataControllerError?) -> Void))
    
    /// Imaplementa a lógica de buscar os folders
    /// - Parameters:
    ///   - handler: ([FolderEntity]) -> Void
    ///   - completion: ((DataControllerError) -> Void)?
    func getFolders(handler: @escaping  ([FolderEntity]) -> Void, completion: ((DataControllerError) -> Void)?) -> Void
   
    /// Implementa a formatação do da hashtag e retorna a String formatada.
    /// - Parameter post: inout Post
    func hashtags(of post: inout Post) -> [String]?

    /// Implementa a chamada do interaitor para descobrir quem é o owner.
    /// - Parameters:
    ///   - post: inout Post
    ///   - completion: @escaping (String?, ServiceError?) -> Void
    func owner(post: inout Post, _ completion: @escaping (String?, ServiceError?) -> Void) -> Void
    
    /// Formata a descrição do post.
    /// - Parameter description: String
    func setup(description: String) -> String
}

// MARK: - Interactor

/// Delega a implementação de funçõe responsaveis por  fazer chamadas internas e externas como: Banco de Dados, NetWork e aplicativos externos.
protocol PopUpInteractorToPresenterProtocol: class {
    
    /// Implementa a lógica de salvar a imagem no banco de dados.
    /// - Parameters:
    ///   - image: ImageEntity
    ///   - folder: FolderEntity
    ///   - complition: ((DataControllerError) -> Void)?
    func save(image: ImageEntity, folder: FolderEntity, completion: ((DataControllerError?) -> Void)) -> Void

    /// Implementa a lógica de salvar a folder no banco de dados.
    /// - Parameters:
    ///   - folder: FolderEntity
    ///   - complition: ((DataControllerError) -> Void)?
    func save(folder: FolderEntity, completion: ((DataControllerError) -> Void)?) -> Void
    
    /// Implementa de buscar no banco de dados.
    /// - Parameters:
    ///   - hadler: (([Folder]) -> Void)?
    ///   - complition: ((DataControllerError) -> Void)?
    func fecthFolder(hadler: (([Folder]) -> Void)?, completion: ((DataControllerError) -> Void)?) -> Void
    
    /// Implementa a busca das imagen no banco de dados.
    /// - Parameters:
    ///   - image: ImageEntity
    ///   - handler: @escaping ([Image]) -> Void
    ///   - completion: ((DataControllerError) -> Void)?
    func fetchImages(image: ImageEntity, handler: @escaping ([Image]) -> Void, completion: ((DataControllerError) -> Void)?) -> Void
    
    /// Implementa  o delete da imagem.
    /// - Parameters:
    /// - image: ImageEntity
    /// - completion: ((Bool, DataControllerError) -> Void)?
    func delete(image: ImageEntity, completion: @escaping ((Bool, DataControllerError?) -> Void)) -> Void

    /// Faz uma chamada externa para o profile do usário.
    /// - Parameter user: String
    func instagram(user: String) -> Void
    func bing(url: String) -> Void

    /// Implementa a chamada da NEtWork para consegui o Owner.
    /// - Parameters:
    ///   - post: inout Post
    ///   - completion: @escaping (GraphqlDetail?,ServiceError?) -> Void
    func getOwner(post: inout Post, _ completion: @escaping (GraphqlDetail?,ServiceError?) -> Void) -> Void
}
