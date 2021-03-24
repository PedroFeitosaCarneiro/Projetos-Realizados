//
//  PopUpView.swift
//  MacroChallenge
//
//  Created by Lelio Jorge Junior on 23/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit


/// Devolve o status do toque.
enum TouchStatus {
    case instagram
    case favorite
    case favoriteDelete
}

/// Devolve a imagem para o botão de acordo com sua responsabilidade.
enum ImageDefaults {
    case instagram
    case favoriteBlank
    case favoriteGray
    
    var photo: UIImage {
        switch self {
        case .instagram:
            let name = "bingButton"
            return UIImage(named: name)!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        case .favoriteBlank:
            return UIImage(named: "FavoriteBlankButton")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        case .favoriteGray:
            return UIImage(named: "FavoriteGrayButton")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        }
    }
}



/// PopUpView aprensenta a Informações do post. Owner, image description e tags do post.
class PopUpView: UIView {
    
    // MARK: - Atributos
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.frame.size = CGSize(width: self.frame.width, height: self.frame.height)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.backgroundColor = .white
        view.frame = self.bounds
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    private lazy var instagramButtonView: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(ImageDefaults.instagram.photo, for: .normal)
        button.addTarget(nil, action: #selector(instagramButtonAction), for: .touchDown)
        return button
    }()
    
    private lazy var favoriteButtonView: UIButton = {
        let button = UIButton()
        button.setImage(ImageDefaults.favoriteBlank.photo, for: .normal)
        button.addTarget(nil, action: #selector(favoriteButtonAction), for: .touchDown)
        return button
    }()
    
    private lazy var moreButtonView: UIButton = {
        let button = UIButton()
        button.setTitle("mais", for: .normal)
        button.addTarget(nil, action: #selector(moreButtonAction), for: .touchDown)
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(callTouch))
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tapGestureRecognizer)
        return image
    }()
    
    private lazy var autorLabelView: UILabel = {
        let label = UILabel()
        
        if let customFont = UIFont(name: "SourceSansPro-Bold", size: 18) {
            label.font = UIFontMetrics.default.scaledFont(for: customFont)
            label.adjustsFontForContentSizeCategory = true
        }
        
        label.text = "  "
        label.textColor = .init(red: 101/255, green: 101/255, blue: 101/255, alpha: 1)
        label.textAlignment = .left
        label.numberOfLines = 3;
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    private lazy var descriptionLabelView: UILabel = {
        let label = UILabel()
        if let customFont = UIFont(name: "SourceSansPro-Regular", size: 16) {
            label.font = UIFontMetrics.default.scaledFont(for: customFont)
            label.adjustsFontForContentSizeCategory = true
        }
        
        label.numberOfLines = .max
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var customCollectionView: CustomCollection = {
        let custom = CustomCollection(frame: CGRect(x: 0, y: self.frame.height / 2, width: self.bounds.width, height: 200))
        custom.backgroundColor = .white
        custom.textColor = .white
        if let customFont = UIFont(name: "SourceSansPro-Regular", size: 14) {
            custom.font = UIFontMetrics.default.scaledFont(for: customFont)
        }
        custom.backgroundColorTag = UIColor(red: 196/255, green: 195/255, blue: 195/255, alpha: 1)
        custom.alignment = .left
        custom.corneRadius = 3
        getTag()?.forEach{custom.addTag($0)}
        if let count = self.tags?.count, count > 7 {
            custom.addTag("+").onTap = {
                self.isMoreTags = true
            }
        }
        return custom
    }()
    
    private var newTags: [String] = []
    
    private var sizeDescription: CGSize? {
        didSet {
            let screen = UIScreen.main.bounds
            if let size = sizeDescription {
                if size.height > screen.height * 0.1216517857 {
                    sizeDescription = CGSize(width: size.width, height: screen.height * 0.1216517857)
                }
            }
        }
    }
    
    private var tags: [String]? {
        get{
            newTags.isEmpty ? self.delegate?.hashtags() : newTags
        }
        set{
            newTags = newValue!
        }
    }
    
    var isAnimated: Bool = false {
        didSet {
            self.scrollView.isUserInteractionEnabled = isAnimated
            
            if isAnimated {
                self.tags = self.delegate?.hashtags()
                self.setupView()
                self.animateConstraint()
                
            }
        }
    }
    
    var isFavorited: Bool {
        return checkWasFavorite()
    }
    
    var isMoreTags: Bool = false {
        didSet{
            customCollectionView.removeTags()
            getTag()?.forEach{customCollectionView.addTag($0)}
            self.animateCollectionView()
        }
    }
    
    weak var delegate: PopUpViewControllerDelegate?
    weak var animation: FeedAnimation?
    
    private var descriptionLabelViewConstraint: NSLayoutConstraint!
    
    private var imageViewHeightAnchor: NSLayoutConstraint!
    private var imageViewLeadingAnchor: NSLayoutConstraint!
    private var imageViewTrailingAnchor: NSLayoutConstraint!
    
    private var collectionHeightAnchor: NSLayoutConstraint!
    
    // MARK: - Inicializador
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Metódos
    
    /// Informa para a controller que o botão instagram foi tocado.
    @objc private func instagramButtonAction() {
        self.delegate?.touch(status: .instagram)
    }
    
    /// Informa para a controller que o botão salvofoi tocado.
    @objc private func favoriteButtonAction() {
        if !isFavorited {
            self.delegate?.touch(status: .favorite)
        }else {
            self.delegate?.touch(status: .favoriteDelete)
        }
    }
    
    /// Muda a imagedo button para o tipo passado.
    /// - Parameter image: ImageDefaults
    func changerFavoriteButton(to image: ImageDefaults) {
        self.animateFavoriteButton(image.photo)

    }
    
    @objc private func moreButtonAction() {
        
    }
    
    /// Adiciona a imagem ao ImageView.
    /// - Parameter image: UIimage
    func add(image: UIImage){
        self.imageView.image = image
    }
    
    /// Adiciona o nome do Owner a  autorLabelView.
    /// - Parameter owner: String
    func add(owner: String){
        self.autorLabelView.text = owner
        if isFavorited {
            changerFavoriteButton(to: .favoriteGray)
        }
    }
    
    /// Adiciona a descrição ao descriptionLabelView.
    /// - Parameter description: String
    func add(description: String){
        self.descriptionLabelView.text = description
        sizeDescription = description.size(withAttributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)])
    }
    
