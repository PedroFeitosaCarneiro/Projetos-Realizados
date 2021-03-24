//
//  ExplorerInterator.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 24/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit
enum ExploreError: Error{
    case NotFavoriteHashtags
    
    var localizedDescription: String{
        switch self {
        case .NotFavoriteHashtags:
            return "You still don't have saved any hashtag."
        }
    }

}

class ExplorerInterator: ExploreInteratorToPresenter{
   
    ///Funções comentadas é pq ainda podem ser alteradas
    
    var presenter: ExplorePresenterToInterator?
    
    ///Properties temporaria para service layer
    private let serviceAPI: InstaPostsAPI
  
    private let imageAPI :ImageAPI
    
    private let fileReader: FileReaderble
    
    private var hashs = [HashtagSuggest]()
    
    private var posts = [Post]()
    
    private let dataManeger: CoreDataManager

    
    private var imagesCache = NSCache<NSString, NSString>()
    
    private var recommendationNumber = 1
    private var hasDelay = false
    private var workers : ConcurrentDictionary<String, RequestWorker> = [:]
    private var completionsImages: [String: (UIImage, String) -> Void] = [:]
    private var currentRecommendationIndex = 0
    init(serviceAPI: InstaPostsAPI, imageAPI: ImageAPI, fileReader: FileReaderble = FileReader.init(), dataManeger: CoreDataManager ){
        self.serviceAPI = serviceAPI
        self.imageAPI = imageAPI
        self.fileReader = fileReader
        self.dataManeger = dataManeger
        self.setupFiles()
        self.getImageCache()
    }
    
    func fetchHashtags(_ type: HashtagsType,reloadContent: Bool) {
    
        if type == .Suggest {
            getRecomendations(reloadContent: reloadContent)
        }else{
            getUserFavorites()
        }
       
        
    }
    
    
   
    
    
    /// Pega as hashtags favoritadas pelo usuário
    private func getUserFavorites(){
        let predicate = NSPredicate(format: "isSeachedTag == %@", argumentArray: [false])

        
        dataManeger.fetch(entity: Tag.self, predicate: predicate) { [self] (hashtags, error) in
            if let hashtags = hashtags{
                hashtags.forEach { hashtag in
                    if let text = hashtag.name{
                        self.hashs.append(HashtagSuggest(text: text))
                    }
                }
                self.presenter?.fetchedHashTagsSucessefully(hashtags: self.hashs)
                self.hashs.removeAll()
            }else{
                self.presenter?.fetchHashtagFailed(error: ExploreError.NotFavoriteHashtags)
            }
        }
    }
   
    
    
    
    /// Pega as recomenda≈ões de hashtags para o usuário através do modelo
    private func getRecomendations(reloadContent: Bool){
        
        dataManeger.fetch(entity: Tag.self) { [self] (hashtags, error) in
            var userLikes = [String: Double]()
            
            hashtags?.forEach { (tag) in
                if let name = tag.name{
                    userLikes[name] = tag.rating
                }
            }
            
            if let recommendations = HashtagRecommendationML.sharedInstance.getRecommendation(userLikes: userLikes,quantity: Int64(recommendationNumber * 28)){
                
                let ini = currentRecommendationIndex < recommendations.count-27 ? currentRecommendationIndex : 0
                for i in ini..<recommendations.count{
                    self.hashs.append(HashtagSuggest(text: recommendations[i]))
                    currentRecommendationIndex = i
                }
                
                if !reloadContent{
                    self.presenter?.fetchedHashTagsSucessefully(hashtags: self.hashs)//self.hashs.shuffled()
                    self.hashs.removeAll()
                    self.recommendationNumber += 1
                }else{
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1500)) {
                        self.presenter?.fetchedHashTagsSucessefully(hashtags: self.hashs.shuffled())
                        self.hashs.removeAll()
                        self.recommendationNumber += 1
                    }
                }
                return
            }
            
            
            debugPrint("Pegou hashtags do file")
            self.fatchHashtagfromFile()
        }
        
        
    }
    
    private func fatchHashtagfromFile(){
        do{
            let result = try fileReader.loadFileFromBundle(name: "HashtagsData", fileExtension: "txt")
            
            
            result.forEach { (hashtag) in
                if !hashtag.elementsEqual(""){
                    hashs.append(HashtagSuggest(text: hashtag))
                }
            }
            presenter?.fetchedHashTagsSucessefully(hashtags: hashs)

        }catch{
            debugPrint("Error na leitura do arquivo de hashtags")
            presenter?.fetchHashtagFailed(error: ExploreError.NotFavoriteHashtags)
        }
    }
    
    func cancelFetchImage(by uuid: UUID?) {
        guard let id = uuid else {
            return
        }
        imageAPI.cancelLoadRequest(uuid: id)
    }
    
    func getImageOnCache(by url: String?) -> UIImage? {
        guard let url = url else {
            return nil
        }
        return imageAPI.getImageOnCache(by: url)
    }
    
    
    
    
}




//MARK: -> Network Logic
extension ExplorerInterator: RequestWorkerObserver{

    
    /// Método para baixar uma imagem a partir de uma url
    /// - Parameters:
    ///   - url: url da imagem
    ///   - completion: completion com o resultado
    /// - Returns: uuid da requisição
    func fetchImage(with url: String, completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        return imageAPI.getImageWith(url: url, completion: completion)
    }
    
