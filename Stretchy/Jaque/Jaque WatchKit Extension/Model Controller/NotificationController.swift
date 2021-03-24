//
//  NotificationController.swift
//  Jaque WatchKit Extension
//
//  Created by Lelio Jorge Junior on 10/06/20.
//  Copyright © 2020 Lelio Jorge Junior. All rights reserved.
//

import WatchKit
import Foundation
import UserNotifications

//Controller da notificacao de mascote
class NotificationController: WKUserNotificationInterfaceController{

    ///Titulo da notificação
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    
    ///Imagem para ser animada
    @IBOutlet weak var img: WKInterfaceImage!
//    private lazy var exerciseController: ExerciseController = ExerciseController()
    override init() {
        super.init()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func didReceive(_ notification: UNNotification) {
                
        let arrayImg = [UIImage(systemName: "pencil")!,UIImage(systemName: "pencil.circle")!,UIImage(systemName: "pencil.slash")!,UIImage(systemName: "pencil.circle.fill")!]
        
        let animation = UIImage.animatedImage(with: arrayImg, duration: 1)
        self.img.setImage(animation)
        self.img.startAnimating()
        self.titleLabel.setText(notification.request.content.title)
        
//        exerciseController.presentController()
    }
}
