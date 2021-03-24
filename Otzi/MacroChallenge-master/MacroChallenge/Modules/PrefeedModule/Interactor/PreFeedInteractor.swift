//
//  PreFeedInteractor.swift
//  MacroChallenge
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 08/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit
import WebKit
class PreFeedInteractor : PreFeedInteractorToPresenter{
    
    
    
    private let serviceAPI: InstaPostsAPI
    private let imageAPI :ImageAPI
    private var hashtags: [HashtagSuggest]
    private var postsArray:[PreFeedData] = []
    private var sectionsArray : [PreFeedSection] = []
    private var orderArray : [String] = []
    
    
    private let preFeedQueue = DispatchQueue(label: "PreFeed", qos: .utility, attributes: .concurrent)
    private var cachePosts: [String:[Post]] = [:]
    private var cacheSections: [Int:String] = [:]
    private var imageTasks = [IndexPath: ImageRecord<PreFeedData>]()
    private var workers: ConcurrentDictionary<String, RequestWorker> = [:]
    private let semaphore = DispatchSemaphore(value: 1)
    let pendingOperations = PendingOperations()
    var numOfRequestWorkersFinished = 0
    let bingAPI: BingImageAPI

//    let dispatchGroup = DispatchGroup()
    init(serviceAPI: InstaPostsAPI, imageAPI: ImageAPI,hashtagsSearched: [HashtagSuggest]) {
        self.serviceAPI = serviceAPI
        self.imageAPI = imageAPI
        self.hashtags = hashtagsSearched
        let maneger = RequestManagerFactory.alamofire.create()
        self.bingAPI = BingImageAPI(manager: maneger)

    }
    
    var presenter: PreFeedPresenterToInteractor?
    
    func getPreFeedPosts(hashtag: String){
        
        fetchRelatedHashtags(hashtag: hashtag) { (_) in
            self.fetchHashtagPosts()
            
        }
        
    }
    
    
    private func fetchRelatedHashtags(hashtag: String ,completion: @escaping (_ finished: Bool) -> Void){
        serviceAPI.getRelatedHashtags(hashtag: hashtag) { [self] (values) in
            var cont = 0
            
            guard let values = values, !values.isEmpty else {
                self.presenter?.goToFeed(with: self.hashtags, with: nil)
                return
            }
            
            for value in values{
                let hash = HashtagSuggest(text: value + "tattoo")
                self.hashtags.append(hash)
                cont += 1
                if cont == 6 {
                    break
                }
            }
            completion(true)
        }
    }
    
