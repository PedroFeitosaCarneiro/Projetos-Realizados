//
//  Animation.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 05/11/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

protocol AnimatableView where Self: UIView{
    var isAnimated: Bool {get set}
}


typealias AnimationType = (AnimatableView,IndexPath,UICollectionView)->()


enum Animation {
    
    case fromRight(duration: TimeInterval, delay: Double)
  
    var type: AnimationType{
        switch self {
        case .fromRight(let duration, let delay):
            return { view, indexPath, collectionView in
                view.transform = CGAffineTransform(translationX: collectionView.bounds.width, y: 0)
                UIView.animate(
                    withDuration: duration,
                    delay: delay * Double(indexPath.row),
                    options: [.curveEaseInOut],
                    animations: {
                        view.transform = CGAffineTransform(translationX: 0, y: 0)
                    }) { (_) in
                    view.isAnimated = true
                }
            }
        }
    }
    
    
    
}

final class Animator{
    
    private let animation: Animation
    var hasAnimated = false
    init(animation: Animation) {
        self.animation = animation
    }
    
    
    func animate(_ cell: AnimatableView,_ index: IndexPath,_ colleciton: UICollectionView)->(){
        animation.type(cell,index,colleciton)
    }
    
    
}



