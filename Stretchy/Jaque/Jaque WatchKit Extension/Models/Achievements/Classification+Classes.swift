//
//  Classification+Classes.swift
//  Jaque WatchKit Extension
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 18/06/20.
//  Copyright © 2020 Lelio Jorge Junior. All rights reserved.
//

import Foundation

/**
Protocolo responsável pela conformidade do tipo das atividades classificáveis
*/
protocol Classifiable {
    /// variável responsável por armazenar a quantidade de atividade feita.
    var value: Double {get}
    /**
     Método responsável por retornar um texto da quantidade de atividades feitas.
     */
    func returnMessage() -> String
}

/**
 Estrutura responsável por lidar com os valores classificáveis da conquista de subir escadarias.
 */
struct ClassifyFlights : Classifiable {
    /// variável responsável por armazenar a quantidade de atividade feita.
    var value: Double
    /**
     Método responsável por retornar um texto da quantidade de atividades feitas.
     */
    func returnMessage() -> String {
        
        let valueString = "\(Int(value))"
        
        return String(format: NSLocalizedString("a_Stair", comment: ""),valueString)
    }
}

/**
Estrutura responsável por lidar com os valores classificáveis da conquista de ficar "X" tempo em pé.
*/
struct ClassifyStand : Classifiable {
    /// variável responsável por armazenar a quantidade de atividade feita.
    var value: Double
    /**
     Método responsável por retornar um texto da quantidade de atividades feitas.
     */
    func returnMessage() -> String {
        
        let valueString = "\(Int(value))"
        
        return String(format: NSLocalizedString("a_Stand", comment: ""),valueString)
    }
    
}

/**
Estrutura responsável por lidar com os valores classificáveis da conquista de caminhar.
*/
struct ClassifyWalk : Classifiable {
    /// variável responsável por armazenar a quantidade de atividade feita.
    var value: Double
    /**
     Método responsável por retornar um texto da quantidade de atividades feitas.
     */
    func returnMessage() -> String {
        
        let valueString = "\(Int(value))"
        
        return String(format: NSLocalizedString("a_Walk", comment: ""),valueString)
    }
}

