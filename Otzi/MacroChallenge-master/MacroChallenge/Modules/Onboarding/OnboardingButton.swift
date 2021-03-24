//
//  OnboardingButton.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 26/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

/// Custom button do onboarding
class OnboardingButton: UIButton {


   
    private let text: String
    private let fontSize: CGFloat
    
    /// Init do Onboarding button
    /// - Parameters:
    ///   - text: texto do botão
    ///   - fontSize: tamanho da fonte do botão
    init(text: String, fontSize: CGFloat) {
        self.text = text
        self.fontSize = fontSize
        super.init(frame: .zero)
        self.setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Método para configurar o botão
    private func setupButton(){
        
        
        let titleColor = UIColor(red: 124/255, green: 123/255, blue: 122/255, alpha: 1.0)
        self.setTitleColor(titleColor, for: .normal)
        self.setTitle(text, for: .normal)
        self.titleLabel?.font = UIFont.init(name: "Coolvetica", size: fontSize)
        
        
        self.backgroundColor = .white
    }
    
    
    /// Mudar a lógica de acordo com o estado do botão
    override var isEnabled: Bool{
        didSet{
            if isEnabled{
                self.alpha = 1.0
            }else{
                self.alpha = 0.5
            }
        }
    }
    
}
