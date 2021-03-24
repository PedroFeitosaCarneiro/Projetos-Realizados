//
//  Achievements.swift
//  Jaque WatchKit Extension
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 15/06/20.
//  Copyright © 2020 Lelio Jorge Junior. All rights reserved.
//

import SpriteKit

/**
 Conquistas
 */
struct Achievements {
    /// Mensagem da conquista.
    let message : String
    /// Tipo do Achievement.
    let type : AchievementsType
}

/**
 Tipo de conquistas
    - walk: Conquistas referentes a atividade de caminhada.
    - flights: Conquistas referentes a atividade de subir escadas.
    - stand: Conquistas referentes a atividade de ficar de pé.
    - handStretch: Conquistas referentes a atividade de alongar as mãos.
    - neckStretch: Conquistas referentes a atividade de alongar o pescoço.
    - armStretch: Conquistas referentes a atividade de alongar os braços.
 
 */
enum AchievementsType {
    /// Conquistas referentes a atividade de caminhada.
    case walk
    /// Conquistas referentes a atividade de subir escadas.
    case flights
    /// Conquistas referentes a atividade de ficar de pé.
    case stand
    /// Conquistas referentes a atividade de alongar as mãos.
    case handStretch
    /// Conquistas referentes a atividade de alongar o pescoço.
    case neckStretch
    /// Conquistas referentes a atividade de alongar os braços.
    case armStretch
}

