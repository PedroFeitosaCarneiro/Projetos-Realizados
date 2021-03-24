//
//  CustomFooterView.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 28/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit



class CustomFooterView : UICollectionReusableView, ViewCoding {
    
   
   
    lazy var refreshControlIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .black
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    
    var isAnimatingFinal:Bool = false
    var currentTransform:CGAffineTransform?

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareInitialAnimation()
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setTransform(inTransform:CGAffineTransform, scaleFactor:CGFloat) {
        if isAnimatingFinal {
            return
        }
        self.currentTransform = inTransform
//        self.refreshControlIndicator.transform = CGAffineTransform.init(scaleX: scaleFactor, y: scaleFactor)
    }
    

    func prepareInitialAnimation() {
        self.isAnimatingFinal = false
        self.refreshControlIndicator.stopAnimating()
//        self.refreshControlIndicator.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
    }
    
    func startAnimate() {
        self.isAnimatingFinal = true
        self.refreshControlIndicator.startAnimating()
        self.refreshControlIndicator.isHidden = false
    }
    
    func stopAnimate() {
        self.isAnimatingFinal = false
        DispatchQueue.main.async {
            self.refreshControlIndicator.stopAnimating()
        }
    }
    
  
    func animateFinal() {
        if isAnimatingFinal {
            return
        }
        self.isAnimatingFinal = true
        UIView.animate(withDuration: 0.2) {
//            self.refreshControlIndicator.transform = CGAffineTransform.identity
        }
    }
    //MARK: -> ViewCoding
    
    func buildViewHierarchy() {
        
        self.addSubview(refreshControlIndicator)
       
    }
    
    func setupConstraints() {
        refreshControlIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([refreshControlIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor), refreshControlIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor)])
    }
    
    func setupAdditionalConfiguration() {
        self.prepareInitialAnimation()
    }
    
}
