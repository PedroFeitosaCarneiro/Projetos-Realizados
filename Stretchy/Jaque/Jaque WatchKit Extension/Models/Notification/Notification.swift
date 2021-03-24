//
//  Notification.swift
//  Jaque WatchKit Extension
//
//  Created by Aline Gomes on 17/06/20.
//  Copyright © 2020 Lelio Jorge Junior. All rights reserved.
//

import WatchKit

///Modelo de notificaçao para mandar para o usuário
struct Notification {
    
    ///Titulo da notificação
    var title: String?
    
    ///Corpo da notificação, logo abaixo do titulo
    var body: String?
    
    /// - Parameters:  type: Tipo da notificacao
    init(type: NotificationType) {
        
        switch type {
        case NotificationType.mascotState:
            self.title = NotificationMessagesData.mascotState
        case NotificationType.exercise:
            self.title = NotificationMessagesData.exercise[0]
            self.body = NotificationMessagesData.exercise[1]
        }
        
    }
}

///Banco de todas as mensagens possíveis de serem enviadas por notificação para o usuário
enum NotificationMessagesData{
    
    ///Mensagem que mostra o estado do mascote na notificação
    static let mascotState = NSLocalizedString("n_MascotState", comment: "")
    
    ///Mensagem que chama o usuário pra se alongar, com title e subtitle respectivamente
    static let exercise = [NSLocalizedString("n_Exercise1", comment: ""), NSLocalizedString("n_Exercise2", comment: "")]
}

///Tipo da notificação
enum NotificationType{
    
    ///Tipo mascote
    case mascotState;
    
    ///Tipo alongamento
    case exercise;
}
