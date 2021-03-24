//
//  FeedAnimation.swift
//  MacroChallenge
//
//  Created by Lelio Jorge Junior on 05/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

class FeedAnimation: UIView {
    
    /// Lado em que a view ficará.
    enum Constraint {
        case left
        case down
        case right
    }
    
    /// Número da position onde ela ficará.
    enum Node: Int{
        case one = 1
        case two
        case three
    }
    
    
    // MARK: - Atributos
    var post: Post?{
        didSet{
            popUpViewController?.post = post
        }
    }
    
    var feed: AnimationProtocol?
    
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
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.delegate = self
        return view
    }()
    
    var didAppear: (() -> ())?
    var didDisappear: (() -> ())?
    
    var images: [UIImage?]? {
        didSet {
            
            guard let images = self.images else { return }
            
            var result = [UIImage?]()
            
            for value in images {
                if result.contains(value) == false {
                    result.append(value)
                }
            }
            
            while result.count > 6 {
                result.removeLast()
            }
            self.images? = result
        }
    }
    
    let constraintDefaultImages: [(Node,Constraint)] = [
        (.one,.left), (.two,.left), (.three,.left),
        (.one,.right), (.two,.right), (.three,.right), (.one, .down), (.three,.down)]
    
    lazy var popUpViewController: PopUpViewController? = {
        guard let post = self.post else {return nil}
        let viewController = PopUpViewController(post: post)
        let interactor: PopUpInteractor = PopUpInteractor()
        let presenter: PopUpPresenter = PopUpPresenter()
        presenter.interactor = interactor
        viewController.presenter = presenter
        viewController.popUpView.animation = self
        viewController.feed = feed
        return viewController
    }()
    
    private lazy var outherViews: [UIImageView]? = {
        guard let images = self.images else {return nil}
        
        var imagesView: [UIImageView] = [UIImageView]()
        
        for image in images {
            let imageView = UIImageView(image: image)
            imagesView.append(imageView)
        }
        
        return imagesView
    }()
    
    private var myTopConstraint: NSLayoutConstraint?
    private var myBottomConstraint: NSLayoutConstraint?
    private var myLeadingConstraint: NSLayoutConstraint?
    private var myTrailingConstraint: NSLayoutConstraint?
    
    // MARK: - Inicializadores
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.backgroundColor = .white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
        popUpViewController?.animated()
        didAppear?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Métodos
    
    /// Configura as constraints das outher iimages
    /// - Parameters:
    ///   - imageView: UIImageView
    ///   - index: Node
    ///   - positionContraint: Constraint
    func constraintsOutherViewsToPosition(imageView: UIImageView, index: Node, positionContraint: Constraint) {
        
        let const: CGFloat = 5
        let screenHeight: CGFloat = self.bounds.height
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let possitionHeight = (screenHeight + 10) / 3 + const
        let widthPorcent: CGFloat = 43.236 / 100
        let width = screenWidth * widthPorcent
        let boundsConstraints = width - (screenWidth * 0.015700483092)
        
        
        UIView.animate(withDuration: 0.3, animations: {
            switch positionContraint {
            
            case .left:
                
                switch index {
                case .one:
                    imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: const).isActive = true
                    imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -boundsConstraints).isActive = true
                case .two:
                    imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: possitionHeight).isActive = true
                    imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -boundsConstraints).isActive = true
                case .three:
                    imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: possitionHeight * 2).isActive = true
                    imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -boundsConstraints).isActive = true
                }
                
            case .right:
                
                switch index {
                case .one:
                    imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: const).isActive = true
                    imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: boundsConstraints).isActive = true
                case .two:
                    imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: possitionHeight).isActive = true
                    imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: boundsConstraints).isActive = true
                case .three:
                    imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: possitionHeight * 2).isActive = true
                    imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: boundsConstraints).isActive = true
                }
                
            case .down:
                
                switch index {
                case .one:
                    imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: possitionHeight * 2).isActive = true
