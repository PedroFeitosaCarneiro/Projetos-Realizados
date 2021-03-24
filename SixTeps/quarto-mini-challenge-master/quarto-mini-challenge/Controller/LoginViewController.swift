//
//  LoginViewController.swift
//  quarto-mini-challenge
//
//  Created by Bernardo Nunes on 14/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import UIKit
import SwiftUI
import AuthenticationServices

class LoginViewController: UIViewController {
    
    private let appUser = User()

    var currentController: UIViewController?
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var backgroundImgView: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSignInAppleButton()
        
        let deviceName = AutoLayout.getDeviceNameBasedOnProportion(viewSize: self.view.frame.size)
        if deviceName == "iphone8" {
            self.loginLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
            self.topConstraint.constant = 0
        }
        self.backgroundImgView.image = UIImage(named: "loginBackground-\(deviceName)")
        
        self.navigationController?.navigationBar.subviews.forEach({ (view) in
            view.removeFromSuperview()
        })
    }
    
    func setupSignInAppleButton() {
        
        let appleButton = ASAuthorizationAppleIDButton()
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        
        var height: CGFloat = 45
        var width:CGFloat = 289
        var bottomDist: CGFloat = -100
        
        if AutoLayout.getDeviceNameBasedOnProportion(viewSize: self.view.frame.size) == "iphone8"{
            height = 33
            width = 184
            bottomDist = -93
        }
        
        self.view.addSubview(appleButton)
        NSLayoutConstraint.activate([
            appleButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            appleButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: bottomDist),
            appleButton.heightAnchor.constraint(equalToConstant: height),
            appleButton.widthAnchor.constraint(equalToConstant: width)
        ])
        
        appleButton.addTarget(self, action: #selector(didTapAppleButton), for: .touchUpInside)
        
    }
    
    @objc func didTapAppleButton() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = []
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.delegate = self
        controller.presentationContextProvider = self
        
        controller.performRequests()
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
            case let credentials as ASAuthorizationAppleIDCredential:
                
                self.appUser.loginMultiplayer(userID: credentials.user) { (hasAccount) in
                    if hasAccount {
                        DispatchQueue.main.async {
                            self.presentAlert(userID: credentials.user)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.pushUsernameVC()
                        }
                    }
                }
                break
            
            default:
                break
        }
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error: ", error)
    }
    
    private func pushUsernameVC(){
        let storyboard = UIStoryboard(name: "Username", bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() as? UsernameViewController else { return }
        vc.didJustLogin = true
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func presentAlert(userID: String) {
        let alertController = UIAlertController(title: NSLocalizedString("warningAccount", comment: ""), message: NSLocalizedString("warningAccountRequest", comment: ""), preferredStyle: .alert)
        
        let overrideAction = UIAlertAction(title: NSLocalizedString("keepAccount", comment: ""), style: .default) { (_) in
            self.appUser.overrideUser(userID: userID)
            self.pushRankingVC()
        }
        
        let updateAction = UIAlertAction(title: NSLocalizedString("createAccount", comment: ""), style: .default) { (_) in
            self.appUser.updateUserCK {}
            self.pushUsernameVC()
        }
        
        alertController.addAction(overrideAction)
        alertController.addAction(updateAction)
        
        self.present(alertController, animated: true)
    }
    
    private func pushRankingVC() {
        
        var taskVCOut: TasksViewController? = nil
        var taskVCIndex: Int? = 0

        self.navigationController?.viewControllers.forEach({ (vc) in
            if let taskVC = vc as? TasksViewController {
                taskVCOut = taskVC
                taskVCIndex = self.navigationController!.viewControllers.firstIndex(of: taskVC)
            }
        })

        self.navigationController!.viewControllers.remove(at: taskVCIndex!)
        self.navigationController?.viewControllers.append(taskVCOut!)
        
        let hostingController = UIHostingController(rootView: RankingView())
        hostingController.title = "Ranking"
        self.navigationController?.pushViewController(hostingController, animated: true) 
        let viewCount = self.navigationController!.viewControllers.count
        self.navigationController?.viewControllers.removeFirst(viewCount-1)
    }
    
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    
}