    private func fetchHashtagPosts(){
        
//        tempFetchRequestPosts()
                let dispatchGroup = DispatchGroup()
        
                for hashtag in self.hashtags{
        
                    self.orderArray.append(hashtag.text)
        
                    var section = PreFeedSection(hashtagTittle: hashtag.text, items: [], endCursor: "")
                    var count = 0
        
                    dispatchGroup.enter()
                    bingAPI.getBingResultWith(hashtag: hashtag.text, offset: 0, quantity: 20) { [self] (result) in
        
                        defer{
                            dispatchGroup.leave()
                        }
        
                        guard let data = try? result.get(), let results = data.value else {
                            return
                        }
                     
                            var itemPosts : [Post] = [Post]()
                            for bing in results{
                                var desc = [Description]()
                                desc.append(Description(node: DescriptionPost(descriptionText: bing.name ?? "" )))
                                
                                itemPosts.append(Post(node: NodePost(imageUrl: bing.thumbnailUrl ?? bing.contentUrl ?? "", isVideo: false, descriptions: Descriptions(descriptions: desc), shortcode: bing.hostPageDisplayUrl ?? ""), isPostInstagram: false))
                            }
        
                            let numMaxOfPost = itemPosts.count > 13 ? 12 : itemPosts.count
        
                        while count <= numMaxOfPost,count < itemPosts.count{
                                section.items.append(PreFeedData(postURL: itemPosts[count].node.imageUrl, post: itemPosts[count]))
                                itemPosts.remove(at: count)
                                count+=1
                            }
        
                            self.cachePosts[hashtag.text] = itemPosts
        
            //                for item in itemPosts{
            //                    section.items.append(PreFeedData(postURL: item.node.imageUrl, post: item))
            //                    count += 1
            ////                    if count == 12 {
            ////                        break
            ////                    }
            //                }
                            section.endCursor = "\(data.nextOffset)"
                            self.sectionsArray.append(section)
                            count = 0
             
        
                    }
        
        
                }
        
                dispatchGroup.notify(queue: .main) {
        
                    var reorderedArray : [PreFeedSection] = []
        
                        for item in self.orderArray{
                            for section in self.sectionsArray{
        
                                if section.hashtagTittle == item {
                                    reorderedArray.append(section)
                                    break
                                }
        
                            }
                        }
        
        
                    if reorderedArray.isEmpty{
                        self.presenter?.sendErrorMessage()
                    }else{
                        self.presenter?.preFeedSectionsFetched(with: reorderedArray)
                    }
        
                }
        
    }
    
    
    
    
    func getHashtagImage(with post: PreFeedData, from section: String, at indexPath: IndexPath) {
        
        cacheSections[indexPath.section] = section
        
        if let task = imageTasks[indexPath]{
            task.object = post
            task.url = URL(string: post.postURL)
            startDownload(for: task, at: indexPath)
        }else{
            
            let record = ImageRecord(object: post, url: post.postURL, index: indexPath)
            imageTasks[indexPath] = record
            startDownload(for: record, at: indexPath)
            
        }
        
    }
    
    
    
    func isTattoo(image: UIImage) -> Bool{
        return FilterTattoo.shared.isTattoo(image: image)
    }
    
    
    func nextPost(from section: String) -> Post? {
        
        if let posts = self.cachePosts[section]{
            if let post = posts.first{
                self.cachePosts[section]?.removeFirst()
                return post
            }else{
                return nil
            }
            
        }
        
        return nil
    }
    
    /// Método para cancelar a requisição de uma imagem
    func cancelFetchImages() -> Void{
        
        for (_, operation) in pendingOperations.downloadsInProgress.enumerated(){
            operation.value.cancel()
        }
        for operation in pendingOperations.filtrationsInProgress{
            operation.value.cancel()
        }
        imageTasks.removeAll()
        for (_, work) in workers.enumerated(){
            let _ = workers.removeValue(forKey: work.key)
        }
    }
    
    
    func willDismiss() {
        cancelFetchImages()
        Cache.removeAllImages()
    }
    
    func getPostsCache(from section: String) -> [PreFeedData]? {
        if let itens = cachePosts[section]{
            var data = [PreFeedData]()
            for post in itens{
                data.append(PreFeedData(postURL: post.node.imageUrl, post: post))
            }
            return data
        }
        return nil
    }
    
    func pauseImageRequest(at index: IndexPath) {
        if let task = pendingOperations.downloadsInProgress[index]{
            let _ = task.cancel()
            let _ = pendingOperations.downloadsInProgress.removeValue(forKey: index)
        }
        
    }
    
    
    
    
    
    
}

extension PreFeedInteractor:ImageTaskDownloadedDelegate{
    func imageDownloaded(position: IndexPath) {
        
        let task = imageTasks[position]
        let image = task?.image
        let p = task?.object
        
        guard let img = image, let post = p else {
            debugPrint("Não encontrou image")
            self.presenter?.preFeedImageFetched(with: UIImage(), at: position, post: PreFeedData(postURL: "", post: Post(node: NodePost(imageUrl: "", isVideo: false, descriptions: Descriptions(descriptions: [Description]()), shortcode: ""))))
            return
        }
        self.presenter?.preFeedImageFetched(with: img, at: position, post: post)
        Cache.addNewImage(image: img, index: position, post: post.post)
//        preFeedQueue.async {
//            if self.isTattoo(image: img){
//                self.presenter?.preFeedImageFetched(with: img, at: position, post: post)
//                Cache.addNewImage(image: img, index: position, post: post.post)
//            }else{
//                let section = self.cacheSections[position.section]!
//                if let post  = self.nextPost(from: section){
//                    self.getHashtagImage(with: PreFeedData(postURL: post.node.imageUrl, post: post), from: section, at: position)
//                }else{
//                    self.presenter?.preFeedImageFetched(with: img, at: position, post:  post)
//                }
//                
//            }
//        }
        
        
    }
    
    
    
