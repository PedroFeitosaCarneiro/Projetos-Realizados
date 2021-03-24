//
//  FavoritesFolderPostsCell.swift
//  MacroChallenge
//
//  Created by Fábio França on 26/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

class FavoritesFolderPostsCell: FeedCell {
    
    lazy var editBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "BotaoFavoritesPostsSelected"), for: .selected)
        btn.setImage(UIImage(named: "BotaoFavoritesFolderDeselected"), for: .normal)
        btn.isEnabled = true
        btn.tintColor = #colorLiteral(red: 0.2431372549, green: 0.2392156863, blue: 0.2392156863, alpha: 1)
        btn.addTarget(self, action: #selector(editBtnWasPressed), for: .touchUpInside)
        btn.isHidden = false
        return btn
    }()
    
    var image: Image!
    var addPostToDelete:((Image)->()) = {_ in}
    var removePostToDelete:((Image)->()) = {_ in}
    
    var widthConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var isEditing = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        showEditMode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showEditMode() {
        self.addSubview(editBtn)

        widthConstraint = editBtn.widthAnchor.constraint(equalToConstant: 0.0)
        widthConstraint?.identifier = "widthBtn"
        widthConstraint?.isActive = true

        leadingConstraint = editBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0)
        leadingConstraint?.identifier = "leadingBtn"
        leadingConstraint?.isActive = true

        NSLayoutConstraint.activate([
            editBtn.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            //editBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    func setupEdit(isEditing: Bool) {
        if isEditing {
            UIView.animate(withDuration: 0.3) {
                self.leadingConstraint?.constant = 5
                self.widthConstraint?.constant = 30
                self.layoutIfNeeded()
            }
        }else{
            self.editBtn.isSelected = false
            self.removePostToDelete(self.image!)
            UIView.animate(withDuration: 0.3) {
                self.leadingConstraint?.constant = 0
                self.widthConstraint?.constant = 0
                self.layoutIfNeeded()
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    @objc func editBtnWasPressed(sender: UIButton!) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.addPostToDelete(self.image!)
        }else {
            self.removePostToDelete(self.image!)
        }
    }
    
    
}
