//
//  InstaPostsAPISources.swift
//  MacroChallenge
//
//  Created by Fábio França on 16/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation

protocol APISource {
    func getURL() -> Result<URL,Error>
}

/// Enum responsável por providenciar a URL da API do instagram.
enum InstaPostsAPISources {
    case instaPosts(tag: String)
    case instaPostDetail(shortcode: String)
}

extension InstaPostsAPISources: APISource {
    
    /// Método responsável por providenciar a URL.
    /// - Returns: A URL personalizada pelo valor do enum.
    func getURL() -> Result<URL,Error> {
        switch (self) {
        case .instaPosts(let tag):
            let URLString = "https://www.instagram.com/explore/tags/@/?__a=1"
            
            let url: URL? = {
                guard let url = URL(string: URLString.replacingOccurrences(of: "@", with: tag)) else {
                    debugPrint("A url Usando não está válida: \(InstaPostsAPISources.self)")
                    return nil
                }
                return url
            }()
            
            if let url = url {
                return .success(url)
            }else{
                return .failure(ServiceError.emptyData)
            }
            
        case .instaPostDetail(let shortcode):
            let URLString = "https://www.instagram.com/p/@/?__a=1"
            
            let url: URL? = {
                guard let url = URL(string: URLString.replacingOccurrences(of: "@", with: shortcode)) else {
                    debugPrint("A url Usando não está válida: \(InstaPostsAPISources.self)")
                    return nil
                }
                return url
            }()
            
            if let url = url {
                return .success(url)
            }else{
                return .failure(ServiceError.emptyData)
            }
        }
    }
}

