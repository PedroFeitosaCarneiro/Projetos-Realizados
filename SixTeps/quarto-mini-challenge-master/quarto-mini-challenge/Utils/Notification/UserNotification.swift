//
//  UserNotification.swift
//  quarto-mini-challenge
//
//  Created by Guilherme Martins Dalosto de Oliveira on 08/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation
import UserNotifications

class UserNotification{        
    func notificationTask(_ titulo : String,_ subtitulo : String, _ corpo : String,tempo: Double){
        
        let content = UNMutableNotificationContent()
        
        content.title = titulo
        content.subtitle = subtitulo
        content.body = corpo
        content.badge = 1
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        // Seta as horas aqui como preferir
        let dateComponents = DateComponents(calendar: calendar,hour: 20, minute: 00)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request =  UNNotificationRequest(identifier: "Task", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
}
