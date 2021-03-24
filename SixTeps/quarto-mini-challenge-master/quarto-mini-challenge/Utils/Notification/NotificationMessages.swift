//
//  NotificationMessages.swift
//  quarto-mini-challenge
//
//  Created by Guilherme Martins Dalosto de Oliveira on 11/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation

struct NotificationMessages{
    private var titlesMessages = ["Hora das Tarefas"]
    private var titlesMessagesEN = ["Task Time"]
    private var subtitlesMessages = [""]
    private var bodyMessagesEN = ["Have you finished your tasks today?","Remember to create your tasks","Have you planned all of your tomorrow tasks?","Have you planned all of your today tasks?"]
    private var bodyMessages = ["Você já realizou suas tarefas hoje?","Lembre-se de criar suas tarefas","Você já concluiu todas suas tarefas de hoje?","Você já planejou suas tarefas de amanhã?","Você já planejou suas tarefas de hoje?"]
    
    func getTitle() -> String{
        if !(UserDefaultLogic().isEnglish){
            return self.titlesMessages.randomElement()!
        }
            return self.titlesMessagesEN.randomElement()!
    }
    
    func getBody() -> String{
        if !(UserDefaultLogic().isEnglish){
            return self.bodyMessages.randomElement()!
        }
            return self.bodyMessagesEN.randomElement()!        
        
    }
    
    func getSubtitle() -> String{ return self.subtitlesMessages.randomElement()! }
    
    func getSchedule() -> Double{ return Double.random(in: 0...2)}
    
}
