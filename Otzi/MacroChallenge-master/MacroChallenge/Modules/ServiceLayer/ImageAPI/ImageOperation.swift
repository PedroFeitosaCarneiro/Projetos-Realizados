//
//  ImageOperation.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 14/11/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit



/// enum que representa o estado dá imagem
enum ImageRecordState {
  case new, downloaded, filtered, failed
}

/// Objeto que representa o dowloand de uma imamge
class ImageRecord<T> {
    
    var object: T
    var url: URL?
    var state = ImageRecordState.new
    var image: UIImage?
    var index: IndexPath
    
    
    /// Init do ImageRecord
    /// - Parameters:
    ///   - object: Objeto relacionado a image
    ///   - url: url da image
    ///   - index: indexPath da célula que socilitou a image
    init(object:T, url:String, index: IndexPath) {
        self.object = object
        self.url = URL(string: url)
        self.index = index
    }
    
}


/// Objeto para rastrear as operations em pendência
final class PendingOperations {
    
    
    lazy var downloadsInProgress: ConcurrentDictionary<IndexPath,Operation> = [:]//[IndexPath: Operation] = [:]
  lazy var downloadQueue: OperationQueue = {
    var queue = OperationQueue()
    queue.name = "Download image queue"
    return queue
  }()
  
  lazy var filtrationsInProgress: [IndexPath: Operation] = [:]
    
  lazy var filtrationQueue: OperationQueue = {
    var queue = OperationQueue()
    queue.name = "Image is Tattoo queue"
    return queue
  }()
}


/// Operation que representa o download de uma image
class ImageDownloader<T>: Operation {

  let imageRecord: ImageRecord<T>
    
    /// Init do ImageDownloader
    /// - Parameter imageRecord: um image record referente a operation
  init(_ imageRecord: ImageRecord<T>) {
    self.imageRecord = imageRecord
  }
  
  override func main() {
    
    if isCancelled {
      return
    }

    if let postDownloaded = Cache.getImageOnCache(index: imageRecord.index) {
        
        if let post = postDownloaded.post, let newPost = post as? T {
            imageRecord.image = postDownloaded.imageDownloaded.image
            imageRecord.object = newPost
            imageRecord.state = .downloaded
            return
        }
    }

    guard let url = imageRecord.url, let imageData = try? Data(contentsOf: url) else { return }
    
    if isCancelled {
      return
    }
  
    
    if !imageData.isEmpty {
        imageRecord.image = UIImage(data: imageData)
        imageRecord.state = .downloaded
    } else {
        imageRecord.state = .failed
        imageRecord.image = UIImage(named: "teste10")
    }
  }
}


