//
//  CustomExploreButton.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 29/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

class CustomExploreButton: UIButton {
    
    let text: String
    let tagNumber: Int
    
    
    override var isSelected: Bool{
        didSet{
            if isSelected{
                self.backgroundColor = ViewColor.ExploreView.CustomButtonBackground.color
            }else{
                self.backgroundColor = .clear
            }
        }
    }
    
    init(frame: CGRect, text: String, tag: Int) {
        self.text = text
        self.tagNumber = tag
        super.init(frame: frame)
        setupButton()
    }
    
    
    private func setupButton(){
        self.isEnabled = true
        self.setTitle(text, for: .normal)
        self.tag = tagNumber
        self.titleLabel?.font = UIFont.init(name: "Coolvetica", size: 18)
        self.titleLabel?.textAlignment = .center
        self.tintColor = ViewColor.ExploreView.CustomButtonTintColor.color
        self.setTitleColor(ViewColor.ExploreView.CustomButtonBackground.color, for: .normal)
        self.setTitleColor(.white, for: .selected)
        self.titleLabel?.minimumScaleFactor = 0.6
        
//        self.layer.cornerRadius = 5
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}




