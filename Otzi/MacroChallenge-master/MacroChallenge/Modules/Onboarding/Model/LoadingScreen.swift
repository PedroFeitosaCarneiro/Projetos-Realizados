//
//  LoadingScreen.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 27/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

/// Tela de load screen
class LoadingScreen: UIView {
    var label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()

        
        
//           let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
//           label.textAlignment = .center
//           label.numberOfLines = 2
//           label.isHidden = false
//           label.font = UIFont.init(name: "Coolvetica", size: 45)
//           label.minimumScaleFactor = 0.5
//           label.sizeToFit()
//           label.adjustsFontSizeToFitWidth = true
//           label.textColor = .black
//           label.text = "One moment, we are preparing all for u! :D"
//           label.center = CGPoint(x: self.center.x, y: self.center.y - 100)
//           activityIndicator.center = self.center
//
//        self.addSubview(label)
//        
//        label.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([label.heightAnchor.constraint(equalToConstant: 60),
//                                     label.widthAnchor.constraint(equalToConstant: 300),
//                                     label.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 30),
//                                     label.centerXAnchor.constraint(equalTo: self.centerXAnchor)])
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
