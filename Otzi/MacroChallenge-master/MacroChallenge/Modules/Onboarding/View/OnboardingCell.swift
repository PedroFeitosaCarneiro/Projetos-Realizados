//
//  OnboardingCell.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 05/11/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

class OnboardingCell: UICollectionViewCell, ViewCoding{
    
    static var reuseIdentifier: String {
        return String(describing: OnboardingCell.self)
    }
    
    
    
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
    
    
    lazy var hashTagLabel:UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.init(name: "Coolvetica", size: 18)
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var selectImg: UIImageView = {
        let btn = UIImageView()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.contentMode = .scaleAspectFill
        btn.image = UIImage(named: "BotaoFavoritesFolderDeselected")
        btn.isHidden = false
        return btn
    }()
    
    
    override var isSelected: Bool{
        didSet{
            let name = isSelected ? "BotaoFavoritesPostsSelected" : "BotaoFavoritesFolderDeselected"
            selectImg.image = UIImage(named: name)
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
            self.coverImage.image = UIImage(named: hashtag.text)
        }
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        coverImage.image = nil
        onReuse()
    }

    //MARK: -> View Coding
    func buildViewHierarchy() {
        self.contentView.addSubview(coverImage)
        self.contentView.addSubview(colorLayer)
        self.contentView.addSubview(hashTagLabel)
        self.contentView.addSubview(selectImg)
    }
    
    func setupConstraints() {
        coverImage.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([coverImage.topAnchor.constraint(equalTo: self.topAnchor),
                                     coverImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.85),
        coverImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        coverImage.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
        
        
        hashTagLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([hashTagLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor,constant: 0),hashTagLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.15), hashTagLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 3),hashTagLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -3)])
        
        
        
        selectImg.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            selectImg.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            selectImg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            selectImg.heightAnchor.constraint(equalToConstant: selectImg.image!.size.height),selectImg.widthAnchor.constraint(equalToConstant: selectImg.image!.size.width)
        ])

    }
    
    func setupAdditionalConfiguration() {
        self.layer.masksToBounds = true
        
        self.colorLayer.layer.zPosition = 10
        self.hashTagLabel.layer.zPosition = 11
        self.backgroundColor = .clear
    }
    
    
}
