//
//  UIImageExtension.swift
//  IvyLeeStudy
//
//  Created by Antonio Carlos on 19/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import UIKit

extension UIImage {
    
    public func translucentImage(withAlpha alpha: CGFloat) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        let bounds = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.draw(in: bounds, blendMode: .screen, alpha: alpha)
        
        let translucentImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return translucentImage!
    }
    
}

