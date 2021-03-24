//
//  ImageAPI.swift
//  MacroChallenge
//
//  Created by Fábio França on 18/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit
import Alamofire

/// Classe especialista pela implementação dos métodos referente as requisições de UIImage a partir de uma URL.
class ImageAPI {
    static let imageCache = NSCache<NSString, ImageDownloaded>()
    private var runningRequests = [UUID: DataRequest]()
    private let manager: RequestManager
    private var loadingResponses = [URL: [(Result<UIImage, Error>) -> Void]]()
    private var idForURL = [String:UUID]()
    init(manager: RequestManager) {
        self.manager = manager
    }
    
    /// Método especialista responsável pela fetch de imagens a partir de uma URL. O método atrela um UUID para a requisição e coloca as imagens no cache. Caso a imagem buscada ja esteja no cache não é necessário a realização de uma nova requisição.
    /// - Parameters:
    ///   - baseURL: URL que deseja buscar a imagem.
    ///   - completion: Ao termino da requisição, o completion retornara a UIImage em caso de sucesso ou ServiceError em caso de erro.
    /// - Returns: UUID da requisição.
    func getImageWith(url baseURL: String, completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        
        
        
        let url: URL = {
            guard let url = URL(string: baseURL) else {
                preconditionFailure("A url Usando não está válida: \(ImageAPI.self)")
            }
            return url
        }()
        
        if let imageCache = ImageAPI.imageCache.object(forKey: url.absoluteString as NSString){
            completion(.success(imageCache.image))
            return nil
        }
        
        // em caso de mais de uma requisição na mesma url eu salvo os completion
        if loadingResponses[url] != nil {
            loadingResponses[url]?.append(completion)
            return nil
        } else {
            loadingResponses[url] = [completion]
        }
        
        
        let uuid = UUID()
        
        
        let task = manager.request(url: url, method: .get, parameters: [:], headers: [:]) { (dataResponse) in
            
            defer {self.runningRequests.removeValue(forKey: uuid)}
            
            do{
                let data = try dataResponse.get()
                guard let image = UIImage(data: data), let blocks = self.loadingResponses[url] else {
                    completion(.failure(ServiceError.emptyData))
                    return
                }
                ImageAPI.imageCache.setObject(ImageDownloaded(image: image), forKey: url.absoluteString as NSString)
                completion(.success(image))
                for block in blocks{
                    block(.success(image))
                }
            }catch{
                if let blocks = self.loadingResponses[url] {
                    for block in blocks{
                        block(.failure(ServiceError.emptyData))
                    }
                }
                return
            }
            
            self.loadingResponses.removeValue(forKey: url)//removo das loading responses
        }
        runningRequests[uuid] = task
        idForURL[url.absoluteString] = uuid
        
        
        return uuid
    }
 

    /// método que retorna uma imagem se tiver imagem no cache
    /// - Parameter url: url da imagem
    /// - Returns: UIImage?
    func getImageOnCache(by url: String) -> UIImage?{
        if let imageCache = ImageAPI.imageCache.object(forKey: url as NSString){
            return imageCache.image
        }
        return nil
    }
    
    
    
    /// Método responsável por remover do cache a imagem da URL requisitada.
    /// - Parameter url: URL da imagem que deseja retirar do cache.
    func cleanCache(){
        ImageAPI.imageCache.removeAllObjects()
    }
    
    /// Método responsável por cancelar a requisição que ainda está em andamento.
    /// - Parameter uuid: UUID da requisição que deseja cancelar.
    func cancelLoadRequest(uuid: UUID){
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
    
    func cancelLoadRequest(url: String){
        if let id = idForURL[url]{
            cancelLoadRequest(uuid: id)
        }
    }
    
}

