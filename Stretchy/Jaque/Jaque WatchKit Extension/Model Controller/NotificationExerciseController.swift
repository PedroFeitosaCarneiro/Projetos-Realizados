//
//  NotificationExerciseController.swift
//  Jaque WatchKit Extension
//
//  Created by Aline Gomes on 19/06/20.
//  Copyright © 2020 Lelio Jorge Junior. All rights reserved.
//

import WatchKit
import Foundation
import UserNotifications

///Controller da notificacao de alongamento
class NotificationExerciseController: WKUserNotificationInterfaceController, UNUserNotificationCenterDelegate  {
    
    ///Titulo da notificação
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    
    ///Subtitulo
    @IBOutlet weak var subtitleLabel: WKInterfaceLabel!
    
    ///Imagem para ser animada
    @IBOutlet weak var img: WKInterfaceImage!
    
    override init() {
        // Initialize variables here.
        super.init()
        UNUserNotificationCenter.current().delegate = self
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    override func didReceive(_ notification: UNNotification, withCompletion completionHandler: @escaping (WKUserNotificationInterfaceType) -> Swift.Void) {
        
        if let titleLabel = self.titleLabel {
            titleLabel.setText(notification.request.content.title)
        }
        if let subtitleLabel = self.subtitleLabel {
            subtitleLabel.setText(notification.request.content.body)
        }
        
        let arrayImg = [UIImage(named: "status_feliz_01")!,UIImage(named: "status_feliz_02")!,UIImage(named: "status_feliz_03")!,UIImage(named: "status_feliz_04")!,UIImage(named: "status_feliz_05")!,UIImage(named: "status_feliz_06")!,UIImage(named: "status_feliz_07")!]
        let animation = UIImage.animatedImage(with: arrayImg, duration: 0.8)
        if let img = self.img {
            img.setImage(animation)
            img.startAnimating()
        }
        
        completionHandler(.custom)
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            let state = UserDefaults.standard.integer(forKey: "mascotState")
            UserDefaults.standard.set( state > 0 ? state - 1 : 0, forKey: "mascotState")
            ComplicationController.updateComplication()
        case "YES":
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cardNotification") , object: nil, userInfo: response.notification.request.content.userInfo)
           
        case "NO_SEND_ME_IN_10m":
            LocalNotification.scheduleDefaultNotification(hour: nil, minute: nil, date: Date(timeIntervalSinceNow: 600), notificationType: NotificationType.exercise)
        default:
            break
        }
        
        completionHandler()
    }
    
}
