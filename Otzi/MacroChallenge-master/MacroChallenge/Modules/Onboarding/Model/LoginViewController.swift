//
//  LoginViewController.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 18/11/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, OnboardingPage {

    
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
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 3
        label.isHidden = false
        label.font = UIFont.init(name: "Coolvetica", size: 40)
        label.minimumScaleFactor = 0.5
        label.sizeToFit()
//        label.baselineAdjustment = .alignBaselines
//        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.text = pageModel.titleText
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.isHidden = false
        label.font = UIFont.init(name: "Helvetica", size: 14)
        label.minimumScaleFactor = 0.5
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.text  = pageModel.subTitleText
        return label
    }()
    
    
    lazy var loginButton: UIButton = {
        let text = "log in"
        let button = OnboardingButton(text: text, fontSize: 20)
        button.addTarget(self, action: #selector(self.loginButtonTapped), for: .touchUpInside)
        button.isEnabled = true
        button.backgroundColor = UIColor(red: 185/255, green: 139/255, blue: 14/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    
    lazy var loginASGusetButton: UIButton = {
        let text = "continue as guest"
        let button = OnboardingButton(text: text, fontSize: 20)
        button.addTarget(self, action: #selector(self.loginAsGuestButtonTapped), for: .touchUpInside)
        button.isEnabled = true
        return button
    }()
    
    
    let pageModel: PageModel

    var didTapLogInAsGuest = true
    
    var pageDelegate: WalkThroughOnBoardDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    init(pageModel: PageModel) {
        self.pageModel = pageModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func loginButtonTapped(){
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
//        pageDelegate?.didFinishPage(with: selectedItens)
        didTapLogInAsGuest = false
        pageDelegate?.goNextPage(fowardTo: pageModel.nextPage)
    }
    
    @objc func loginAsGuestButtonTapped(){
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
//        pageDelegate?.didFinishPage(with: selectedItens)
        didTapLogInAsGuest = true
        pageDelegate?.goNextPage(fowardTo: pageModel.nextPage)
    }
    
}


extension LoginViewController: ViewCoding{
  
    func buildViewHierarchy() {
        view.addSubview(backgroundImage)
        view.addSubview(layerView)
        view.addSubview(titleLabel)
        view.addSubview(loginButton)
        view.addSubview(loginASGusetButton)
        view.addSubview(subTitleLabel)

    }
    func setupConstraints() {
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
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -80),
                                     titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     titleLabel.heightAnchor.constraint(equalToConstant: 100),
                                     titleLabel.widthAnchor.constraint(equalToConstant: 330)])
    
       
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([loginButton.heightAnchor.constraint(equalToConstant: 35),loginButton.widthAnchor.constraint(equalToConstant:220),
                                     loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),loginButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 80)])
        
        loginASGusetButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([loginASGusetButton.heightAnchor.constraint(equalToConstant: 35),loginASGusetButton.widthAnchor.constraint(equalToConstant:220),
                                     loginASGusetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),loginASGusetButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor,constant: 15)])
        
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        let width: CGFloat = UIScreen.main.bounds.width * 0.6
        NSLayoutConstraint.activate([subTitleLabel.topAnchor.constraint(equalTo: view.bottomAnchor,constant: -80),
                                     subTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     subTitleLabel.heightAnchor.constraint(equalToConstant: 40),
                                     subTitleLabel.widthAnchor.constraint(equalToConstant: width)])
        
    }
}
