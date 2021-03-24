//
//  ViewColors.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 29/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit




/// Enum para as cores do app
enum ViewColor {
    
    enum ExploreView{
        case CustomButtonBackground
        case CustomButtonTintColor
        case BackgroundSelectedCell
        case BackgroundCell
        
        var color: UIColor{
            
            switch self {
            case .CustomButtonBackground:
                return UIColor(red: 172/255, green: 172/255, blue: 172/255, alpha: 1.0)//
            case .CustomButtonTintColor:
                return UIColor(red: 101/255, green: 101/255, blue: 101/255, alpha: 1.0)
            case .BackgroundSelectedCell:
                return UIColor(red: 101/255, green: 101/255, blue: 101/255, alpha: 1.0)//(red: 206/255, green:  206/255, blue:  206/255, alpha: 1.0)//rgba(206, 206, 206, 1)
            case .BackgroundCell:
                return UIColor(red: 101/255, green: 101/255, blue: 101/255, alpha: 0.6)//UIColor(red: 206/255, green:  206/255, blue:  206/255, alpha: 0.7)
            }
            
        }
        
    }
    
    enum FeedView{
        case NavigationTitle
        case NavigationBackButton
        var color: UIColor{
            
            switch self {
            case .NavigationTitle:
                return UIColor(red: 101/255, green: 101/255, blue: 101/255, alpha: 1.0)
            case .NavigationBackButton:
                return UIColor(red: 101/255, green: 101/255, blue: 101/255, alpha: 1.0)//(red: 206/255, green:  206/255, blue:  206/255, alpha: 1.0)//rgba(206, 206, 206, 1)
            }
            
        }
    }
    
    
}

