//
//  SplashScreenViewController.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 19/11/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit


class SplashScreenViewController: UIViewController{
    lazy var backgroundImage: UIImageView = {
       let img = UIImageView(image: UIImage(named: "backgrounOnBoarding"))
        img.contentMode = .scaleAspectFill
        img.backgroundColor = .lightGray
       return img
    }()
    
    lazy var layerView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        return view
    }()
    
    lazy var reloadButton: UIButton = {
        let rect = CGRect(origin: .zero, size: CGSize(width: 100, height: 38))
        let text = "Try again"
        let button = CustomExploreButton(frame: rect, text: text, tag: 1)
        button.isSelected = true
        button.addTarget(self, action: #selector(self.reloadScreen), for: .touchUpInside)
        button.isHidden = true
        button.backgroundColor = .white
        button.setTitleColor(.gray, for: .normal)
        button.setTitleColor(.gray, for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        label.textAlignment = .center
        label.numberOfLines = 3
        label.isHidden = true
        label.font = UIFont.init(name: "Coolvetica", size: 45)
        label.minimumScaleFactor = 0.5
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.text = "Looks your phone is not connect to the internet, reconnect it and try it again."
        return label
    }()
    
    
    lazy var indicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activityIndicator.color = .white
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        return activityIndicator
    }()
    let logger:Logger
    
    init(logger: Logger) {
        self.logger = logger
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 228/255, green: 227/255, blue: 223/255, alpha: 1.0)

        
        view.addSubview(backgroundImage)
        view.addSubview(layerView)
        view.addSubview(indicator)

        
        
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([backgroundImage.heightAnchor.constraint(equalTo: view.heightAnchor),
                                     backgroundImage.widthAnchor.constraint(equalTo: view.widthAnchor),
                                     backgroundImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        layerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([layerView.heightAnchor.constraint(equalTo: view.heightAnchor),
                                     layerView.widthAnchor.constraint(equalTo: view.widthAnchor),
                                     layerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     layerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        indicator.startAnimating()
        
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([indicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
                                        indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)])
        
        
      

        self.view.addSubview(label)
     
     label.translatesAutoresizingMaskIntoConstraints = false
     NSLayoutConstraint.activate([label.heightAnchor.constraint(equalToConstant: 100),
                                  label.widthAnchor.constraint(equalToConstant: 300),
                                  label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100),
                                  label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)])
        

        self.view.addSubview(reloadButton)

        NSLayoutConstraint.activate([reloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     reloadButton.centerYAnchor.constraint(equalTo: label.centerYAnchor,constant: 100),
                                     reloadButton.widthAnchor.constraint(equalToConstant: 100 ),
                                     reloadButton.heightAnchor.constraint(equalToConstant: 37 )])
        
       
    }
    
    @objc func reloadScreen(){
        
        DispatchQueue.main.async { [self] in
            label.isHidden = true
            indicator.isHidden = false
            indicator.startAnimating()
            reloadButton.isHidden = true
            logger.certificate()
        }
    }
    
    
    
    
    func setupNetWithoutInternet(){
        DispatchQueue.main.async { [self] in
            label.isHidden = false
            indicator.isHidden = true
            reloadButton.isHidden = false
        }
    }
}
