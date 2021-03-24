//
//  PreFeedCell.swift
//  MacroChallenge
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 19/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

class PreFeedCell: UICollectionViewCell, AnimatableView {
   
    
    var imageDisplayed : UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true

        return img
    }()

    lazy var acticvityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .black
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
//    lazy var titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.init(name: "Coolvetica", size: 28)//UIFont.boldSystemFont(ofSize: 28)
//        label.textAlignment = .center
//        label.adjustsFontSizeToFitWidth = true
//        label.sizeToFit()
//        label.textColor = .green
//        return label
//    }()
    var isAnimated: Bool = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadView(with image: UIImage?){
        DispatchQueue.main.async { [self] in
            self.imageDisplayed.image = image
            self.acticvityIndicator.stopAnimating()
            self.acticvityIndicator.isHidden = true
        }
    }
    
    func showLoadingIndicator(){
        DispatchQueue.main.async { [self] in
            self.acticvityIndicator.isHidden = false
            self.acticvityIndicator.startAnimating()
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        //imageDisplayed.image = nil
    }
}

extension PreFeedCell: ViewCoding{
    
    func setupAdditionalConfiguration() {
        self.backgroundColor = UIColor(red: 210.0/255.0, green: 210.0/255.0, blue: 210.0/255.0, alpha: 1.0)
//        acticvityIndicator.startAnimating()
//        acticvityIndicator.isHidden = false
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
    }
    
    func buildViewHierarchy() {
        self.contentView.addSubview(imageDisplayed)
        self.contentView.addSubview(acticvityIndicator)
//        self.contentView.addSubview(titleLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageDisplayed.topAnchor.constraint(equalTo:  self.contentView.topAnchor, constant: 0),
            imageDisplayed.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            imageDisplayed.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            imageDisplayed.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0)
        ])
        
        acticvityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([acticvityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor), acticvityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor)])
        
//                titleLabel.translatesAutoresizingMaskIntoConstraints = false
//
//                NSLayoutConstraint.activate([titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),titleLabel.widthAnchor.constraint(equalToConstant: 50),titleLabel.heightAnchor.constraint(equalToConstant: 50)])
    }
    
    
}
