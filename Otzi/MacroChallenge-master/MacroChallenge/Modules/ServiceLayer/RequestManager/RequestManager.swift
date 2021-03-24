//
//  RequestManager.swift
//  MacroChallenge
//
//  Created by Fábio França on 14/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Alamofire
import Foundation

/// Protocolo que contém os métodos para as requisições web
protocol RequestManager {
    /// Método génerico responsável por fazer requisição e retornar o objeto codable passado pelo completion
    /// - Parameters:
    ///   - url: URL para realização da request
    ///   - method: Método HTTP para realização da request (.get / .post)
    ///   - parameters: Parametros passado para requisição
    ///   - headers: Headers passado para requisição
    ///   - completion: Callback chamado após o término da requisição. Deve-se passar a classe codable para o parse neste completion.
    func request<T: Decodable>(url: URL, method: HTTPMethods, parameters: [String: Any], headers: [String: String], completion: @escaping(Result<T, Error>) -> Void) -> DataRequest?
    /// Método responsável por fazer requisição e retornar o objeto Data pelo completion
    /// - Parameters:
    ///   - url: URL para realização da request
    ///   - method: Método HTTP para realização da request (.get / .post)
    ///   - parameters: Parametros passado para requisição
    ///   - headers: Headers passado para requisição
    ///   - completion: Callback chamado após o término da requisição.
    func request(url: URL, method: HTTPMethods, parameters: [String : Any], headers: [String : String], completion: @escaping (Result<Data, Error>) -> Void) -> DataRequest?
}

/// Enum responsável pela criação do RequestManager. Os valores váriam entre as bibliotecas de networking implementadas.
enum RequestManagerFactory {
    case alamofire
    
    /// Método responsável pela criação do RequestManager.
    /// - Returns: RequestManager criado a partir do valor setado do enum.
    func create() -> RequestManager {
        switch self {
        case .alamofire:
            return AlamofireRequest()
        }
        // Fazer para UrlSession
    }
}

/// Enum responsável por especificar o método HTTP para cada RequestManager.
enum HTTPMethods: String {
    case get
    case post
    
    var alamofire: Alamofire.HTTPMethod {
        switch self {
        case .get:
            return Alamofire.HTTPMethod.get
        case .post:
            return Alamofire.HTTPMethod.post
        }
    }
    
    // Fazer para URLSession
}
