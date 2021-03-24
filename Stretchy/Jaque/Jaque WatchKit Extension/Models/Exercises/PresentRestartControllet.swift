//
//  PresentRestartControllet.swift
//  Jaque WatchKit Extension
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 22/06/20.
//  Copyright © 2020 Lelio Jorge Junior. All rights reserved.
//

import Foundation
import WatchKit

class PresentRestartController : WKInterfaceController{
    
    func presentRestart(){
        presentController(withName: "restart", context: nil)
    }
    
}
