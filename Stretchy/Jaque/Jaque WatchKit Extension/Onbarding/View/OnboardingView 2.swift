//
//  OnboardingView.swift
//  Jaque WatchKit Extension
//
//  Created by Filipe Lopes on 28/06/20.
//  Copyright © 2020 Lelio Jorge Junior. All rights reserved.
//

import Foundation
import WatchKit
import SpriteKit

/**
 Classe que apresenta a informação do Onboarding na tela
 ## Exemplo de instância de OnboardingView
 Primeiro *exemplo*:
 + Abaixo:
 1. Essa classe não tem init.
 ---
 let onboardingView = OnboardingView()
 ---
 */

class OnboardingView: WKInterfaceController{
    
    ///Label que armazena a frase do tutorial
    @IBOutlet weak var onboardingPhase: WKInterfaceLabel!
    ///Cena que aparece o mascorte animado
    @IBOutlet weak var onboardingScene: WKInterfaceSKScene!
    ///View Model do onboarding
    private let onboardigViewModel = OnboardingViewModel()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.setTitle("Tutorial")
        
        let view = onboardigViewModel.getView()
        
        self.onboardingPhase.setText(view.onboardingPhrase)
        
        let scene = OnbardingScene(size: CGSize(width: 400, height: 175))
        
        self.onboardingScene.presentScene(scene)
        
    }
}


