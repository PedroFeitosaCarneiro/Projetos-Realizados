//
//  RequestManagerMock.swift
//  MacroChallengeTests
//
//  Created by Fábio França on 21/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

@testable import MacroChallenge
import Alamofire

@available(iOS 13.0, *)
class RequestManagerMock: RequestManager {
    enum Status {
        case sucess
        case emptyData
        case connectionError
        case apiError
    }
    
    let status: Status
    
    init(status: Status) {
        self.status = status
    }
    
    func request<T>(url: URL, method: HTTPMethods, parameters: [String : Any], headers: [String : String], completion: @escaping (Result<T, Error>) -> Void) -> DataRequest? where T : Decodable {
        switch status {
        case .sucess:
            print("aqui")
            //completion(.success())
        case .apiError:
            completion(.failure(ServiceError.apiError))
        case .emptyData:
            completion(.failure(ServiceError.emptyData))
        case .connectionError:
            completion(.failure(ServiceError.connectionError))
        }
        return nil
    }
    
    func request(url: URL, method: HTTPMethods, parameters: [String : Any], headers: [String : String], completion: @escaping (Result<Data, Error>) -> Void) -> DataRequest? {
        switch status {
        case .sucess:
            //completion(.sucess(Data()))
            print("aqui")
        case .apiError:
            completion(.failure(ServiceError.apiError))
        case .emptyData:
            completion(.failure(ServiceError.emptyData))
        case .connectionError:
            completion(.failure(ServiceError.connectionError))
        }
        return nil
    }
}
