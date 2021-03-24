//
//  FeedInteratorAux.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 31/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit

class FeedInterator: FeedInteratorToPresenter,RequestWorkerObserver {
    
    
    
    
   
    private enum InteratorState {
        case fetching
        case notFetching
    }
    
    let pendingOperations = PendingOperations()

    
    ///Properties temporaria para service layer
    private let serviceAPI: InstaPostsAPI
    private let imageAPI : ImageAPI
   
    var presenter: FeedPresenterToInterator?
    
    private var isNeedingMore = true
    private var isFirstTime = true
    private var hashtags: [HashtagSuggest]
    
    var endcursos: [(hasPage: Bool, endcursor:String)] = [(hasPage: true, endcursor: ""),(hasPage: true, endcursor: ""),(hasPage: true, endcursor: ""),(hasPage: true, endcursor: ""),(hasPage: true, endcursor: "")]
    var offsetBing = 0
    private var posts = [Post]()
    
    var cache = [Post](){ //Quando uma célula tá precisando de um post e não tem no cache eu salvo a refência do completion e chamo quando obter os posts
        didSet{
            for comp in nextPostsCompletion{
                if !cache.isEmpty{
                    comp(cache.first)
                    cache.removeFirst()
                }
                
            }
            nextPostsCompletion.removeAll()
        }
    }
    
    var imageRecords: ConcurrentDictionary<Int, ImageRecord<Post>> = [:]
    
    private let queueFeed = DispatchQueue(label: "fetchImagePresenter", qos: .utility, attributes: .concurrent)
    
    private var state: InteratorState = .notFetching

    private var favoriteButtonStatus: FaviteButtonStatus = .NotFavorited{
        didSet{
            presenter?.updateFavoriteButton(status: favoriteButtonStatus)
        }
    }
    let operationQueue = OperationQueue()
    private let dataManeger: CoreDataManager
    private var workers : ConcurrentDictionary<String, RequestWorker> = [:]
    var nextPostsCompletion: [(Post?) -> ()] = [(Post?) -> ()]()
    
    let bingAPI: BingImageAPI
    init(serviceAPI: InstaPostsAPI, imageAPI: ImageAPI,hashtagsSearched: [HashtagSuggest], dataManeger: CoreDataManager = CoreDataManager()) {
        self.serviceAPI = serviceAPI
        self.imageAPI = imageAPI
        self.hashtags = hashtagsSearched
        self.dataManeger = dataManeger
        let maneger = RequestManagerFactory.alamofire.create()
        self.bingAPI = BingImageAPI(manager: maneger)
        connectionStatusHasChange()
    }
    
    
    func fetchData() {
        starMonitoringConnection()
        
        verifyHashtagStatus()
        
        isNeedingMore = true
        
        if !deviceIsConnected(){
            presenter?.fetchDataFailed(error: .connectionError)
            return
        }
        
        if !cache.isEmpty{
            presenter?.fetchedDataSucessefully(data: cache)
            cache.removeAll()
            isNeedingMore = false
        }

        requestPosts()
        
    
    }
    
    /// Funcão para fazer a requisção de posts
    /// - Parameter completion: compliton optional para pegar o primeiro post da requisição
    private func requestPosts(completion: ((Post?) -> ())? = nil ){
        guard let _ = hashtags.first else {return}

        state = .fetching
        
        
        requestBingPosts(completion: completion)
        
        
//        if Logger.isLogged{
//            DispatchQueue.main.async { [self] in
//                let worker = RequestWorker()
//                worker.delegate = self
//                worker.hashtag = hashtags[0].text
//                if let url = URL(string:"https://www.instagram.com/explore/tags/\(hashtags[0].text)/?__a=1&max_id=\(self.endcursos[0].endcursor)"){
//                    worker.HTTPRequest(with: url)
//                    self.workers[hashtags[0].text] = worker
//                }else{
//                    fatalError()
//                }
//
//            }
//        }else{
//            requestBingPosts()
//        }
        
       
//
       
        
    }
    func notify(with object:  Graphql?, from hashtag: String) {
        guard let obj = object else {
            self.presenter?.fetchDataFailed(error: .emptyData)
            return
        }
        
        let result = obj.graphql.hashtag.edge.posts
        if result.isEmpty{
            if self.isFirstTime{
                self.presenter?.fetchDataFailed(error: .emptyData)
            }
            return
        }
        self.endcursos[0].endcursor = obj.graphql.hashtag.edge.page.endCursor
        self.endcursos[0].hasPage = obj.graphql.hashtag.edge.page.nextPage
        self.cache.append(contentsOf: result)
        self.state = .notFetching
        let _ = self.workers.removeValue(forKey: hashtag)
        self.noticePresenter()
        
        
    }
    
