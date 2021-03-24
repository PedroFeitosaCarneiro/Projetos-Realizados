//
//  AchievementsController.swift
//  Jaque WatchKit Extension
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 16/06/20.
//  Copyright © 2020 Lelio Jorge Junior. All rights reserved.
//

import Foundation

/**
 Classe responsável por lidar com a conexão com o HealthKitFormatter, e transformar os dados colhidos em informações que serão exibidas na tela.
 */
class AchievementsController {
    /// Variável privada que representa uma fila de atividades.
    private var achievementsQueue : [Achievements] = []
    /// Constante privada que estabelece uma conexão com o HealthKitFormatter.
    private let healthConnection = HealthKitFormatter()
    /// Constante privada que estabelece uma conexão com o UserDefault.
    private let UD = UserDefault()
    
    /**
     Inicializador vazio, que tem apenas como função inicializar a classe e injetar na fila a primeira conquista.
     */
    init() {
        populateQueue { (v) in
        //empty
        }
    }
    /**
     Método responsável por retornar uma conquista da fila de conquistas.(Pode retornar NIL)
     */
    func getAchievement() -> Achievements? {
        if achievementsQueue.isEmpty{
            return nil
        }
        let retrievedAchievement = achievementsQueue[0]
        achievementsQueue.remove(at: 0)
        populateQueue { (s) in
        }
        return retrievedAchievement
    }
    
}

extension AchievementsController {
    
    /**
     Método privado que retorna uma conquista.
     
        - Parameters:
        - type: O tipo da conquista.
        - value: O valor opcional que foi retirado do HealthKit.
     
     */
    private func getMessage(type: AchievementsType,value : Double?) -> Achievements{
        
        var message : String
        switch type {
        case .flights:
            message = ClassifyFlights(value: value!).returnMessage()
            return Achievements(message: message, type: .flights)
        case .stand:
            message = ClassifyStand(value: value!).returnMessage()
            return Achievements(message: message, type: .stand)
        case .walk:
            message = ClassifyWalk(value: value!).returnMessage()
            return Achievements(message: message, type: .walk)
        case .handStretch:
            let handString = "\(UD.userDefault.integer(forKey: "handStretch"))"
            message = String(format: NSLocalizedString("a_Hand", comment: ""),handString)
            return Achievements(message: message, type: .handStretch)
        case .neckStretch:
            let neckString = "\(UD.userDefault.integer(forKey: "neckStretch"))"
            message = String(format: NSLocalizedString("a_Neck", comment: ""), neckString)
            return Achievements(message: message, type: .neckStretch)
        case .armStretch:
            let armString = "\(UD.userDefault.integer(forKey: "armStretch"))"
            message = String(format: NSLocalizedString("a_Arm", comment: ""),armString)
            return Achievements(message: message, type: .armStretch)
        }
    }
    
    /**
     Método privado responsável por popular a fila de Conquistas.
        - Parameters:
        - completion: Um método que representa um callback, ja que a coleta de dados do HealthKit é async.
        - v: é um valor de resposta caso a conexão com o HealthKit tenha sido bem sucedida.
     */
    private func populateQueue (completion: @escaping (_ v : Bool) -> ()){
        
        switch Int.random(in: 0...5) {
        case 0:
            healthConnection.flightsClimbedQuery { (value, type) in
                self.achievementsQueue.append(self.getMessage(type: type, value: value))
                completion(true)
            }
        case 1:
            healthConnection.standTimeQuery { (value, type) in
                self.achievementsQueue.append(self.getMessage(type: type, value: value))
                completion(true)
            }
        case 2:
            healthConnection.stepCountQuery { (value, type) in
                self.achievementsQueue.append(self.getMessage(type: type, value: value))
                completion(true)
            }
        case 3:
            self.achievementsQueue.append(self.getMessage(type: .armStretch, value: nil))
        case 4:
            self.achievementsQueue.append(self.getMessage(type: .handStretch, value: nil))
        case 5:
            self.achievementsQueue.append(self.getMessage(type: .neckStretch, value: nil))
        default:
            print("error")
            completion(false)
        }
        
    }
    
}