    /// Método para baixar uma imagem a partir de uma hashtaf
    /// - Parameters:
    ///   - url: url da imagem
    ///   - completion: completion com o resultado
    /// - Returns: uuid da requisição
    func fetchHashtagImage(from hashtag: HashtagSuggest, completion: @escaping (UIImage, String) -> Void) -> UUID?{
        
        
//        let dispatchQueue = DispatchQueue(label: "ExploreFetchImage", qos: .utility, attributes: .concurrent)
        
        
        if let url = imagesCache.object(forKey: hashtag.text.lowercased() as NSString){
            let _ = self.imageAPI.getImageWith(url: url as String, completion: {(result) in
                if let img = try? result.get(){
                    completion(img,url as String)
                }else{
                    //Entra aqui quando o link salvo no file está quebrado
                    self.imagesCache.removeObject(forKey: hashtag.text.lowercased() as NSString)
                    let _ = self.fetchHashtagImage(from: hashtag, completion: completion)
                }
            })
            return nil
        }
        
//        dispatchQueue.async { [self] in
//
//
//            self.serviceAPI.getPostsWith(hashtag: hashtag.text, endCursor: "") { (result) in
//
//
//                let result = try? result.get()
//
//                guard let newResult = result else {
//                    return
//                }
//                let temPosts = newResult.graphql.hashtag.edge.posts
//
//
//                dispatchQueue.async { [self] in
//                    findImageTattoo(posts: temPosts, from: hashtag, completion: completion)
//                }
//
//
//            }
//        }
        completionsImages[hashtag.text] = completion
        DispatchQueue.main.async { [self] in
            let worker = RequestWorker()
            worker.delegate = self
            worker.hashtag = hashtag.text
            if let url = URL(string:"https://www.instagram.com/explore/tags/\(hashtag.text)/?__a=1"){
                worker.HTTPRequest(with: url)
                self.workers[hashtag.text] = worker
            }else{
                fatalError()
            }

        }
        return nil
    }
    
    
    func notify(with object: Graphql?, from hashtag: String) {
        guard let newResult = object else {
            return
        }
        let temPosts = newResult.graphql.hashtag.edge.posts
        
        if let comp = completionsImages[hashtag]{
            DispatchQueue.global().async { [self] in
                findImageTattoo(posts: temPosts, from: HashtagSuggest(text: hashtag), completion: comp)
            }
            completionsImages.removeValue(forKey: hashtag)
            let _ = workers.removeValue(forKey: hashtag)
        }

    }
    
    
    private func findImageTattoo(posts: [Post],from hashtag: HashtagSuggest,completion: @escaping (UIImage, String) -> Void){
        
        var postsAux = posts
        
        
        guard let post = posts.first else {return}
        postsAux.removeFirst()
        let _ = self.imageAPI.getImageWith(url: post.node.imageUrl, completion: {result in
            if let img = try? result.get(){
                if FilterTattoo.shared.isTattoo(image: img){
                    completion(img,post.node.imageUrl)
                    self.updateCache(hashtag: hashtag, url: post.node.imageUrl)
                }else{
                    self.findImageTattoo(posts: postsAux, from: hashtag, completion: completion)
                }
                
            }
        })
        
        
    }
    
    /// método que carrega as urls no cache
    func getImageCache(){
        let urls = try? fileReader.loadFileFromFileManeger(name: "hashtagsuggest", fileExtension: "txt")
        
        guard let imagesURL = urls else {return}
        
        for linha in imagesURL{
            let s = linha.split(maxSplits: 1, omittingEmptySubsequences: true) { (c) -> Bool in
                return c == ":"
            }
            
            if s.count >= 2{
                
                let object = NSString(string: String(s[1]))
                let key = NSString(string: String(s[0]))
                
                
                imagesCache.setObject(object, forKey: key)
                
            }
            
        }
    }
    
    
    /// Método para configurar os files necessários para esse módulo
    func setupFiles(){
        let loadedFiles = UserDefaults.standard.bool(forKey: "LoadedFiles")
        
        if !loadedFiles{
            do {
                let hashtags =  try fileReader.loadFileFromBundle(name: "hashtagsuggest", fileExtension: ".txt")
                try fileReader.writeFile(texts: hashtags, fileName: "hashtagsuggest", fileExtension: "txt")
                UserDefaults.standard.set(true, forKey: "LoadedFiles")
            } catch {
                debugPrint("")
            }
        }
             
    }
    
    /// Função para atualizar o cache quando não encontra o elemnto no cache
    /// - Parameters:
    ///   - hashtag: hashtag a ser add ao cache
    ///   - url: url referente á hashtag
    private func updateCache(hashtag:HashtagSuggest, url: String){
        let fileName = "hashtagsuggest"
        let fileExtension = "txt"
        var urls = try? fileReader.loadFileFromFileManeger(name: fileName, fileExtension: fileExtension)
        urls?.append(hashtag.text.lowercased()+":"+url)
        
        guard  let cache = urls, !cache.contains(hashtag.text) else {
            return
        }
        
        try? fileReader.writeFile(texts: cache, fileName: fileName, fileExtension: fileExtension)
        
        
        let object = NSString(string: hashtag.text.lowercased())
        let key = NSString(string: url)
        
        imagesCache.setObject(object, forKey: key)
        
    }
}