    func requestBingPosts(completion: ((Post?) -> ())? = nil){
        
        bingAPI.getBingResultWith(hashtag: hashtags[0].text, offset: offsetBing, quantity: 60) { [self] (result) in
            
            guard let data = try? result.get(), let results = data.value else {
                self.presenter?.fetchDataFailed(error: .emptyData)
                return
            }
            
            
            if results.isEmpty{
                if self.isFirstTime{
                    self.presenter?.fetchDataFailed(error: .emptyData)
                }
                return
            }
            
            
            self.offsetBing = data.nextOffset
            
            for bing in results{
                var desc = [Description]()
                desc.append(Description(node: DescriptionPost(descriptionText: bing.name ?? "" )))
                
                cache.append(Post(node: NodePost(imageUrl: bing.thumbnailUrl ?? bing.contentUrl ?? "", isVideo: false, descriptions: Descriptions(descriptions: desc), shortcode: bing.hostPageUrl ?? ""), isPostInstagram: false))
            }
            
            if let comp = completion{
                comp(cache.first)
                cache.removeFirst()
            }
            self.state = .notFetching
            self.noticePresenter()
            
            
            
        }
        
        
    }


    
    func noticePresenter(){
//        if isFirstTime{
//            isFirstTime = false
//            requestPosts()
//            isNeedingMore = false
//            return
//        }

        if isNeedingMore{
            presenter?.fetchedDataSucessefully(data: getCache())
            cache.removeAll()
            isNeedingMore = false
        }
        
        if cache.count < 50, state != .fetching{
            isNeedingMore = false
            requestPosts()
        }
    }
    
    private func getCache() -> [Post]{
        if cache.count > 100{
            let result = cache.splitInTwo()
            
            let temp = result[0]
            cache = result[1]
            return temp
        }
        return cache
    }
    
    func nextPost(completion: @escaping (Post?) -> ()) {
            if let post = cache.first{
                completion(post)
                cache.removeFirst()
            }else{
                guard state != .fetching else {
                    //Nesse caso eu salvo a referência do completion e quando terminar de baixar os posts eu chamo esse completion
                    nextPostsCompletion.append(completion)
                    
                    return
                }
                requestPosts { (post) in
                    if let post = post{
                        completion(post)
                    }
                }
            }
    
    }
    
    
    func viewWillDismiss() {
        Cache.removeAllImages()
        self.hashtags.removeAll()
        self.posts.removeAll()
        for i in 0..<endcursos.count {
            endcursos[i].hasPage = true
            endcursos[i].endcursor = ""
        }
        isNeedingMore = true
        isFirstTime = true
        stopMonitoringConnection()
        cancelFetchImages()
    }
    
    //MARK -> Favoritar uma hashtag
    
    /// método chamando pelo presenter, ou seja, quando o user dá um tap
    func saveHashtag() {
        if favoriteButtonStatus == .NotFavorited{
            saveHashtagsOnDataBase(userFavorite: true)
            addhapitcFeedBack(type: .success)
            favoriteButtonStatus = .Favorited
        }else{
            deleteHashtagOnDataBase()
            addhapitcFeedBack(type: .warning)
            favoriteButtonStatus = .NotFavorited
        }
    }
    
    
    func saveHashtagsOnDataBase(ranting: Double = 4.5, isSeachedTag:Bool = false, userFavorite: Bool = false){
        guard let hashtag = hashtags.first else {return}
        
        let predicate = NSPredicate(format: "name = %@ AND isSeachedTag == %@", argumentArray: [hashtag.text,true])

        if userFavorite{
            dataManeger.insert(with: TagEntity(name: hashtag.text, rating: ranting, isSeachedTag: isSeachedTag), completion: nil)
            favoriteButtonStatus = .Favorited
            return
        }
        
        dataManeger.fetch(entity: Tag.self, predicate: predicate) { [self] (hashtags, error) in
            if let _ = hashtags{
                return
            }else{
                dataManeger.insert(with: TagEntity(name: hashtag.text, rating: ranting, isSeachedTag: isSeachedTag), completion: nil)

            }
        }

        
    }
    
