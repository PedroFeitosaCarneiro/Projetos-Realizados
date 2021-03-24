//
//  FirstViewController.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 26/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

/// Primeira página do onboarding
class FirstViewController: UIViewController,OnboardingPage  {

    //MARK: -> View
    lazy var backgroundImage: UIImageView = {
       let img = UIImageView(image: UIImage(named: "backgrounOnBoarding"))
        img.contentMode = .scaleAspectFill
        img.backgroundColor = .lightGray
       return img
    }()
    
    
    lazy var arrowImage: UIImageView = {
       let img = UIImageView(image: UIImage(named: "setas-bg-1"))
        img.contentMode = .scaleAspectFill
       return img
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 3
        label.isHidden = false
        label.font = UIFont.init(name: "Coolvetica", size: 45)
        label.minimumScaleFactor = 0.5
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        return label
    }()
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.isHidden = false
        label.font = UIFont.init(name: "Coolvetica", size: 20)
        label.minimumScaleFactor = 0.5
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        return label
    }()
    
    lazy var skipButton: UIButton = {
        let rect = CGRect(origin: .zero, size: CGSize(width: 80, height: 27))
        let text = "Skip"
        let button = OnboardingButton(text: text, fontSize: 16)
        button.addTarget(self, action: #selector(self.skipButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let text = "Let's Go!"
        let button = OnboardingButton(text: text, fontSize: 25)
        button.addTarget(self, action: #selector(self.nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var pageDelegate: WalkThroughOnBoardDelegate?
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    let pageModel: PageModel

    
    init(pageModel: PageModel) {
        self.pageModel = pageModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func nextButtonTapped(){
        pageDelegate?.goNextPage(fowardTo: pageModel.nextPage)
    }

    
    /// Método chamando quando o skip de voltar é clicado
    @objc func skipButtonTapped(){
        pageDelegate?.skipOnboarding()
//        pageDelegate?.goNextPage(fowardTo: .loginPage)

    }
}



extension FirstViewController: ViewCoding{
    func buildViewHierarchy() {
        view.addSubview(backgroundImage)
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(nextButton)
        view.addSubview(arrowImage)
        view.addSubview(skipButton)
    }
    
    func setupConstraints() {
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([backgroundImage.heightAnchor.constraint(equalTo: view.heightAnchor),
                                     backgroundImage.widthAnchor.constraint(equalTo: view.widthAnchor),
                                     backgroundImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let width: CGFloat = UIScreen.main.bounds.width * 0.6
        let top: CGFloat = UIScreen.main.bounds.width * 0.71
        NSLayoutConstraint.activate([titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: top),
                                     titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     titleLabel.heightAnchor.constraint(equalToConstant: 135),
                                     titleLabel.widthAnchor.constraint(equalToConstant: width)])
        
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([subTitleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -200),
                                     subTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     subTitleLabel.heightAnchor.constraint(equalToConstant: 40),
                                     subTitleLabel.widthAnchor.constraint(equalToConstant: width)])
        
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([skipButton.heightAnchor.constraint(equalToConstant: 35),skipButton.widthAnchor.constraint(equalToConstant:55),
                                     skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),skipButton.topAnchor.constraint(equalTo: view.topAnchor,constant: 60)])
     
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -200),
                                     nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     nextButton.heightAnchor.constraint(equalToConstant: 35),
                                     nextButton.widthAnchor.constraint(equalToConstant: 110)])
        
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        
        if pageModel.currentPage == .initial{
            NSLayoutConstraint.activate([arrowImage.heightAnchor.constraint(equalToConstant: 15),arrowImage.widthAnchor.constraint(equalToConstant: arrowImage.image!.size.width),
                                         arrowImage.leadingAnchor.constraint(equalTo: subTitleLabel.trailingAnchor,constant: -16),
                                         arrowImage.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -212)])
        }else{
            NSLayoutConstraint.activate([arrowImage.heightAnchor.constraint(equalToConstant: 15),arrowImage.widthAnchor.constraint(equalToConstant: arrowImage.image!.size.width),
                                         arrowImage.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 40),
                                         arrowImage.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -212)])
        }
        
        

    }
    
    func setupAdditionalConfiguration() {
        titleLabel.text = pageModel.titleText
        subTitleLabel.text = pageModel.subTitleText
        let imageName = pageModel.currentPage == .initial ? "bg-1" : "bg-2"
        backgroundImage.image = UIImage(named: imageName)!
        
        let hideNextButton = pageModel.currentPage == .initial
        subTitleLabel.isHidden = !hideNextButton
        nextButton.isHidden = hideNextButton
    }
}
