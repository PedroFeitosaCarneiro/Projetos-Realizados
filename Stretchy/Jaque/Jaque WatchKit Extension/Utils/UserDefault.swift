//
//  UserDefault.swift
//  Jaque WatchKit Extension
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 18/06/20.
//  Copyright © 2020 Lelio Jorge Junior. All rights reserved.
//

import Foundation

/**
 Classe responsável por armazenar uma referência do UserDefault
 
 */
class UserDefault {
    /// Método que armazena uma instancia do UserDefaults
    let userDefault : UserDefaults
    /**
     Inicializador padrão para atribuir uma referência ao UserDefaults
     */
    init() {
        userDefault = UserDefaults.standard
    }
}