    func deleteHashtagOnDataBase(){
        guard let hashtag = hashtags.first else {return}
        let predicate = NSPredicate(format: "name = %@ AND isSeachedTag == %@", argumentArray: [hashtag.text,false])
        dataManeger.delete(entity: Tag.self, predicate: predicate) { _ in}
    }
    
    
    func addhapitcFeedBack(type: UINotificationFeedbackGenerator.FeedbackType){
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    
    
    /// método para verificar se a hashttag é favorita ou não
    func verifyHashtagStatus(){
        guard let hashtag = hashtags.first else {return}
        
        let predicate = NSPredicate(format: "name = %@ AND isSeachedTag == %@", argumentArray: [hashtag.text,false])

        
        dataManeger.fetch(entity: Tag.self, predicate: predicate) { [self] (hashtags, error) in
            if let _ = hashtags{
                self.favoriteButtonStatus = .Favorited
            }else{
                self.saveHashtagsOnDataBase(ranting: 3.0, isSeachedTag: true)//Salvo no database como hashtagBuscada
                self.favoriteButtonStatus = .NotFavorited
            }
        }
    }
    
}

//MARK: -> Connection
extension FeedInterator{
    
    
    func starMonitoringConnection() {
        NetStatus.shared.startMonitoring()
    }
    
    func stopMonitoringConnection() {
        NetStatus.shared.stopMonitoring()
    }
    
    func connectionStatusHasChange(){
        NetStatus.shared.netStatusChangeHandler = { [self] in
            if NetStatus.shared.isConnected{
                if !self.cache.isEmpty{
                    self.presenter?.fetchedDataSucessefully(data: self.cache)
                }
            }else{
                self.presenter?.fetchDataFailed(error: .connectionError)
            }
        }
    }
    
    func deviceIsConnected() -> Bool{
        return Connectivity.isConnectedToInternet
    }
    
}


//MARK: -> Image dowloand logic
extension FeedInterator: ImageTaskDownloadedDelegate{
    
    
    func isTattoo(image: UIImage) -> Bool{
        return FilterTattoo.shared.isTattoo(image: image)
    }
    
    
    func getImageOnCache(by url: String) -> UIImage? {
        return imageAPI.getImageOnCache(by: url)
    }
    
    func cancelLoadRequest(url: String){
        imageAPI.cancelLoadRequest(url: url)
    }
    
    /// Método chamado quando a imagem termina de baixar
    /// - Parameter position: IndexPath de quem requisitou a image
    func imageDownloaded(position: IndexPath) {

        
        let task = imageRecords[position.row]
        let image = task?.image
        let p = task?.object
        guard let img = image, let post = p else {
            print("Não encontrou image")
            self.nextPost { (newPost) in
                if let newPost = newPost{
                    self.fetchImage(with: newPost, from: position)
                }
            }
            return
        }
//        if Logger.isLogged{
            queueFeed.async {
                
                if self.isTattoo(image: img){
                    self.presenter?.didFinishDownload(img: img, post: post, index: position)
                    Cache.addNewImage(image: img, index: position, post: post)
                }else{
                    self.nextPost { (newPost) in
                        if let newPost = newPost{
                            self.fetchImage(with: newPost, from: position)
                        }else{
                            self.presenter?.didFinishDownload(img: img, post: post, index: position)
                        }
                    }
                    
                }
            }
//        }
//        else{
//            Cache.addNewImage(image: img, index: position, post: post)
//            self.presenter?.didFinishDownload(img: img, post: post, index: position)
//        }
        

    }
    
    /// Pausar uma task
    /// - Parameter index: posição da célula que pediu uma task
    func pauseImageRequest(at index: IndexPath) {
        pauseDownloadOperation(index: index)
    }
    
    
    
    func fetchImage(with post: Post, from index: IndexPath) {
   
        if let task = imageRecords[index.row]{
            task.object = post
            task.url = URL(string: post.node.imageUrl)
            startDownload(for: task, at: index)
        }else{
            let record = ImageRecord(object: post, url: post.node.imageUrl, index: index)
            imageRecords[index.row] = record
            startDownload(for: record, at: index)

        }
       
    }
    
    
    
