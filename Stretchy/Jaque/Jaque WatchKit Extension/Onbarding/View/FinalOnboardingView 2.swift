//
//  FinalOnboardingView.swift
//  Jaque WatchKit Extension
//
//  Created by Filipe Lopes on 28/06/20.
//  Copyright © 2020 Lelio Jorge Junior. All rights reserved.
//

import Foundation
import WatchKit

/**
Classe que apresenta a informação da última tela do Onboarding na tela
## Exemplo de instância de FinalOnboardingView
Primeiro *exemplo*:
+ Abaixo:
1. Essa classe não tem init.
---
let finalOnboardingView = FinalOnboardingView()
---
*/
class FinalOnboardingView: WKInterfaceController{
    
    ///Botão da cena que dará dismiss e chamará a atividade
    @IBOutlet weak var heartButton: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.heartButton.setBackgroundImage(UIImage(named: "Coracao"))
        
    }
    
    /**
     Clique do botão para sair do tutorial
     */
    @IBAction func clickButton() {
        self.dismiss()
    }
}