//                    imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                    imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14).isActive = true
                case .two:
                    let spaceOfScreenWidth = screenWidth * 0.3526570048
                    
                    imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                    imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spaceOfScreenWidth).isActive = true
                    imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spaceOfScreenWidth).isActive = true
                case .three:
                    imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: possitionHeight * 2).isActive = true
//                    imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                    imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -14).isActive = true
                }
                
            }
            imageView.layer.cornerRadius = 5
            imageView.layer.masksToBounds = true
        })
    }
    
    private func constraintsOutherViewsToSize(imageView: UIImageView, constraintSide: Constraint) {
        let screenSize = self.bounds.size
        let heightPorcent: CGFloat = 0.30
        let widthPorcent: CGFloat = 43.236 / 100
        
        let height = screenSize.height * heightPorcent
        let width = screenSize.width * widthPorcent
        
//        let heightPorcentDown: CGFloat = 0.1347438753
        let widthPorcentDown: CGFloat = 0.2922705314 * 1.555
        //let heightDown = screenSize.height * heightPorcentDown
        let widthDown = screenSize.width * widthPorcentDown
        
        imageView.layoutIfNeeded()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        switch constraintSide {
        case .down:
            imageView.heightAnchor.constraint(equalToConstant: height).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: widthDown).isActive = true
        default:
            imageView.heightAnchor.constraint(equalToConstant: height).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
    
    /// Retira a a view da tela.
    func deinitAnimation() {
        
        self.removeFromSuperview()
        
        self.didDisappear?()
        
    }
}

// ViewCoding
extension FeedAnimation: ViewCoding {
    
    func buildViewHierarchy() {
        
        guard let outherViews = self.outherViews , let popUpViewController = self.popUpViewController else {return}
        
        for imageView in outherViews {
            self.addSubview(imageView)
        }
        
        self.addSubview(scrollView)
        self.scrollView.addSubview(containerView)
        self.containerView.addSubview(popUpViewController.view)
        
    }
    
    func setupConstraints() {
        
        guard let outherViews = self.outherViews , let popUpViewController = self.popUpViewController else {return}
        
        let sizeConainer = self.bounds.height / 1.45
        
        // ScrollView
        scrollView.topAnchor.constraint(equalTo: self.topAnchor,constant: 0).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: sizeConainer).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 23).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -23).isActive = true
        
        // ContainerView
        self.containerView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 3).isActive = true
        self.containerView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        self.containerView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        self.containerView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        self.containerView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        self.containerView.heightAnchor.constraint(equalToConstant: sizeConainer + 1).isActive = true
        
        
        let popView = popUpViewController.popUpView
        
        popView.translatesAutoresizingMaskIntoConstraints = false
        
        self.myTopConstraint = popView.topAnchor.constraint(equalTo: self.containerView.topAnchor)
        self.myTopConstraint?.isActive = true
        
        self.myBottomConstraint = popView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor)
        self.myBottomConstraint?.isActive = true
        
        self.myLeadingConstraint = popView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor)
        self.myLeadingConstraint?.isActive = true
        
        self.myTrailingConstraint =  popView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor)
        self.myTrailingConstraint?.isActive = true
        
        popView.layoutIfNeeded()
        
        
        for (imageView,constraint) in zip(outherViews,constraintDefaultImages.reversed()) {
            constraintsOutherViewsToSize(imageView: imageView, constraintSide: constraint.1)
        }
        
        for (image, constraint) in zip(outherViews,constraintDefaultImages.reversed()){
            self.constraintsOutherViewsToPosition(imageView: image, index: constraint.0, positionContraint: constraint.1)
        }
        
    }
    
}

internal func Init<Type>(_ value: Type, block: (_ object: Type) -> Void) -> Type {
    block(value)
    return value
}

// ScrollView
extension FeedAnimation: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < -100 {
            self.deinitAnimation()
        }
    }
    
    
}
