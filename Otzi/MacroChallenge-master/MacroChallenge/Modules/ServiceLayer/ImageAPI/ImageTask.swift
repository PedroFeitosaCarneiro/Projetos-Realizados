//
//  ImageTask.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 31/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit


class ImageTask<T> : NSObject{
    
    let position: IndexPath
    var url: URL?
    let session: URLSession
    let delegate: ImageTaskDownloadedDelegate
    
    var image: UIImage?
    var object: T?
    
    /*private*/ var task: URLSessionDownloadTask?
 /*private*/ var resumeData: Data?
 /*private*/ var isDownloading = false
 /*private*/ var isFinishedDownloading = false
 /*private*/ var loadingResponses = [IndexPath: [(url: URL?, response: URLResponse?, error: Error?)]]()
    
    
    init(position: IndexPath, object: T,url: String, session: URLSession, delegate: ImageTaskDownloadedDelegate) {
        self.position = position
        self.object = object
        self.session = session
        self.delegate = delegate
        self.url = URL(string: url)
        super.init()
    }
    
    /// Método que começa ou retorna uma requisição que estava em andamento
    func resume() {
        
        guard let url = self.url else {
            return
        }
        
        if let postDownloaded = Cache.getImageOnCache(index: self.position){
            self.image = postDownloaded.imageDownloaded.image
            self.delegate.imageDownloaded(position: self.position)
            return
        }
        isFinishedDownloading = false
        
        if !isDownloading && !isFinishedDownloading {
            isDownloading = true
            debugPrint("FAZENDO DOWNLOAD NA POSITION \(position.row)")
            if let resumeData = resumeData {
                task = session.downloadTask(withResumeData: resumeData, completionHandler: downloadTaskCompletionHandler)
            } else {
                task = session.downloadTask(with: url, completionHandler: downloadTaskCompletionHandler)
            }
            
            task?.resume()
        }else{
            
        }
    }
    
    /// Método que pausa uma requisição
    func pause() {
        if isDownloading && !isFinishedDownloading {
            task?.cancel(byProducingResumeData: { (data) in
                self.resumeData = data
            })
            
            self.isDownloading = false
        }
    }
    
    

    
    /// Completion que é chamando quando uma requisição termina
    /// - Parameters:
    ///   - url: url onde o arquivo foi salva
    ///   - response: respose da requisiçãp
    ///   - error: erro da requisição
    private func downloadTaskCompletionHandler(url: URL?, response: URLResponse?, error: Error?) {
        debugPrint("TERMINOU DOWNLOAD NA POSITION \(position.row)")
        if let error = error {
            print("Error downloading: \(position.row)", error)
//            
            if (error as NSError).code == NSURLErrorCancelled{
                isDownloading = false
                isFinishedDownloading = false
                resumeData = nil
                resume()
            }else{
                
                debugPrint("RANGEL DEU UM ERRO MT RUIM")
            }
            
            
            return
        }
        
        guard let url = url else { return }
        guard let data = FileManager.default.contents(atPath: url.path) else { return }
        guard let image = UIImage(data: data) else { return }
        
        self.image = image
        self.isDownloading = false
        self.isFinishedDownloading = true
        self.delegate.imageDownloaded(position: self.position)
    }
    
    
    /// Método para resetar a task
    func resetTask(removeFromCache: Bool = true){
        self.isDownloading = false
        self.isFinishedDownloading = false
        self.resumeData = nil
        if removeFromCache{
            Cache.removeImage(index: self.position)
        }
        self.object = nil
    }
    
    
    /// Método para cancelar uma request sem salvar seu progresso
    func cancelRequest(){
        self.task?.cancel()
    }
}


final class Cache{
 
    
    private static let postCache = NSCache<NSIndexPath, PostDownloaded>()
    private static let semaphore = DispatchSemaphore(value: 1)
    
    static func removeAllImages() {
        Cache.postCache.removeAllObjects()
    }
    
    static func removeImage(index: IndexPath?){
        guard let index = index else {
            return
        }
        semaphore.wait()
        Cache.postCache.removeObject(forKey: index as NSIndexPath)
        semaphore.signal()
    }
        
        
    /// método que retorna uma imagem se tiver imagem no cache
    /// - Parameter postion: chave da imagem
    /// - Returns: UIImage?
    static func getImageOnCache(index: IndexPath?) -> PostDownloaded?{
        guard let index = index else {
            return nil
        }
        if let postDownloaded = Cache.postCache.object(forKey: index as NSIndexPath) {
            return postDownloaded
        }
        return nil
    }
    
    static func addNewImage(image: UIImage, index: IndexPath, post: Post){
        semaphore.wait()
        postCache.setObject(PostDownloaded(imageDownloaded: ImageDownloaded(image: image), post: post), forKey:  index as NSIndexPath)
        semaphore.signal()
    }
    
}


protocol Cacheble {
    var id: UUID {get}
}
