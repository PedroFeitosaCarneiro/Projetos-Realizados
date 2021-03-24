//
//  PageThreeOnboardingViewController.swift
//  quarto-mini-challenge
//
//  Created by Antonio Carlos on 07/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import UIKit

class PageThreeOnboardingViewController: UIViewController {
    
    //MARK: - Attributes
    private var backgroundImage: UIImageView = UIImageView()
    private var titleLabel: UILabel = UILabel()
    private var startButton: UIButton = UIButton(type: .custom)
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgroundImage()
        setupTitleLabel()
        setupStartButton()
        setAutoLayout()
    }
    
    //MARK: - Methods
    func setupStartButton() {
        
        let deviceName = AutoLayout.getDeviceNameBasedOnProportion(viewSize: self.view.frame.size)
        self.startButton.setBackgroundImage(UIImage(named: "start-button-\(deviceName)"), for: .normal)
        self.startButton.setTitle("Começar", for: .normal)
        self.startButton.titleLabel?.font = UIFont(name: "Helvetica Neue Medium", size: 20)
        self.startButton.titleLabel?.textAlignment = .center
        self.startButton.titleEdgeInsets = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0)
        self.startButton.addTarget(self, action: #selector(didTapOnStartButton), for: .touchUpInside)
        
        self.view.addSubview(self.startButton)
    }
    
    @objc func didTapOnStartButton() {
        let tasksST = UIStoryboard(name: "Tasks", bundle: nil)
        
        let taskVC = tasksST.instantiateInitialViewController()
        
        self.present(taskVC!, animated: true, completion: nil)
    }
    
}

extension PageThreeOnboardingViewController: ViewElementsOnboardingProtocol {
    
    func setupBackgroundImage() {
        let deviceName = AutoLayout.getDeviceNameBasedOnProportion(viewSize: self.view.frame.size)
        self.backgroundImage.image = UIImage(named: "page-3-onboarding-\(deviceName)")
        self.backgroundImage.contentMode = .scaleAspectFit
        self.backgroundImage.frame = CGRect(x: 0, y: 0, width: backgroundImage.frame.width, height: backgroundImage.frame.height)
        self.view.addSubview(backgroundImage)
    }
    
    func setupTitleLabel() {
        self.titleLabel.font = UIFont(name: "Helvetica Neue Light", size: 20)
        self.titleLabel.text = NSLocalizedString("FollowProgress",comment:"")
        self.titleLabel.numberOfLines = 3
        self.titleLabel.textColor = UIColor(rgb: 0x707070)
        self.titleLabel.textAlignment = .right
        self.titleLabel.adjustsFontForContentSizeCategory = true
        self.titleLabel.frame = CGRect(x: 0, y: 0, width: 207, height: 85)
        
        self.view.addSubview(self.titleLabel)
    }
    
    
}

extension PageThreeOnboardingViewController: AutoLayoutOnboarding {
    
    func setAutoLayout() {
        //Background Image
        self.backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        let widhtConstaint = NSLayoutConstraint(item: self.backgroundImage, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: self.backgroundImage, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1.0, constant: 0)
        let xConstraint = NSLayoutConstraint(item: self.backgroundImage, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0)
        let yConstraint = NSLayoutConstraint(item: self.backgroundImage, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activate([widhtConstaint, heightConstraint, xConstraint, yConstraint])
        
        //Title Label
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: self.titleLabel.frame.width/self.view.frame.width).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height*0.65).isActive = true
        self.view!.addConstraint(NSLayoutConstraint(item: self.view!, attribute: .trailing, relatedBy: .equal, toItem: self.titleLabel, attribute: .trailing, multiplier: 1.0, constant: self.view.frame.width*0.085))
        
        //Start button
        self.startButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.startButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height*0.8).isActive = true
        self.view!.addConstraint(NSLayoutConstraint(item: self.view!, attribute: .trailing, relatedBy: .equal, toItem: self.startButton, attribute: .trailing, multiplier: 1.0, constant: self.view.frame.width*0.06))
    }
    
}
