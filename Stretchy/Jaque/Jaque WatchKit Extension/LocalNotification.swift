//
//  LocalNotification.swift
//  Jaque WatchKit Extension
//
//  Created by Aline Gomes on 17/06/20.
//  Copyright © 2020 Lelio Jorge Junior. All rights reserved.
//

import WatchKit
import UserNotifications

///Class that manages the sendin of local notifications
class LocalNotification {
    
    ///Singleton that manages the notification center
    static let notification = UNUserNotificationCenter.current()
    
    ///Send a default notification
    /// - Parameters:
    ///   - hour: Date hour of the notification
    ///   - minute: Date minute of the notification, default is 0
    ///   - date: Date
    ///   - notificationType: Tye of notification
    public static func scheduleDefaultNotification(hour: Int?, minute: Int?, date: Date?, notificationType: NotificationType) {
                
        let content = UNMutableNotificationContent()
        
        let notificationData = Notification(type: notificationType)
        
        content.title = notificationData.title ?? ""
        content.body = notificationData.body ?? ""
        
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = notificationType == NotificationType.mascotState ? "mascotState" : "exercise"
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        
        if let date = date{
            dateComponents = Calendar.current.dateComponents([.hour,.minute,.month,.day,.year], from: date)
        }else{
            
            dateComponents.hour = hour
            dateComponents.minute = minute
            
        }

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: content.categoryIdentifier, content: content, trigger: trigger)
        
        notification.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    /**
    Create a mascot category with no actions
     - returns: mascot category
     */
    static func registerMascotCategory() -> UNNotificationCategory {
        
        
        let category = UNNotificationCategory(identifier: "mascotState", actions: [], intentIdentifiers: [], options: .customDismissAction)
        
        return category
        
    }
    
    /**
    Create a exercise category with no actions
     - returns: exercise category
     */
    static func registerExerciseCategory() -> UNNotificationCategory {
        
        let yesAction = UNNotificationAction(identifier: "YES", title: NSLocalizedString("n_Open", comment: ""), options: .foreground)
        
        let noSendMeIn10Action = UNNotificationAction(identifier: "NO_SEND_ME_IN_10m",title: NSLocalizedString("n_NotNow", comment: ""), options: .destructive)
        
        let category = UNNotificationCategory(identifier: "exercise", actions: [yesAction, noSendMeIn10Action], intentIdentifiers: [], options: .customDismissAction)
        
        return category
        
    }
    
}