    func startDownload(for imageRecord: ImageRecord<PreFeedData>, at indexPath: IndexPath) {
        
        guard pendingOperations.downloadsInProgress[indexPath] == nil else {
            
            return
        }
        
        
        let downloader = ImageDownloader(imageRecord)
        
        
        downloader.completionBlock = {
            
            if downloader.isCancelled {
                return
            }
            let _ = self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
            if let index = self.imageTasks[indexPath]?.index{
                self.imageDownloaded(position: index)
            }
            
        }
        
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    
    
    func startFiltration(for img:  UIImage, at position: IndexPath, post: PreFeedData) {
        guard pendingOperations.filtrationsInProgress[position] == nil else {
            return
        }
        
        let filterer = FilterTattooOperation(img)
        filterer.completionBlock = { [self] in
            let section = cacheSections[position.section]!
            if filterer.isTattoo{
                self.presenter?.preFeedImageFetched(with: img, at: position, post: post)
                Cache.addNewImage(image: img, index: position, post: post.post)
            }else{
                
                if let post  = self.nextPost(from: section){
                    self.getHashtagImage(with: PreFeedData(postURL: post.node.imageUrl, post: post), from: section, at: position)
                }else{
                    self.presenter?.preFeedImageFetched(with: img, at: position, post:  post)
                }
                
            }
            
            
            self.pendingOperations.filtrationsInProgress.removeValue(forKey: position)
        }
        
        pendingOperations.filtrationsInProgress[position] = filterer
        pendingOperations.filtrationQueue.addOperation(filterer)
    }
    
    
    
}


extension PreFeedInteractor: RequestWorkerObserver {
    
    
    
    
    func tempFetchRequestPosts(){
        
        
        //        let dispatchGroup = DispatchGroup()
        numOfRequestWorkersFinished = hashtags.count
        for hashtag in self.hashtags{
            
            self.orderArray.append(hashtag.text)
            //
            //            var section = PreFeedSection(hashtagTittle: hashtag.text, items: [], endCursor: "")
            //            var count = 0
            
            //            dispatchGroup.enter()
            
            
            DispatchQueue.main.async {
                let worker = RequestWorker()
                worker.delegate = self
                worker.hashtag = hashtag.text
//                worker.workGroup = self.dispatchGroup
//                self.dispatchGroup.enter()
                worker.HTTPRequest(with: URL(string:"https://www.instagram.com/explore/tags/\(hashtag.text)/?__a=1")!)
                self.workers[hashtag.text] = worker
            }
            
            //            dispatchGroup.notify(queue: .main) {
            //
            //                var reorderedArray : [PreFeedSection] = []
            //
            //                for item in self.orderArray{
            //                    for section in self.sectionsArray{
            //
            //                        if section.hashtagTittle == item {
            //                            reorderedArray.append(section)
            //                            break
            //                        }
            //
            //                    }
            //                }
            //
            //                if reorderedArray.isEmpty{
            //                    self.presenter?.sendErrorMessage()
            //                }else{
            //                    self.presenter?.preFeedSectionsFetched(with: reorderedArray)
            //                }
            //
            //
            //            }
            //            self.serviceAPI.getPostsWith(hashtag: hashtag.text, endCursor: "") { [weak self] (result) in
            //
            //                defer{
            //                    dispatchGroup.leave()
            //                }
            //
            //                switch result{
            //                case .failure( _):
            ////                    self?.presenter?.sendErrorMessage()
            //                    break
            //                case .success(let success):
            //
            //
            //                    let endCursor = success.graphql.hashtag.edge.page.endCursor
            //
            //
            //                    var itemPosts = success.graphql.hashtag.edge.posts
            //
            //                    let numMaxOfPost = itemPosts.count > 13 ? 12 : itemPosts.count
            //
            //                    while count <= numMaxOfPost{
            //                        section.items.append(PreFeedData(postURL: itemPosts[count].node.imageUrl, post: itemPosts[count]))
            //                        itemPosts.remove(at: count)
            //                        count+=1
            //                    }
            //
            //                    self?.cachePosts[hashtag.text] = itemPosts
            //
            //    //                for item in itemPosts{
            //    //                    section.items.append(PreFeedData(postURL: item.node.imageUrl, post: item))
            //    //                    count += 1
            //    ////                    if count == 12 {
            //    ////                        break
            //    ////                    }
            //    //                }
            //                    section.endCursor = endCursor
            //                    self!.sectionsArray.append(section)
            //                    count = 0
            //                    break
            //
            //                }
            
            
            
            
            
        }
        
    }
    
    
    func internetFailed() {
        for (_, work) in workers.enumerated(){
            DispatchQueue.main.async {
                work.value.web.stopLoading()
            }
        }
        for (_, work) in workers.enumerated(){
            let _ = workers.removeValue(forKey: work.key)
        }
        hashtags.removeAll()
    }
    
    
    func notify(with object: Graphql?, from hashtag: String)  {
        numOfRequestWorkersFinished-=1
        if let obj = object {
            
            
            
            //removo do array de workers
            //        for (i,work) in workers.enumerated(){
            //            if let tag = work, tag.elementsEqual(hashtag){
            //                workers.remove(at: i)
            //            }
            //        }
            
            let _ = workers.removeValue(forKey: hashtag)
            
            let endCursor = obj.graphql.hashtag.edge.page.endCursor
            
            var count = 0
            var section = PreFeedSection(hashtagTittle: hashtag, items: [], endCursor: "")//mudar hashtag
            var itemPosts = obj.graphql.hashtag.edge.posts
            
            let numMaxOfPost = itemPosts.count > 13 ? 12 : itemPosts.count
            
            while count < itemPosts.count,count <= numMaxOfPost{
                
                section.items.append(PreFeedData(postURL: itemPosts[count].node.imageUrl, post: itemPosts[count]))
                itemPosts.remove(at: count)
                count+=1
            }
            
            self.cachePosts[hashtag] = itemPosts
            section.endCursor = endCursor
            self.sectionsArray.append(section)
            count = 0
            
        }
//        debugPrint("Num finshed ", numOfRequestWorkersFinished)
        if numOfRequestWorkersFinished <= 0{
            var reorderedArray : [PreFeedSection] = []
            
            for item in self.orderArray{
                for section in self.sectionsArray{
                    
                    if section.hashtagTittle == item {
                        reorderedArray.append(section)
                        break
                    }
                    
                }
            }
            
            if reorderedArray.isEmpty{
                self.presenter?.sendErrorMessage()
            }else{
                self.presenter?.preFeedSectionsFetched(with: reorderedArray)
            }
            
        }
//        dispatchGroup.notify(queue: .main) {
//
//            var reorderedArray : [PreFeedSection] = []
//
//            for item in self.orderArray{
//                for section in self.sectionsArray{
//
//                    if section.hashtagTittle == item {
//                        reorderedArray.append(section)
//                        break
//                    }
//
//                }
//            }
//
//            if reorderedArray.isEmpty{
//                self.presenter?.sendErrorMessage()
//            }else{
//                self.presenter?.preFeedSectionsFetched(with: reorderedArray)
//            }
//
//
//        }
        
    }
    
}
