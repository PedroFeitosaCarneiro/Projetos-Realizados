//
//  SkeletonDisplayable.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 02/11/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

protocol SkeletonDisplayable {
    func showSkeleton()
    func hideSkeleton()
}

extension SkeletonDisplayable where Self: UIViewController {
    var skeletonLayerName: String {
        return "skeletonLayerName"
    }

    var skeletonGradientName: String {
        return "skeletonGradientName"
    }

    private func skeletonViews(in view: UIView) -> [UIView] {
        var results = [UIView]()
        for subview in view.subviews as [UIView] {
            switch subview {
            case _ where subview.isKind(of: UILabel.self):
                results += [subview]
            case _ where subview.isKind(of: UIImageView.self):
                results += [subview]
            case _ where subview.isKind(of: UIButton.self):
                results += [subview]
            case _ where subview.isKind(of: UIActivityIndicatorView.self):
                break
            default: results += skeletonViews(in: subview)
            }

        }
        return results
    }

    func showSkeleton() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){ [self] in //é necessário esse delay para funcionar
        
        let skeletons = skeletonViews(in: self.view)
        let backgroundColor = UIColor(red: 210.0/255.0, green: 210.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor
        let highlightColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0).cgColor

        let skeletonLayer = CALayer()
        skeletonLayer.backgroundColor = backgroundColor
        skeletonLayer.name = skeletonLayerName
        skeletonLayer.anchorPoint = .zero
        skeletonLayer.frame.size = UIScreen.main.bounds.size

        skeletons.forEach {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [backgroundColor, highlightColor, backgroundColor]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.frame = UIScreen.main.bounds
            gradientLayer.name = skeletonGradientName
        
            $0.layer.mask = skeletonLayer
            $0.layer.addSublayer(skeletonLayer)
            $0.layer.addSublayer(gradientLayer)
            $0.clipsToBounds = true
            self.view.isUserInteractionEnabled = false //Tiro a interação do usuário quando está carregado
            let widht = UIScreen.main.bounds.width
            
            gradientLayer.superlayer?.masksToBounds = true
            gradientLayer.superlayer?.cornerRadius = 5
            
            let animation = CABasicAnimation(keyPath: "transform.translation.x")
            animation.duration = 3
            animation.fromValue = -widht
            animation.toValue = widht
            animation.repeatCount = .infinity
            animation.autoreverses = false
            animation.fillMode = CAMediaTimingFillMode.forwards

            gradientLayer.add(animation, forKey: "gradientLayerShimmerAnimation")
        }
      }
    }

    func hideSkeleton() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){ [self] in
            skeletonViews(in: self.view).forEach {
                self.view.isUserInteractionEnabled = true
                $0.layer.sublayers?.removeAll {
                    $0.name == skeletonLayerName || $0.name == skeletonGradientName
                }
            }
        }
        
    }
}

