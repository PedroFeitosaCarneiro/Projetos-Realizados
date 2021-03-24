//
//  RestartViewModel.swift
//  Jaque WatchKit Extension
//
//  Created by Lelio Jorge Junior on 22/06/20.
//  Copyright © 2020 Lelio Jorge Junior. All rights reserved.
//

import Foundation

class RestartViewModel {
    private let messageData = MessageData()
    
    func formattedMessage() -> MessageRestart{
        return MessageRestart(title: messageData.title, message: messageData.message)
    }
}