    /// Método para cancelar a requisição de uma imagem
    func cancelFetchImages() -> Void{
        for (_, operation) in pendingOperations.downloadsInProgress.enumerated(){
            operation.value.cancel()
        }
//        for (_, work) in workers.enumerated(){
//            let _ = workers.removeValue(forKey: work.key)
//        }
        for (_, record) in imageRecords.enumerated() {
            let _ = imageRecords.removeValue(forKey: record.key)
        }
    }
    
}




//MARK: -> Operation

extension FeedInterator{
    
    /// Método para suspender todas as operations
    func suspendAllOperations() {
      pendingOperations.downloadQueue.isSuspended = true
      pendingOperations.filtrationQueue.isSuspended = true
    }
    
    /// Método para resume todas as operations
    func resumeAllOperations() {
      pendingOperations.downloadQueue.isSuspended = false
      pendingOperations.filtrationQueue.isSuspended = false
    }
    
    
    func loadImagesForOnscreenCells(indexPathsForVisibleRows: [IndexPath]?) {
      
      if let pathsArray = indexPathsForVisibleRows {
        
        let allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
//        allPendingOperations.formUnion(pendingOperations.filtrationsInProgress.keys)
          
      
        var toBeCancelled = allPendingOperations
        let visiblePaths = Set(pathsArray)
        toBeCancelled.subtract(visiblePaths)
       
        
        var toBeStarted = visiblePaths
        toBeStarted.subtract(allPendingOperations)
          
        
        for indexPath in toBeCancelled {
          if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
            pendingDownload.cancel()
          }
          let _ = pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
//          if let pendingFiltration = pendingOperations.filtrationsInProgress[indexPath] {
//            pendingFiltration.cancel()
//          }
//          pendingOperations.filtrationsInProgress.removeValue(forKey: indexPath)
        }
          
        for indexPath in toBeStarted {
          let recordToProcess = imageRecords[indexPath.row]
            if let record = recordToProcess{
                startDownload(for: record, at: indexPath)
            }
        }
      }
    }
    
    
    
    /// Método
    /// - Parameter index: indexPath referente a operation
    func pauseDownloadOperation(index: IndexPath){
        if let task = pendingOperations.downloadsInProgress[index]{
            task.cancel()
            let _ = pendingOperations.downloadsInProgress.removeValue(forKey: index)
        }
    }
    
    
    
    /// Função para começar a fazer o downlaod de uma imagem
    /// - Parameters:
    ///   - photoRecord: Uma imageRecord relacionada ao downlaod
    ///   - indexPath: indexPath de quem requisitou
    func startDownload(for imageRecord: ImageRecord<Post>, at indexPath: IndexPath) {
        
        guard pendingOperations.downloadsInProgress[indexPath] == nil else {
            return
        }
        
        
        let downloader = ImageDownloader(imageRecord)
        
        
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            let _ = self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
            if let index = self.imageRecords[indexPath.row]?.index{
                self.imageRecords[indexPath.row] = downloader.imageRecord
                self.imageDownloaded(position: index)
            }
            
        }
        
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    
    
    /// Método para começar a FilterOpteration
    /// - Parameters:
    ///   - img: a imagem a ser filtrada
    ///   - position: a posição de quem requisitou a filtragem
    ///   - post: o post referente aquela image
    func startFilterTattoo(for img:  UIImage, at position: IndexPath, post: Post) {
      guard pendingOperations.filtrationsInProgress[position] == nil else {
          return
      }

      let filterer = FilterTattooOperation(img)
      filterer.completionBlock = {
        if  filterer.isTattoo{
            self.presenter?.didFinishDownload(img: img, post: post, index: position)
            Cache.addNewImage(image: img, index: position, post: post)
        }else{
            self.nextPost { (post) in
                if let post = post{
                    self.fetchImage(with: post, from: position)
                }else{
                     print("não conseguiu o post e a imagem vai ficar carregando pra smp")
                }
            }

        }
        
        
        self.pendingOperations.filtrationsInProgress.removeValue(forKey: position)
      }

      pendingOperations.filtrationsInProgress[position] = filterer
      pendingOperations.filtrationQueue.addOperation(filterer)
    }

}
