//
//  Transitions.swift
//  MacroChallenge
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 02/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    
    
    /// Método responsável por fazer a transição fading.
    /// - Parameter viewControllerToPresent: ViewController a ser apresentada
    func pushDownFading(_ viewControllerToPresent: UIViewController){
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromBottom
        self.view.window!.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(viewControllerToPresent, animated: false)
    }
  
    /// Método responsável por fazer a transição fading.
    /// - Parameter viewControllerToPresent: ViewController a ser apresentada
    func presentDownFading(_ viewControllerToPresent: UIViewController){
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromBottom
        
        if let layer  = self.view.window?.layer{
            layer.add(transition, forKey: kCATransition)
        }
        
        navigationController?.pushViewController(viewControllerToPresent, animated: false)
        
        
        
        }
       
    }
    
    
