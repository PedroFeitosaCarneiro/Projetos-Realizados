//
//  OnboardingPageControl.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 26/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

/// Custom Page coontrol para o onboarding
class OnboardingPageControl: UIImageView {


    
    /// Enum com nome das imagens referente a cada estado
    private enum IndicatorImages:String{
        case selected1 = "selected1"
        case selected2 = "selected2"
        case selected3 = "selected3"
        case selected4 = "selected4"
    }
    
    
    
    init() {
        super.init(image: UIImage(named: "pageControl"))
        setup()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Método para configurar o page control
    private func setup(){
      
        self.image = UIImage(named: "pageControl")
        
    }
    
    
    /// método para settar o estado do page Control
    /// - Parameter index: index que deve ser selecionado
    func setSelected(at index: Int){
        switch index {
        case 0:
            self.image = UIImage(named: IndicatorImages.selected1.rawValue)
        case 1:
            self.image = UIImage(named: IndicatorImages.selected2.rawValue)
        case 2:
            self.image = UIImage(named: IndicatorImages.selected3.rawValue)
        case 3:
            self.image = UIImage(named: IndicatorImages.selected4.rawValue)
        default:
            return
        }
        
    }
   

}
