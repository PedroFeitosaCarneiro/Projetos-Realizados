//
//  RecomecaInterfaceController.swift
//  Jaque WatchKit Extension
//
//  Created by Lelio Jorge Junior on 22/06/20.
//  Copyright © 2020 Lelio Jorge Junior. All rights reserved.
//

import Foundation
import WatchKit

class RestartInterfaceController: WKInterfaceController{
   
    @IBOutlet weak var restartButton: WKInterfaceButton!
    @IBOutlet weak var titleView: WKInterfaceLabel!
    @IBOutlet weak var messageView: WKInterfaceLabel!
    private let restartViewModel = RestartViewModel()
    
    override func awake(withContext context: Any?) {
        self.setTitle("")
        let message = restartViewModel.formattedMessage()
        titleView.setText(message.title)
        messageView.setText(message.message)
        restartButton.setTitle(NSLocalizedString("r_Restart", comment: ""))
        restartButton.setBackgroundColor(UIColor(red: 240/255, green: 46/255, blue: 86/255, alpha: 1))
        
    }
    @IBAction func restart() {
            let UD = UserDefault()
            UD.userDefault.set(10, forKey: "mascotState")
            UD.userDefault.set(0, forKey: "handStretch")
            UD.userDefault.set(0, forKey: "armStretch")
            UD.userDefault.set(0, forKey: "neckStretch")
        
            let indentifierMascot = "MascotinterfaceController"
        WKInterfaceController.reloadRootControllers(withNamesAndContexts: [(name: indentifierMascot, context: Activitie.walking as AnyObject)])
    }
}
