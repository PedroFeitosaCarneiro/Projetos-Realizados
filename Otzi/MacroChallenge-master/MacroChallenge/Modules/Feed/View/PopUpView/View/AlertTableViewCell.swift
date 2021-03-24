//
//  TableViewCell.swift
//  MacroChallenge
//
//  Created by Lelio Jorge Junior on 21/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

class AlertTableViewCell: UITableViewCell {
    
    private lazy var labelView: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
        label.textAlignment = .center
        label.text = " "
        label.font = UIFont(name: "SourceSansPro-Regular", size: 18)
        label.textColor = UIColor.init(red: 101/255, green: 101/255, blue: 101/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label 
    }()
    
    var folderName: String? {
        didSet {
            labelView.text = folderName!
            setupView()
        }
    }
    
}

extension AlertTableViewCell: ViewCoding {

    func buildViewHierarchy() {
        self.addSubview(labelView)
    }

    func setupConstraints() {
        
        labelView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        labelView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        labelView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        labelView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
    }
    
    func setupAdditionalConfiguration() {
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
    }

}
