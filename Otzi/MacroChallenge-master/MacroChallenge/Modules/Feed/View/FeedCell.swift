//
//  FeedCell.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 08/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit

class FeedCell: UICollectionViewCell, ViewCoding,AnimatableView{
    
    //MARK: -> Properties
    lazy var coverImage: UIImageView = {
        let cover = UIImageView()
        cover.contentMode = .scaleAspectFill
        cover.clipsToBounds = true
        
        return cover
    }()
    
    private let favoriteButton: UIButton = {
        let favoriteButton = UIButton()
        favoriteButton.setImage(.add, for: .normal)
        favoriteButton.layer.zPosition = 3
        favoriteButton.tintColor = .red
        favoriteButton.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
        return favoriteButton
    }()
    
    
    lazy var acticvityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .black
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "Coolvetica", size: 28)//UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        label.textColor = .green
        return label
    }()
    
    var onReuse: () -> () = {}
    var didTapFavoriteButton : () -> () = {}
    
    var post: Post?
        
    weak var vc: FeedViewController?
    
    var isAnimated = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 210.0/255.0, green: 210.0/255.0, blue: 210.0/255.0, alpha: 1.0)
        self.isUserInteractionEnabled = true
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Método para popular a célula
    /// - Parameter image: UIImage, parâmetro para ser poplado
    func populate(with image: UIImage?){
        DispatchQueue.main.async {
            guard let img = image else {return}
            self.coverImage.image = img
            self.acticvityIndicator.stopAnimating()
        }
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImage.image = nil
        onReuse()
    }
    
    @objc func didTapFavorite(){
        didTapFavoriteButton()
    }
    
    
    //MARK: -> View Coding
    func buildViewHierarchy() {
        self.contentView.addSubview(coverImage)
        self.contentView.addSubview(acticvityIndicator)
//        self.contentView.addSubview(titleLabel)
    }
    
    func setupConstraints() {
        coverImage.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([coverImage.topAnchor.constraint(equalTo: self.topAnchor),
        coverImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        coverImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        coverImage.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
            
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        acticvityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([acticvityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),acticvityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)])
        
        
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),titleLabel.widthAnchor.constraint(equalToConstant: 50),titleLabel.heightAnchor.constraint(equalToConstant: 50)])
    
    }
    
    func setupAdditionalConfiguration() {
//        acticvityIndicator.startAnimating()
//        acticvityIndicator.isHidden = false//
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
    }
    
    
}


extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
