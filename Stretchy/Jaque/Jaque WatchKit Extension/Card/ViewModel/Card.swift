//
//  Card.swift
//  Jaque WatchKit Extension
//
//  Created by Lelio Jorge Junior on 15/06/20.
//  Copyright © 2020 Lelio Jorge Junior. All rights reserved.
//


import WatchKit


struct Card{
    /// Título dos cards.
    var title: Title
    /// Imagem dos cards.
    var image: String
    /// Ações feita pelo card, a dado desse atributo vai direto para title button.
    var action: Title
    /// Atividade.
    var activity: Activitie?
    /// Numero de Frames.
    var numberFrame: Int
    /// Temopo de animação
    var timeAction: Double
}

struct Title {
    /// Texto dos card
    var text: String
    /// Cor do texto dos card
    var color: UIColor
    /// Fonte do título.
    var font: UIFont
}
 

