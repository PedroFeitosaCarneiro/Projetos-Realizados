//
//  InterfaceController.swift
//  Jaque WatchKit Extension
//
//  Created by Lelio Jorge Junior on 15/06/20.
//  Copyright © 2020 Lelio Jorge Junior. All rights reserved.
//

import WatchKit



/**
 
 Classe View cards, responsável por apresentar ao usuário os dados dos cads.
 
 
 # CardInterfaceController
 ## Exemplo de instância de CardInterfaceController
 Primeiro *exemplo*:
 + Abaixo:
 1. Essa classe não tem init.
 ---
 let interfaceController = CardInterfaceController()
 ---
 
 
 */
class CardInterfaceController: WKInterfaceController {
    
    /// ButtonView confirmar.
    @IBOutlet weak var acceptButtonView: WKInterfaceButton!
    /// LabelView para o título do card.
    @IBOutlet weak var titleCardView: WKInterfaceLabel!
    /// ImageView para a imagem do card.
    @IBOutlet weak var imageCardView: WKInterfaceImage!
    /// Card que vai ser apresentado pela CardInterfaceController.
    private var card: Card!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.setTitle(NSLocalizedString("activities", comment: ""))
        
        self.card = context as? Card
        
        let titleButton = card.action
        acceptButtonView.setTitle(titleButton.text)
        var attrStr = NSAttributedString(string: titleButton.text, attributes:
            [NSAttributedString.Key.font: titleButton.font,
             NSAttributedString.Key.foregroundColor: UIColor.white])
        
        acceptButtonView.setAttributedTitle(attrStr)
        
        attrStr = NSAttributedString(string: card.title.text, attributes:
            [NSAttributedString.Key.font: card.title.font])
        
        titleCardView.setAttributedText(attrStr)
        titleCardView.setTextColor(card.title.color)
        
        imageCardView.setImageNamed(card.image)
        if card.activity == Activitie.noActivitie{
            acceptButtonView.setBackgroundColor(UIColor(red: 240/255, green: 46/255, blue: 86/255, alpha: 1))
        }
        
    }
    
    // Setup localized strings
    func setupLabels(){
        acceptButtonView.setTitle(NSLocalizedString("confirmButton", comment: ""))
    }
    
    override func willActivate() {
        imageCardView.startAnimatingWithImages(in: NSRange(location: 1, length: card.numberFrame), duration: TimeInterval(card.timeAction), repeatCount: .max)
    }
    
    /**
     Este método chamara a home do personagem e passará a atividade que o personagem vai fazer.
     - parameter Void: Void
     - Author: Lélio Jorge Júnior
     */
    @IBAction func acceptCard(){
        WKInterfaceController.reloadRootControllers(withNamesAndContexts: [(name: "MascotinterfaceController", context: card.activity as AnyObject)])
    }
}


protocol CardProtocol: class {
    /**
     Manda o exercício escolhido para a tela que implementa esse protocol
     - parameter card: Card
     */
    func chosenCard(_ activitie: Activitie) -> Void
}