    /// Formata as tags e fornece a quantidade especifica, 7 no inicio da instancia do PopUpView e todas quando o usuário tocar no "+".
    /// - Returns: [String]?
    func getTag() -> [String]? {
        
        guard var tags = self.tags else {return nil}
        
        tags = tags.map{ "#" + $0 }
        
        if tags.count >= 5 {
            if !isMoreTags {
                var result: [String] = [String]()
                tags.forEach {
                    if result.count <= 5 {
                        result.append($0)
                    }
                }
                return result
            }
        }
        
        return tags
    }
    
    /// Anima as constraints da UIView e UIImageView.
    private func animateConstraint() {
        
        let screen = UIScreen.main.bounds
        print(screen)
        //        self.imageViewHeightAnchor.constant = -(self.bounds.height * 0.4174107143)
        self.imageViewLeadingAnchor.constant = -2
        self.imageViewTrailingAnchor.constant = 2
        self.imageView.layer.cornerRadius = 10
        self.imageView.layer.masksToBounds = true
        UIView.animate(withDuration: 0.05, animations: {
            
            self.layoutIfNeeded()
        })
    }
    
    /// Animate constraints da CustomCollectionView.
    private func animateCollectionView() {
        
        self.customCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.collectionHeightAnchor.constant = CGFloat(self.customCollectionView.numberOfRows() * 30)
        
        
        self.customCollectionView.updateConstraints()
        self.customCollectionView.layoutIfNeeded()
        
    }
    
    /// Adiciona uma imagem ao botão.
    /// - Parameter imageView: UIImage
    private func animateFavoriteButton(_ imageView: UIImage) {
        self.favoriteButtonView.setImage(imageView, for: .normal)
    }
    
    /// Verifica se o post ja foi salvo.
    /// - Returns: Bool
    private func checkWasFavorite() -> Bool! {
        return self.delegate?.checkWasFavorite()
    }
    
    @objc private func callTouch() {
        self.delegate?.touch(status: .instagram)
    }
    
}


// MARK: - View Conding
extension PopUpView: ViewCoding {
    
    func buildViewHierarchy() {
        if !isAnimated {
            self.addSubview(scrollView)
            self.scrollView.addSubview(containerView)
        } else {
            self.containerView.addSubview(imageView)
            self.containerView.addSubview(instagramButtonView)
            self.containerView.addSubview(favoriteButtonView)
            self.containerView.addSubview(autorLabelView)
            self.containerView.addSubview(descriptionLabelView)
            self.containerView.addSubview(customCollectionView)
        }
        
    }
    
