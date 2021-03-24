//
//  ViewModel.swift
//  Jaque WatchKit Extension
//
//  Created by Lelio Jorge Junior on 17/06/20.
//  Copyright © 2020 Lelio Jorge Junior. All rights reserved.
//


import WatchKit
/**
 Atividades
 
 - Walking: Caminhar.
 - StretchingNeck: Alongar o pescoço.
 - StretchingHand: Alongar as mãos.
 - stretchingArm: Alongar os braços.
 */
enum Activitie: Int{
    /// Caminhada.
    case walking
    /// Alongamento para o pescoço.
    case stretchingNeck
    /// Alongamento para as mãos.
    case stretchingHand
    /// Alongamento para os braços.
    case stretchingArm
    /// sem atividade pra hoje.
    case noActivitie
}
/**
 
 Classe CardViewModel, responsável trataros dados para serem apresentados.
 
 
 # CardsViewModel
 ## Exemplo de instância de CardViewModel
 Primeiro *exemplo*:
 + Abaixo:
 1. Essa classe não tem init.
 ---
 let viewModel = CardViewModel()
 ---
 
 
 */
class CardsViewModel {
    
    /// Dados dos Cards
    private let cardData = CardData()

    /**
     Este método escolhe quais atividades vão ser mostradas para o usuário.
     - parameter Void: Void
     - Returns: Array de Activitie sem valores iguais.
     - Author: Lélio Jorge Júnior
     */
    private func chooseActivity() -> [Activitie] {
        var activities: [Activitie] = [Activitie]()
        var pick = Int.random(in: 0...self.cardData.activities.count-1)
        activities.append(Activitie(rawValue: pick)!)
        repeat{
            var found = false
            pick = Int.random(in: 0...self.cardData.activities.count-1)
            let a = Activitie.init(rawValue: pick)!
            for activitie in activities{
                if activitie.rawValue == a.rawValue{
                    found = true
                }
            }
            if !found {
                activities.append(a)
            }
        }while(activities.count < 3)
        return activities
    }
    
    /**
     Este método pega as atividades que foi escolhidas e formata elas em cards.
     - parameter Void: Void
     - Returns: Array de Card sem valores iguais e formatados.
     - Author: Lélio Jorge Júnior
     */
    public func formattedCard() -> [Card] {
        var card: Card
        var cards: [Card] = [Card]()
        let fontSize = CGFloat(15)
        let font = UIFont(name: "SF Compact Text", size: fontSize)!
        
        let activities = chooseActivity()
        let textAction = NSLocalizedString("confirmButton", comment: "")
        let colorAction: UIColor = .white
        var titleAction = Title(text: textAction, color: colorAction, font: font)
        
        for activitie in activities{
            
            let text = self.cardData.activities[activitie.rawValue]
            let color: UIColor = .white
            let title = Title(text: text, color: color,font: font)
            let image = self.cardData.keyImages[activitie.rawValue]
            let timeAction = self.cardData.timeOfAnimation[activitie.rawValue]
            card = Card(title: title, image: image , action: titleAction, activity: activitie, numberFrame: self.cardData.numberOfFrames[activitie.rawValue], timeAction: timeAction)
            cards.append(card)
        }
        
        titleAction.text = NSLocalizedString("cancelButton", comment: "")
        let finalCard = Card(title: Title(text: NSLocalizedString("notNow", comment: ""), color: .white,font: font), image: "naoAlongar", action: titleAction, activity: .noActivitie, numberFrame: 9, timeAction: 1)
        cards.append(finalCard)
        return cards
    }
    
    
}
