//
//  TabBar.swift
//  MacroChallenge
//
//  Created by Lelio Jorge Junior on 05/11/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

/// Renderiza imagens.
fileprivate class RenderImage {
    
    /// Implementa a criação de imagem.
    /// - Parameter named: String
    /// - Returns: UIImage
    static func createImage(named: String) -> UIImage {
        return UIImage(named: named)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal) ?? UIImage()
    }
}

/// Responsável por criar uma Tab Bar
class TabBarFactory {
    
    
    /// Implementa a criação de Tab Bar.
    /// - Parameters:
    ///   - viewControllers: [UIViewController]
    ///   - animated: Bool
    /// - Returns: UITabBarController
    public static func createTabBar(with viewControllers: [UIViewController], animated: Bool = false) -> UITabBarController {
        let tabBarVC = UITabBarController()
        tabBarVC.setViewControllers(viewControllers, animated: animated)
        setupItensTabBar(with: viewControllers)
        return tabBarVC
    }
    
    /// Configura a Tab Bar.
    /// - Parameter viewControllers: [UIViewController]
    private static func setupItensTabBar(with viewControllers: [UIViewController]) {
        
        for viewController in viewControllers {
            if let title = viewController.title {
                let image = RenderImage.createImage(named: title + "TabBar")
                let selectedImage = RenderImage.createImage(named: title + "TabBarSelected")
                viewController.tabBarItem = createItem(image: image, selectedImage: selectedImage)
            }
        }
    }
    
    /// Cria o item da Tab Bar.
    /// - Parameters:
    ///   - title: String?
    ///   - image: UIImage
    ///   - selectedImage: UIImage
    /// - Returns: UITabBarItem
    private static func createItem(title: String? = " ", image: UIImage, selectedImage: UIImage) -> UITabBarItem {
        let item = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        item.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        return item
    }
}