    func setupConstraints() {
        if !isAnimated {
            
            // ScrollView
            self.scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            
            // ContainerView
            self.containerView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
            self.containerView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
            self.containerView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
            self.containerView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
            self.containerView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
            
        } else {
            
            let screen = UIScreen.main.bounds
            let screenWidth = screen.width
            let screenHeight = screen.height
            let sizeButtonsInstagram = CGSize(width: 23, height: 23)
//            let sizeButtonsFavorite = CGSize(width: 23, height: 27)

            let instagramTrailingSpaceFavorite = screenWidth * 0.06335748792 - 10
            let nodeSpaceImage = screenHeight * 0.02845982143
            let descriptionTopSpaceAutor = screenHeight * 0.01674107143
            let tagSpacedescription = descriptionTopSpaceAutor
            
            // ImageView
            self.imageView.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
            self.imageViewHeightAnchor = self.imageView.heightAnchor.constraint(equalToConstant: self.bounds.height * 0.6)
            self.imageViewHeightAnchor.isActive = true
            self.imageViewLeadingAnchor = self.imageView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor)
            self.imageViewLeadingAnchor.isActive = true
            self.imageViewTrailingAnchor = self.imageView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor)
            self.imageViewTrailingAnchor.isActive = true
            
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut],animations: {
                self.imageView.layoutIfNeeded()
            })
            
            
            // FavoriteButton
            self.favoriteButtonView.translatesAutoresizingMaskIntoConstraints = false
            
//            self.favoriteButtonView.heightAnchor.constraint(equalToConstant: sizeButtonsFavorite.height).isActive = true
//            self.favoriteButtonView.widthAnchor.constraint(equalToConstant: sizeButtonsFavorite.width).isActive = true
            self.favoriteButtonView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: nodeSpaceImage).isActive = true
            self.favoriteButtonView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor).isActive = true
            UIView.animate(withDuration: 0.2) {
                self.favoriteButtonView.layoutIfNeeded()
            }
            // Instagram Button
            self.instagramButtonView.translatesAutoresizingMaskIntoConstraints = false
            
            self.instagramButtonView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            self.instagramButtonView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            self.instagramButtonView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: nodeSpaceImage).isActive = true
            self.instagramButtonView.trailingAnchor.constraint(equalTo: self.favoriteButtonView.leadingAnchor, constant: -instagramTrailingSpaceFavorite).isActive = true
            UIView.animate(withDuration: 0.2) {
                self.instagramButtonView.layoutIfNeeded()
            }
            // Autor Button
            self.autorLabelView.translatesAutoresizingMaskIntoConstraints = false
            
            self.autorLabelView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: nodeSpaceImage).isActive = true
            self.autorLabelView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 2).isActive = true
            self.autorLabelView.trailingAnchor.constraint(equalTo: self.instagramButtonView.trailingAnchor, constant: -nodeSpaceImage - 2).isActive = true
            
            // Description Button
            self.descriptionLabelView.translatesAutoresizingMaskIntoConstraints = false
            
            self.descriptionLabelView.topAnchor.constraint(equalTo: self.autorLabelView.bottomAnchor,constant: descriptionTopSpaceAutor).isActive = true
            self.descriptionLabelViewConstraint = self.descriptionLabelView.heightAnchor.constraint(equalToConstant: self.sizeDescription?.height ?? 44)
            self.descriptionLabelViewConstraint.isActive = true
            self.descriptionLabelView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
            self.descriptionLabelView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor).isActive = true
            
            // Custom collectionView
            self.customCollectionView.translatesAutoresizingMaskIntoConstraints = false
            
            self.customCollectionView.topAnchor.constraint(equalTo: self.descriptionLabelView.bottomAnchor,constant: tagSpacedescription).isActive = true
            self.customCollectionView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
            self.collectionHeightAnchor = self.customCollectionView.heightAnchor.constraint(equalToConstant: 48)
            self.collectionHeightAnchor.isActive = true
            self.customCollectionView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
            self.customCollectionView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor).isActive = true
            
        }
        
    }
    
}


// MARK: - ScroolView Delegate
extension PopUpView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.animation?.scrollViewDidScroll(scrollView)
    }
}
