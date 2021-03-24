//
//  UsernameViewController.swift
//  quarto-mini-challenge
//
//  Created by Bernardo Nunes on 18/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import SwiftUI
import UIKit

class UsernameViewController: UIViewController, ImagePickerDelegate {
   
    //MARK: - Porperties
    private let user = User()
    private var profileImage: UIImage? = nil
    private var backgroundImg: UIImage? = nil
    private var profileImgPicker: Camera?
    private var backgroundImgPicker: Camera?
    var didJustLogin: Bool?
    var currentController: UIViewController?
    
    //MARK: - IBOutlets
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var usernameBorderView: UIView!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var bakgroundImageView: UIImageView!
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainStackView: UIStackView!
    
    //MARK: - View Life Cycle
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImgView.backgroundColor = .clear
        
        self.bakgroundImageView.contentMode = .scaleAspectFill
        
        if AutoLayout.getDeviceNameBasedOnProportion(viewSize: self.view.frame.size) == "iphone8" {
            self.stackViewTopConstraint.constant = 28
            self.mainStackView.spacing = 48
        }
        
        //Display Settings
        self.profileImgPicker = Camera(presentationController: self, delegate: self, tag: "profile")
        self.backgroundImgPicker = Camera(presentationController: self, delegate: self, tag: "background")
        self.bakgroundImageView.layer.cornerRadius = 10
        self.profileImgView.layer.cornerRadius = 10
        self.usernameBorderView.layer.cornerRadius = 25
        self.usernameBorderView.layer.borderWidth = 0.5
        self.usernameBorderView.layer.borderColor = CGColor(srgbRed: 112/255, green: 112/255, blue: 112/255, alpha: 1)
        
        let deviceName = AutoLayout.getDeviceNameBasedOnProportion(viewSize: self.view.frame.size)
        self.startBtn.setBackgroundImage(UIImage(named: "start-button-\(deviceName)"), for: .normal)
        self.startBtn.setTitle(NSLocalizedString("Start", comment: ""), for: .normal)
        self.startBtn.titleLabel?.font = UIFont(name: "Helvetica Neue Medium", size: 20)
        self.startBtn.titleLabel?.textAlignment = .center
        self.startBtn.titleEdgeInsets = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0)
        
        //Keyboard Settings
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //Nav bar settings
        self.navigationController?.navigationBar.subviews.forEach({ (view) in
            view.removeFromSuperview()
        })
        let notNowBarButton = UIBarButtonItem(title: NSLocalizedString("notNow", comment: ""), style: .plain, target: self, action: #selector(didPressNotNow))
        
        self.navigationItem.setRightBarButton(notNowBarButton, animated: true)
        self.navigationItem.hidesBackButton = true
        
        //Setting fields
        if let profilePic = user.profilePic {
            self.profileImgView.image = UIImage(data: profilePic)
            self.profileImage = UIImage(data: profilePic)
        }
        
        if let backgroundImg = user.backgroundPhoto {
            self.backgroundImg = UIImage(data: backgroundImg)
            self.bakgroundImageView.image = UIImage(data: backgroundImg)
        }
        
        if let username = user.username {
            self.usernameTF.text = username
        }
        
        self.profileImgView.layer.cornerRadius = 30
        self.profileImgView.clipsToBounds = true
        
        self.bakgroundImageView.backgroundColor =  UIColor(rgb: 0xDDDDDD)
    }
    
    //MARK: - Methods
     @objc private func didPressNotNow() {
        guard let vcCount = navigationController?.viewControllers.count else { return }
        if let didJustLogin = self.didJustLogin, didJustLogin {
            if let tasksVC = (navigationController?.viewControllers[vcCount-3]) {
                self.navigationController?.popToViewController(tasksVC, animated: true)
            }
        } else {
            if let tasksVC = (navigationController?.viewControllers[vcCount-2]) {
                self.navigationController?.popToViewController(tasksVC, animated: true)
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 1) {
                self.stackViewTopConstraint.constant -= keyboardSize.height
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 1) {
            var constant: CGFloat = 42
            if AutoLayout.getDeviceNameBasedOnProportion(viewSize: self.view.frame.size) == "iphone8" {
                constant = 28
            }
            self.stackViewTopConstraint.constant = constant
            self.view.layoutIfNeeded()
        }
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
        self.navigationController?.removeViewController(LoginViewController.self)
        self.navigationController?.removeViewController(UsernameViewController.self)
    }
    
    func didSelect(image: UIImage?, tag: String?) {
        if tag == "profile"{
            self.profileImage = image
            if let newImage = image{
                self.profileImgView.image = newImage
            } else {
                self.profileImgView.image = UIImage(named: "userProfilePic")
            }
        } else if tag == "background" {
            self.backgroundImg = image
            if let newImage = image{
                self.bakgroundImageView.image = newImage
            } else {
                self.bakgroundImageView.image = nil
            }
        }
    }
    
    //MARK: - IBActions
    @IBAction func changeProfileImage(_ sender: Any) {
        self.profileImgPicker?.present(from: self.view)
    }
    
    @IBAction func changeBackgroundPhoto(_ sender: Any) {
        self.backgroundImgPicker?.present(from: self.view)
    }
    
    @IBAction func didPressStart(_ sender: Any) {
        guard let username = self.usernameTF.text?.filter({ !$0.isNewline && !$0.isWhitespace }), !username.isEmpty else { return }
        
        if username.count > 10 {
            return
        }
        
        let lowerCaseUsername = username.lowercased()
        user.setUsername(username: lowerCaseUsername) { (didSet) in
            if didSet{
                self.user.updatePic(profilePic: self.profileImage)
                self.user.updateBackgroundPhoto(backgroundPhoto: self.backgroundImg)
                DispatchQueue.main.async {
                    self.pushRankingVC()
                }
            } else {
                print("username invalido")
            }
        }
    }
}


extension UINavigationController {

    func removeViewController(_ controller: UIViewController.Type) {
        if let viewController = viewControllers.first(where: { $0.isKind(of: controller.self) }) {
            viewController.removeFromParent()
        }
    }
}
