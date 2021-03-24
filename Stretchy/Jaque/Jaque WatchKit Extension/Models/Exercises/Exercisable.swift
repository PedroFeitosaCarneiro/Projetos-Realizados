//
//  Exercices.swift
//  Jaque WatchKit Extension
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 15/06/20.
//  Copyright © 2020 Lelio Jorge Junior. All rights reserved.
//

import WatchKit
import SpriteKit

/**
 Protocolo responsável pela conformidade do tipo do exercício
 
 */
protocol Exercisable {
    // Variável responsável por armazenar a imagem/icone da atividade
    var image: WKImage {get}
    // Variável responsável por armazenar o o nome da atividade.
    var name: String {get}
    
    /**
     Função abstrata de como realizar a animação do exercício.
     */
    func performExercise() -> SKAction
}

extension Exercisable{
    func performExercise() -> SKAction{
        return SKAction()
    }
}
