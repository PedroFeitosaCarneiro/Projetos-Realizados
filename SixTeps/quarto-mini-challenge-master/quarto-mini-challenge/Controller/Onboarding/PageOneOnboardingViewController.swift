//
//  PageOneOnboardingViewController.swift
//  quarto-mini-challenge
//
//  Created by Antonio Carlos on 07/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import UIKit

class PageOneOnboardingViewController: UIViewController {
    
    //MARK: - Attributes
    private var backgroundImage: UIImageView = UIImageView()
    private var titleLabel: UILabel = UILabel()
    

    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackgroundImage()
        setupTitleLabel()
        setAutoLayout()
    }
}

//MARK: - Extensions

extension PageOneOnboardingViewController: ViewElementsOnboardingProtocol {
    
    func setupBackgroundImage() {
        let deviceName = AutoLayout.getDeviceNameBasedOnProportion(viewSize: self.view.frame.size)
        self.backgroundImage.image = UIImage(named: "page-1-onboarding-\(deviceName)")
        self.backgroundImage.contentMode = .scaleAspectFit
        self.backgroundImage.frame = CGRect(x: 0, y: 0, width: backgroundImage.frame.width, height: backgroundImage.frame.height)
        self.view.addSubview(backgroundImage)
    }
    
    func setupTitleLabel() {
        
        self.titleLabel.font = UIFont(name: "Helvetica Neue Light", size: 20)
        self.titleLabel.text = NSLocalizedString("priorize",comment:"")
        self.titleLabel.minimumScaleFactor = 0.8
        self.titleLabel.numberOfLines = 2
        self.titleLabel.textColor = UIColor(rgb: 0x707070)
        self.titleLabel.textAlignment = .left
        self.titleLabel.adjustsFontForContentSizeCategory = true
        self.titleLabel.frame = CGRect(x: 0, y: 0, width: 164, height: 125)
        
        self.view.addSubview(self.titleLabel)
        
        
    }
    
}

extension PageOneOnboardingViewController: AutoLayoutOnboarding {
    
    func setAutoLayout() {
        
        //BackgroundImage
        self.backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        let widhtConstaint = NSLayoutConstraint(item: self.backgroundImage, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: self.backgroundImage, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1.0, constant: 0)
        let xConstraint = NSLayoutConstraint(item: self.backgroundImage, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0)
        let yConstraint = NSLayoutConstraint(item: self.backgroundImage, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0)
        
        NSLayoutConstraint.activate([widhtConstaint, heightConstraint, xConstraint, yConstraint])
        
        //TitleLabel
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: (self.titleLabel.frame.width*1.1)/self.view.frame.width).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.view.frame.width*0.12).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height*0.74).isActive = true
    }
    
}
