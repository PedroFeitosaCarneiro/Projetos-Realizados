//
//  AchievementsInterfaceController.swift
//  Jaque WatchKit Extension
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 30/06/20.
//  Copyright © 2020 Lelio Jorge Junior. All rights reserved.
//

import WatchKit
import Foundation


class AchievementsInterfaceController: WKInterfaceController {

    @IBOutlet weak var textLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.setTitle(NSLocalizedString("back", comment: ""))
        // Configure interface objects here.
        let controller = context as! MascotController
        
        self.textLabel.setText(controller.retrieveAchievements())
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    

}
