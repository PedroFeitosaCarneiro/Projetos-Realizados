//
//  ExplorerSegmentController.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 21/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit


class ExplorerSegmentController: UISegmentedControl {
    
    
    let segmentindicator: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.white
        v.layer.cornerRadius = 5
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    private func setup(){
        
        self.backgroundColor = .white
        self.tintColor = .white
        
//        self.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "AvenirNextCondensed-Medium", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
//        self.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "AvenirNextCondensed-Medium", size: 24)!, NSAttributedString.Key.foregroundColor: UIColor.blue], for: .selected)
        
        
       
        self.selectedSegmentTintColor = ViewColor.ExploreView.CustomButtonBackground.color
      

            let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        self.setTitleTextAttributes(titleTextAttributes, for:.normal)

            let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.setTitleTextAttributes(titleTextAttributes1, for:.selected)
        
    }
}


