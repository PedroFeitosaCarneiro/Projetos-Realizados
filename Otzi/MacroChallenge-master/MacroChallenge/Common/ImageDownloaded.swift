//
//  ImageDownloaded.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 06/11/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

/// Um objeto que representa uma imagem no cache
class ImageDownloaded: NSObject , NSDiscardableContent {

    public var image: UIImage!

    init(image: UIImage) {
        super.init()
        self.image = image
    }
    func beginContentAccess() -> Bool {
        return true
    }

    func endContentAccess() {

    }

    func discardContentIfPossible() {

    }

    func isContentDiscarded() -> Bool {
        return false
    }
}

class PostDownloaded: NSObject , NSDiscardableContent {

    public var imageDownloaded: ImageDownloaded!
    public var post: Post!

    init(imageDownloaded: ImageDownloaded, post: Post) {
        super.init()
        self.imageDownloaded = imageDownloaded
        self.post = post
    }
    func beginContentAccess() -> Bool {
        return true
    }

    func endContentAccess() {

    }

    func discardContentIfPossible() {

    }

    func isContentDiscarded() -> Bool {
        return false
    }
}


