//
//  Mascot.swift
//  Jaque WatchKit Extension
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 15/06/20.
//  Copyright © 2020 Lelio Jorge Junior. All rights reserved.
//

import SpriteKit

/**
 Classe que define o modelo mascote, personagem principal que aparecerá na tela e irá interagir com o usuário.
 */
class Mascot {
    ///SpiteNode do mascote para coloc-lo em cena
    private(set) var spriteNode : SKSpriteNode
    ///Estado do mascote, parte da gamificação, e o que vai definir os sprites do mascote - seus estados são (Feliz, normal, mal e morto)
    var behave : MascotState
    ///Numero que define as nuancias entre os estados, vai de 0 a 9, sendo 0 morto e 3 numeros para os demais estados.
    var behaviorNumber: Int
    
    //Construtor - Cria um mascote de acordo com uma sprite e inicializa ele feliz. 
    init(sprite: SKSpriteNode) {
        self.behave = .happy
        self.spriteNode = sprite
        self.behaviorNumber = 9
    }
}
