//
//  AutoLayout.swift
//  quarto-mini-challenge
//
//  Created by Antonio Carlos on 14/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import UIKit

public struct AutoLayout {
    
    //MARK: - iPhone Devices
    public static let iphone8proportion: CGFloat = 1.77
    public static let iphoneXproportion: CGFloat = 2.16    
    
    //MARK: - iPad Devices
    public static let ipadProportion: CGFloat = 1.33
    
    public static func getDeviceNameBasedOnProportion(viewSize: CGSize) -> String {
        
        var proportion: CGFloat = 0.0
        
        if(viewSize.width < viewSize.height) {
            proportion = (CGFloat(Int((viewSize.height/viewSize.width)*100)))/100
        } else {
            proportion = (CGFloat(Int((viewSize.width/viewSize.height)*100)))/100
        }
        switch proportion {
            case iphone8proportion:
                return "iphone8"
            case iphoneXproportion:
                return "iphoneX"
            case ipadProportion:
                return "ipad"
            default:
                return ""
        }
    }
}
