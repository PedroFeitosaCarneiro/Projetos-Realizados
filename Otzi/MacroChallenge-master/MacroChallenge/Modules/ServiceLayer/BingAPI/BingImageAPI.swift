//
//  BingImageAPI.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 19/11/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation

final class BingImageAPI:NSObject{
    
    
    private let manager: RequestManager
    
    init(manager: RequestManager) {
        self.manager = manager
    }
    
    /// Método especialista responsável pelo fetch dos posts do instagram.
    /// - Parameters:
    ///   - tag: Hashtag que deseja fazer o fetch dos posts do instagram.
    ///   - endCursor: Responsável pela paginação. Na primeira chamada deve-se passar String vazia. A partir da segunda chamada, coloque o endCursor recuperado pela completion na chamada anterior.
    ///   - completion: Ao termino da requisição, o completion retornara o objeto Graphql em caso de sucesso ou ServiceError em caso de erro.
    func getBingResultWith(hashtag tag: String,offset: Int,quantity: Int, completion: @escaping (Result<BingWrapper,Error>)-> Void) {

//
//        let params: [String: AnyObject] = [ BingKEYS.search_term_key: tag as AnyObject,BingKEYS.license_key: "" as AnyObject,  BingKEYS.contentType: "photo" as AnyObject,BingKEYS.offset_key: offset as AnyObject,"count": quantity as AnyObject,"mkt": "en-us" as AnyObject]
        let params: [String: AnyObject] = [ "q": tag as AnyObject,"license": "all" as AnyObject, "imageType": "photo" as AnyObject,"offset": "\(offset)" as AnyObject,"count": "\(quantity)" as AnyObject,]//pt-BR mkt": "en-us 
        
        
        let headers = [
            BingKEYS.subscription_key : BingKEYS.api_key
        ]
        
        
        if let urlBing = URL(string: getFullPath(params: params)){
            _ = manager.request(url: urlBing, method: .get, parameters: [:], headers: headers, completion: completion)
        }else{
            completion(.failure(ServiceError.apiError))
        }
        
    }
    
    
    
    
    
    
    private func convertParameters(params : Dictionary<String, AnyObject>) -> String
    {
        var parts = Array<String>()
        for (key, val): (String, AnyObject) in params
        {
            if let jsonKey = key.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics),
                let jsonVal = "\(val)".addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)
            { parts.append("\(jsonKey)=\(jsonVal)") }
        }
        let paramString = parts.joined(separator: "&")
        
        return paramString
    }

    private func getFullPath(params : Dictionary<String, AnyObject>) -> String
    {
        let paramString = convertParameters(params : params)
        var fullPath = "https://api.bing.microsoft.com/v7.0/images/search"
        
        if paramString.count > 0
        { fullPath += "/?\(paramString)" }
        
        return fullPath
    }

}
