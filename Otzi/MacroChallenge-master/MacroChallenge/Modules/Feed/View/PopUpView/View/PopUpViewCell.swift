//
//  PopUpViewCell.swift
//  MacroChallenge
//
//  Created by Lelio Jorge Junior on 24/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

/// PopUpViewCell objeto gerenciado pela collection da PopUpView.
class PopUpViewCell: UICollectionViewCell {
    
    lazy var hashtagLabelView: UILabel = {
        let  label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        label.textAlignment = .center
        label.textColor = .white
        label.font.withSize(12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}

extension PopUpViewCell: ViewCoding {
    
    func buildViewHierarchy() {
        
        self.addSubview(hashtagLabelView)
    
    }
    
    func setupConstraints() {
        
        self.hashtagLabelView.translatesAutoresizingMaskIntoConstraints = false
        
        self.hashtagLabelView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.hashtagLabelView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.hashtagLabelView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.hashtagLabelView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

    }
    
   func setupView() {
    
    self.layer.cornerRadius = 5
    self.backgroundColor = UIColor(red: 196/255, green: 195/255, blue: 195/255, alpha: 1)

    buildViewHierarchy()
    setupConstraints()
    }
}
