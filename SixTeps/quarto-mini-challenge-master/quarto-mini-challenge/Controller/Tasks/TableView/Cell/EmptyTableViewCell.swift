//
//  EmptyTableViewCell.swift
//  quarto-mini-challenge
//
//  Created by Bernardo Nunes on 13/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {
    
//    @IBOutlet weak var topConstraint: NSLayoutConstraint!
//    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var borderImgView: UIImageView!
    @IBOutlet weak var addTaskLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
    public func setLayout(cellSpacingHeight: CGFloat, deviceName: String) {
        if deviceName == "iphone8" {
            self.addTaskLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        }
        
        self.setConstraintsBorderImgView(cellSpacingHeight: cellSpacingHeight)
        
        self.addTaskLbl.translatesAutoresizingMaskIntoConstraints = false
        self.addTaskLbl.centerYAnchor.constraint(equalTo: self.borderImgView.centerYAnchor).isActive = true
        self.addTaskLbl.centerXAnchor.constraint(equalTo: self.borderImgView.centerXAnchor).isActive = true
    }
    
    private func setConstraintsBorderImgView(cellSpacingHeight: CGFloat) {
        self.borderImgView.translatesAutoresizingMaskIntoConstraints = false
        self.borderImgView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.borderImgView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.borderImgView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: cellSpacingHeight/2).isActive = true
        self.borderImgView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: cellSpacingHeight/2).isActive = true
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
