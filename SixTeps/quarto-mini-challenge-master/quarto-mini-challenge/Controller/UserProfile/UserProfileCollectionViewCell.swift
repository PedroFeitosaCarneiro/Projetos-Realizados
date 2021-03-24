//
//  UserProfileCollectionViewCell.swift
//  quarto-mini-challenge
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 08/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import UIKit

class UserProfileCollectionViewCell: UICollectionViewCell {
    
    var lockerImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout(deviceName: String){
        lockerImage = UIImageView(image: UIImage(named: "locker\(deviceName)"))
        lockerImage.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(lockerImage)
        lockerImage.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        lockerImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        
        contentView.backgroundColor = UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1)
        contentView.layer.cornerRadius = 30
        
    }
    
    
}
