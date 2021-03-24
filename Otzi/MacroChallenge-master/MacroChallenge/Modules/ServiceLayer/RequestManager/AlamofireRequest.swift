//
//  AlamofireRequest.swift
//  MacroChallenge
//
//  Created by Fábio França on 14/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Alamofire

enum ServiceError: Error{
    case emptyData
    case connectionError
    case apiError
    
    var localizedDescription: String{
        switch self {
        case .apiError:
            return "Something went wrong."
        case .emptyData:
        return "Nothing was found, try again or change the filters."
        case .connectionError:
        return "Your phone is not connected, conecte it and try again."
        }
    }
}

/// Classe responsável por assinar e implementar os métodos do RequestManager usando a biblioteca Alamofire.
class AlamofireRequest: RequestManager {
    
    func request<T>(url: URL, method: HTTPMethods, parameters: [String : Any], headers: [String : String], completion: @escaping (Result<T, Error>) -> Void) -> DataRequest? where T : Decodable {
        
        if !Connectivity.isConnectedToInternet{
            completion(.failure(ServiceError.connectionError))
        }
        
       
        return request(url: url, method: method, parameters: parameters, headers: headers) { (response) in
            do{
                let object = try JSONDecoder().decode(T.self, from: response.get())
                completion(.success(object))
            }catch{
                
                
                
               // debugPrint("Erro na realização do parse: \(error.localizedDescription)")
                completion(.failure(ServiceError.apiError))
            }
        }
    }
    
    func request(url: URL, method: HTTPMethods, parameters: [String : Any], headers: [String : String], completion: @escaping (Result<Data, Error>) -> Void) -> DataRequest? {
        let request = AF.request(url, method: method.alamofire, parameters: parameters, headers: HTTPHeaders(headers)).responseData { response in
            switch response.result {
            case let .success(data):
                completion(.success(data))
            case .failure(_):
                debugPrint("Erro no response do alamofire")
                completion(.failure(ServiceError.emptyData))
            }
        }
        return request
    }
}
