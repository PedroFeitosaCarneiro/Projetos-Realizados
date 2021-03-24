//
//  ExploreCell.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 22/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//


import Foundation
import UIKit

class ExploreCell: UICollectionViewCell, ViewCoding{
    
    
    //MARK: -> View
    private lazy var coverImage: UIImageView = {
       let cover = UIImageView()
        cover.contentMode = .scaleAspectFill
        cover.clipsToBounds = true
        return cover
    }()
    
    lazy var colorLayer: UIView = {
       let cover = UIView()
        cover.clipsToBounds = true
        cover.backgroundColor = ViewColor.ExploreView.BackgroundCell.color
        cover.isUserInteractionEnabled = true
        return cover
    }()
    
    lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = colorLayer.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.3
        return blurEffectView
    }()
    
    lazy var acticvityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .black
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    lazy var hashTagLabel:UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.init(name: "Coolvetica", size: 15)
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.5
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override var isSelected: Bool{
        didSet{
            DispatchQueue.main.async { [self] in
                if self.isSelected{
                    self.setupSelectedCell()
                }else{
                    self.setupNotSelectedCell()
                }
            }
        }
    }
    var userSelected = false
    
    ///Closure chamada quando a célula vai ser reutilizada
    var onReuse: () -> () = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    /// Método para popular a célula
    /// - Parameter image: UIImage, parâmetro para ser poplado
    func populate(with hashtag: HashtagSuggest){
        DispatchQueue.main.async {
            self.hashTagLabel.text = hashtag.text
            self.acticvityIndicator.stopAnimating()
        }
        
    }
    
    /// Método para popular a célula
    /// - Parameter image: UIImage, parâmetro para ser poplado
    func populate(with image: UIImage){
        DispatchQueue.main.async { [self] in
            self.coverImage.image = image
            self.acticvityIndicator.stopAnimating()
            
            if self.isSelected{
                self.colorLayer.backgroundColor = UIColor.white.withAlphaComponent(0.8)
            }else{
                self.colorLayer.backgroundColor = self.coverImage.image != nil ?  .clear : ViewColor.ExploreView.BackgroundCell.color
            }
        }
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImage.image = nil
        onReuse()
    }
    
    func setupSelectedCell(){
        colorLayer.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        blurEffectView.alpha = 0.7
        hashTagLabel.textColor = .black
    }
    func setupNotSelectedCell(){
        colorLayer.backgroundColor = coverImage.image != nil ?  .clear : ViewColor.ExploreView.BackgroundCell.color
        blurEffectView.alpha = 0.3
        hashTagLabel.textColor = .white
    
        
    }
    
    //MARK: -> View Coding
    func buildViewHierarchy() {
        self.contentView.addSubview(coverImage)
        self.contentView.addSubview(colorLayer)
        self.contentView.addSubview(acticvityIndicator)
        self.contentView.addSubview(hashTagLabel)
    }
    
    func setupConstraints() {
        coverImage.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([coverImage.topAnchor.constraint(equalTo: self.topAnchor),
        coverImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        coverImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        coverImage.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
        
        colorLayer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([colorLayer.topAnchor.constraint(equalTo: self.topAnchor),
        colorLayer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        colorLayer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        colorLayer.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
        
        acticvityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([acticvityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor), acticvityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor)])
        
        hashTagLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([hashTagLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor), hashTagLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 3),hashTagLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -3)])

    }
    
    func setupAdditionalConfiguration() {
        acticvityIndicator.startAnimating()
        acticvityIndicator.isHidden = false
        self.layer.masksToBounds = true
        
        self.colorLayer.layer.zPosition = 10
        self.hashTagLabel.layer.zPosition = 11
        self.colorLayer.addSubview(blurEffectView)
    }
    
    
}
