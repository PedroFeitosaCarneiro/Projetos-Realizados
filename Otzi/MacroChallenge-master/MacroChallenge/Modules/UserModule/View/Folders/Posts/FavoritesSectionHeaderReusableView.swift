//
//  FavoritesSectionHeaderReusableView.swift
//  MacroChallenge
//
//  Created by Fábio França on 23/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit

class FavoritesSectionHeaderReusableView: UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: FavoritesSectionHeaderReusableView.self)
    }
    
    var presenter: UserFavoritesPresenterToView?
    var widthConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.init(name: "Coolvetica", size: 18)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(
            .defaultHigh,
            for: .horizontal)
        return label
    }()
    
    lazy var searchButton: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.init(name: "Helvetica", size: 15)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(
            .defaultHigh,
            for: .horizontal)
        label.text = "See more"
        return label
    }()
    
    var folder: Folder?
    
    var addFolderToDelete:((Folder)->()) = {_ in}
    var removeFolderToDelete:((Folder)->()) = {_ in}
    
    lazy var editBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.setTitle("", for: .normal)
//        btn.setTitle("D", for: .selected)
        
        btn.setImage(UIImage(named: "BotaoFavoritesFolderSelected"), for: .selected)
        btn.setImage(UIImage(named: "BotaoFavoritesFolderDeselected"), for: .normal)
        btn.isEnabled = true
        btn.tintColor = #colorLiteral(red: 0.2431372549, green: 0.2392156863, blue: 0.2392156863, alpha: 1)
        btn.addTarget(self, action: #selector(editBtnWasPressed), for: .touchUpInside)
        btn.isHidden = false
        return btn
    }()
    
    @objc func tapFunction() {
        presenter?.goToFavoritesFoldersPosts(with: folder!)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(titleLabel)
        addSubview(searchButton)
        addSubview(editBtn)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        searchButton.isUserInteractionEnabled = true
        searchButton.addGestureRecognizer(tap)
        
        widthConstraint = editBtn.widthAnchor.constraint(equalToConstant: 0)
        widthConstraint?.identifier = "widthBtn"
        widthConstraint?.isActive = true
        
        leadingConstraint = editBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0)
        leadingConstraint?.identifier = "leadingBtn"
        leadingConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            editBtn.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            editBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            titleLabel.leadingAnchor.constraint(equalTo: editBtn.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: readableContentGuide.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor,constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -10),
            searchButton.topAnchor.constraint(equalTo: topAnchor,constant: 10),
            searchButton.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -10),
            searchButton.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -10)
        ])
    }
    
    func setupEdit(isEditing: Bool) {
        if isEditing {
            UIView.animate(withDuration: 0.3) {
                self.leadingConstraint?.constant = 10
                self.widthConstraint?.constant = 30
                self.layoutIfNeeded()
            }
        }else{
            self.editBtn.isSelected = false
            self.removeFolderToDelete(self.folder!)
            UIView.animate(withDuration: 0.3) {
                self.leadingConstraint?.constant = 0
                self.widthConstraint?.constant = 0
                self.layoutIfNeeded()
            }
        }
    }
    
    @objc func editBtnWasPressed(sender: UIButton!) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            addFolderToDelete(folder!)
        }else {
            removeFolderToDelete(folder!)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

