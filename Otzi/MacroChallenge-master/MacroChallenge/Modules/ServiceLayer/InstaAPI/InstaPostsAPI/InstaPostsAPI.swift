//
//  InstaPostsAPI.swift
//  MacroChallenge
//
//  Created by Fábio França on 14/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import Alamofire

/// Classe especialista pela implementação dos métodos referente as requisições da API do Instagram.
class InstaPostsAPI {
    
    private let manager: RequestManager
    
    init(manager: RequestManager) {
        self.manager = manager
    }
    
    /// Método especialista responsável pelo fetch dos posts do instagram.
    /// - Parameters:
    ///   - tag: Hashtag que deseja fazer o fetch dos posts do instagram.
    ///   - endCursor: Responsável pela paginação. Na primeira chamada deve-se passar String vazia. A partir da segunda chamada, coloque o endCursor recuperado pela completion na chamada anterior.
    ///   - completion: Ao termino da requisição, o completion retornara o objeto Graphql em caso de sucesso ou ServiceError em caso de erro.
    func getPostsWith(hashtag tag: String,endCursor: String, completion: @escaping (Result<Graphql,Error>)-> Void) {
        let url = InstaPostsAPISources.instaPosts(tag: tag).getURL()

        let parameters = [
            "max_id": endCursor
        ]
        
        switch url {
        case .success(let url):
            _ = manager.request(url: url, method: .get, parameters: parameters, headers: [:], completion: completion)
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    func getRelatedHashtags(hashtag: String, completion: @escaping (_ : [String]?) -> Void) {
        
        let text = hashtag.replacingOccurrences(of: "tattoo", with: "")
        
        var array : [String] = []
//        let url = (URL(string: "https://www.bing.com/images/search?q=\(text)+tattoo&go=Search&qs=n&form=QBIR&sp=-1&pq=ner+tattoo&sc=0-10&cvid=49F2AD66D2C94192AC3BEE808D538D14&first=1&scenario=ImageBasicHover&cc=\(Locale.current.languageCode!)") ?? URL(string: "https://www.bing.com/images/search?q=tattoo+tattoo&go=Search&qs=n&form=QBIR&sp=-1&pq=ner+tattoo&sc=0-10&cvid=49F2AD66D2C94192AC3BEE808D538D14&first=1&scenario=ImageBasicHover&cc=\(Locale.current.languageCode!)"))!
        let url = (URL(string: "https://www.bing.com/images/search?q=\(text)+tattoo&qs=HS&sc=3-0&cvid=70D9C109C1FB450E9B41A4D68103C9DB&form=QBLH&sp=1&first=1&scenario=ImageBasicHover&setlang=en")) ?? URL(string: "www.google.com")!
        
        if url.absoluteString == "www.google.com"{
            completion(nil)
        }
        
        let key = """
        <strong>
        """
        
        let request = URLRequest(url: url)
        //request.setValue("text/html;charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            
            
            
            guard let dataString = String(data: data, encoding: .utf8) else{
                completion(nil)
                return
            }
            
            let a = dataString.ranges(of: key)
            let value = a.count - 1
            
            
            if value < 0 {
                completion(nil)
                return
            }
            
            for i in 0...value{
                
                let c = dataString.index(a[i].lowerBound, offsetBy: 0)..<dataString.index(a[i].upperBound, offsetBy: 20)
                let su = dataString[c]
                let n = String(su.substring(from: ">", to: "<", options: .literal) ?? "tattoo").replacingOccurrences(of: " ", with: "")
                array.append(n)
                
                
            }
            
            completion(array)
            
        }
        
        task.resume()
        
    }
    
    
   
}
