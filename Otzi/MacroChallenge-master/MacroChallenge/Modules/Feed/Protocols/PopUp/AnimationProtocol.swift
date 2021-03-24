//
//  AnimationProtocol.swift
//  MacroChallenge
//
//  Created by Fábio França on 27/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

protocol AnimationProtocol {
    
    var animation: FeedAnimation { get set }
    
    /// Cria a animação
    /// - Returns: FeedAnimation
    func createAnimation() -> FeedAnimation
    
    /// Adicionar a animação na view
    /// - Parameter animation: FeedAnimation
    func buildHierarchy(of animation: FeedAnimation) -> Void
    
    /// Configurar a constraint da animação
    /// - Parameter animation: FeedAnimation
    func setupConstraints(of animation: FeedAnimation) -> Void
    
    /// Popula a animação com post e images
    /// - Parameters:
    ///   - post: Post
    ///   - image: UIImage
    ///   - outherImages: [UIImage]
    mutating func populateAnimationView(post: Post, main image: UIImage, outherImages: [UIImage], owner: String?) -> Void
    
    /// Colocar a animação para acontecer.
    func run() -> Void
    
    /// Chamar essa função quando se quer fazer alguma ação depois que o post for removido do banco.
    func didRemoveOnlyPost() -> Void
    
    /// Chamar essa função quando se quer fazer alguma ação depois que o folder do post for removido do banco.
    func didRemoveFolder() -> Void
    
}

extension AnimationProtocol {
    
    func run() {
        buildHierarchy(of: animation)
        setupConstraints(of: animation)
    }
    
    mutating func populateAnimationView(post: Post, main image: UIImage, outherImages: [UIImage], owner: String? = nil) -> Void {
        animation = createAnimation()
        
        animation.post = post
        animation.popUpViewController?.image = image
        animation.popUpViewController?.owner = owner
        animation.images = outherImages
    }
    
    func didRemoveOnlyPost() {
        
    }
    
    func didRemoveFolder() {
        
    }
    
}
