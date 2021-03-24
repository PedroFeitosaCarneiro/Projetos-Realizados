//
//  FeedDataSource.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 08/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit
import os



class FeedViewDelegate: NSObject, UICollectionViewDelegate, UIScrollViewDelegate{
    
    
    var animation: AnimationProtocol?
        
    private var oldImages: [UIImage] = []
    
    
    var didSelectItemAt:((IndexPath)->()) = {_ in}
    var didDeselectItemAt:((IndexPath)->()) = {_ in}
    var didScroll:((UIScrollView)->()) = {_ in}
    var didEndDecelerating:((UIScrollView)->()) = {_ in}
    ///Closure chamada quando o usuário deselecionar um item
    var willDisplayItemAt:((IndexPath)->()) = {_ in}
    
    
    var didEndDisplaying:((IndexPath)->()) = {_ in}
    var willBeginDragging: (()->()) = {}
    var didEndDragging: (()->()) = {}

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll(scrollView)
    }
    
    //compute the offset and call the load method
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        didEndDecelerating(scrollView)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cellTouched = collectionView.cellForItem(at: indexPath) as? FeedCell {
            if let cells = collectionView.visibleCells as? [FeedCell] {
                let newCells = cells.filter{ $0 != cellTouched }
                var images = [UIImage]()
                for cell in newCells {
                    if let image = cell.coverImage.image {
                        images.append(image)
                    }
                }
                
                for image in images {
                    oldImages = oldImages.filter{$0 != image}
                }
                
                oldImages.append(contentsOf: images)
                guard let post = cellTouched.post, let mainImage = cellTouched.coverImage.image else {
                    return
                }
                collectionView.isUserInteractionEnabled = false
                animation?.populateAnimationView(post: post, main: mainImage, outherImages: oldImages.reversed())
                animation?.run()
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width/4, height:  collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        willDisplayItemAt(indexPath)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        didEndDisplaying(indexPath)
    }
    
    
    
     func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
      //1
        willBeginDragging()
    }

     func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
      // 2
      if !decelerate {
        didEndDragging()
      }
    }

    
    

}



