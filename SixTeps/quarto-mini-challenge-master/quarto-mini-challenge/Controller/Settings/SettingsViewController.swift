//
//  SettingsViewController.swift
//  quarto-mini-challenge
//
//  Created by Bernardo Nunes on 01/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController, UITextFieldDelegate, UIActionSheetDelegate {
    
    //LoadingView
    @IBOutlet weak var view_Loading: UIView!
    @IBOutlet weak var loadingBlockOne: UIView!
    @IBOutlet weak var loadingBlockTwo: UIView!
    @IBOutlet weak var loadingBlockThree: UIView!
    @IBOutlet weak var blueEffectView: UIVisualEffectView!
    
    var value : Bool = false
    var pos = 0
    var blocks : [UIView] = []
    
    
    var UD: UserDefaultLogic?
    
    let selectionController = UIAlertController(title: NSLocalizedString("background", comment: ""), message: NSLocalizedString("chooseOption", comment: ""), preferredStyle: .actionSheet)
    let solidColorController = UIAlertController(title: NSLocalizedString("background", comment: ""), message: NSLocalizedString("chooseOption", comment: ""), preferredStyle: .actionSheet)
    
    @IBOutlet weak var userBackgroundImage: UIImageView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var settingsTableView: UITableView!
    private let settingsTittles = [NSLocalizedString("Name", comment: ""),NSLocalizedString("Notifications", comment: "")]
    
    private let settingsUsername = UITextField(frame: CGRect(x: UIScreen.main.bounds.width - 130, y: 11, width: 176, height: 21))
    
    private let settingsNotificacaoSwitch = UISwitch(frame: CGRect(x: UIScreen.main.bounds.width - 80, y: 6, width: 49, height: 31))
    private let settingsSonsSwitch = UISwitch(frame: CGRect(x: UIScreen.main.bounds.width - 80, y: 6, width: 49, height: 31))
    private let settingsFeedbackSwitch = UISwitch(frame: CGRect(x: UIScreen.main.bounds.width - 80, y: 6, width: 49, height: 31))
    
    private var settingsSwitchs : [UISwitch] = []
    
    private var userReference = User()
    
    weak var settingsPictureDelegate : settingsPictureDelegate?
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.settingsTableView.backgroundColor = UIColor(named: "BackgroundWhite")
        self.view.backgroundColor = UIColor(named: "BackgroundWhite")
        self.navigationItem.title = NSLocalizedString("settings", comment: "")
        self.navigationItem.largeTitleDisplayMode = .always
        userBackgroundImage.contentMode = .scaleAspectFill
        
        UD = UserDefaultLogic()
        setupUserImage()
        setupSwitch()
        setupUsername()
        setupAlertControllers()
        imagePicker.delegate = self
        settingsUsername.delegate = self
        
        blocks = [loadingBlockOne, loadingBlockTwo, loadingBlockThree]
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    
    
    func setupAlertControllers(){
        let galeryAction = UIAlertAction(title: NSLocalizedString("gallery", comment: ""), style: .default) { (action) in
                self.pickImageFromAlbum()
            
        }
        let exitAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel) { (action) in }
        
        let solidColorsAction = UIAlertAction(title: NSLocalizedString("solidColors", comment: ""), style: .default) { (action) in
            self.present(self.solidColorController, animated: true, completion: nil)
        }
        let blueAction = UIAlertAction(title: NSLocalizedString("lightBlue", comment: ""), style: .default) { (action) in
            self.userBackgroundImage.image = UIImage(named: "backGroundBlue")
        }
        let darkBlueAction = UIAlertAction(title: NSLocalizedString("darkBlue", comment: ""), style: .default) { (action) in
            self.userBackgroundImage.image = UIImage(named: "backGroundDarkBlue")
        }
        let redAction = UIAlertAction(title: NSLocalizedString("red", comment: ""), style: .default) { (action) in
            self.userBackgroundImage.image = UIImage(named: "backGroundRed")
        }
        let yellowAction = UIAlertAction(title: NSLocalizedString("yellow", comment: ""), style: .default) { (action) in
            self.userBackgroundImage.image = UIImage(named: "backGroundYellow")
        }
        let greenAction = UIAlertAction(title: NSLocalizedString("green", comment: ""), style: .default) { (action) in
            self.userBackgroundImage.image = UIImage(named: "backGroundGreen")
        }
        let exitColorsAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel) { (action) in
        }
        
        
        selectionController.addAction(galeryAction)
        selectionController.addAction(exitAction)
        selectionController.addAction(solidColorsAction)
        
        solidColorController.addAction(blueAction)
        solidColorController.addAction(darkBlueAction)
        solidColorController.addAction(redAction)
        solidColorController.addAction(yellowAction)
        solidColorController.addAction(greenAction)
        solidColorController.addAction(exitColorsAction)
    }
    
    
    func waitingViewCalled(){
        animate(block: blocks, continue: self.value, pos: self.pos)
    }
    
    func animate(block: [UIView], continue: Bool, pos: Int){
        UIView.animate(withDuration: 0.2, animations: {
            if (block[pos].backgroundColor != .white){
                block[pos].backgroundColor = .white
            } else {
                block[pos].backgroundColor = .purple
            }
            self.pos = pos + 1;
            if self.pos > 2 {
                self.pos = 0
            }
        }) { (v) in
            if self.value == true{
                self.animate(block: block, continue: self.value, pos: self.pos)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.settingsUsername.resignFirstResponder()
        return true
    }
    
    
    @objc func keyboardWillDisappear() {
        
        guard let username = settingsUsername.text?.filter({ !$0.isNewline && !$0.isWhitespace }) else { return }
        
        if username.isEmpty || username.count > 10 {
            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("emptyField", comment: ""), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {

            userReference.setUsername(username: username) { (result) in
                DispatchQueue.main.async {
                    
                    if result {
                        UIView.animate(withDuration: 0.5, animations: {
                            self.blueEffectView.alpha = 0
                        }) { (done) in
                            self.blocks.forEach(){$0.backgroundColor = .purple}
                            self.pos = 0
                            self.value = false
                        }
                    } else {
                        let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("nameRegistered", comment: ""), preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                        
                        UIView.animate(withDuration: 0.5, animations: {
                            self.blueEffectView.alpha = 0
                        }) { (done) in
                            self.blocks.forEach(){$0.backgroundColor = .purple}
                            self.pos = 0
                            self.value = false
                            self.settingsUsername.text = ""
                        }
                    }
                    
                }
                
            }
            
            UIView.animate(withDuration: 0.5, animations: {
                self.blueEffectView.alpha = 1
            }) { (done) in
                self.value = true
                self.animate(block: self.blocks, continue: self.value, pos: self.pos)
            }
            
            
            
            
        }
    }
    
    func pickImageFromAlbum(){
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing =  true
        imagePicker.title = "background"
        present(imagePicker, animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = settingsUsername.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 10
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.subviews.forEach({ (subView) in
            subView.removeFromSuperview()
        })
        
        if userReference.username != nil {
            settingsUsername.text = userReference.username!
        } else {
            settingsUsername.text = UD!.userName
        }
        
        
        settingsNotificacaoSwitch.setOn(UD!.userNotification, animated: false)
        settingsSonsSwitch.setOn(UD!.soundStatus, animated: false)
        settingsFeedbackSwitch.setOn(UD!.feedbackStatus, animated: false)
        
        if userReference.backgroundPhoto != nil {
            userBackgroundImage.image = UIImage(data: userReference.backgroundPhoto!)
        }
        
    }
    
    @IBAction func chageProfilePhoto(_ sender: Any) {
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing =  true
        imagePicker.title = "profile"
        present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    
    private func setupUserImage(){
        userProfileImage.layer.cornerRadius = 30
        userProfileImage.layer.masksToBounds = true
        userProfileImage.clipsToBounds = true
        
        if userReference.profilePic != nil {
            userProfileImage.image = UIImage(data: userReference.profilePic!)
        }
        
        
        
        
        userBackgroundImage.layer.cornerRadius = 30
        userBackgroundImage.layer.masksToBounds = true
        userBackgroundImage.clipsToBounds = true
    }
    
    
    
    
    
    private func setupSwitch(){
        settingsSwitchs = [settingsNotificacaoSwitch,settingsSonsSwitch, settingsFeedbackSwitch]
        
        for settingSwitch in settingsSwitchs{
            settingSwitch.addTarget(self, action: #selector(switchToggle), for: .touchUpInside)
        }
        
    }
    
    private func setupUsername(){
        settingsUsername.textAlignment = .left
        settingsUsername.borderStyle = .none
        settingsUsername.placeholder = NSLocalizedString("placeusername", comment: "")
    }
    
    @objc func switchToggle(_ switchTouched: UISwitch) {
        
        switch switchTouched {
        case settingsNotificacaoSwitch:
            UD?.userNotification = !(UD!.userNotification)
            //NOTIFICATIONS
            break
        case settingsSonsSwitch:
            UD?.soundStatus = !(UD!.soundStatus)
            //SOUNDS
            break
        case settingsFeedbackSwitch:
            UD?.feedbackStatus = !(UD!.feedbackStatus)
            //FEEDBACK
            break
            
        default:
            break
        }
        
        
    }
    
    
    @IBAction func edittingBackGround(_ sender: Any) {
        self.present(selectionController, animated: true, completion: nil)
        
        
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        UD?.userName = settingsUsername.text ?? "SKIDROW"
        UD?.userNotification = settingsNotificacaoSwitch.isOn
        UD?.soundStatus = settingsSonsSwitch.isOn
        UD?.feedbackStatus = settingsFeedbackSwitch.isOn
        
        settingsPictureDelegate?.sendBackGroundProfilePic(image: userBackgroundImage.image ?? UIImage(imageLiteralResourceName: "defaultImage"))
        

        
        userReference.updateBackgroundPhoto(backgroundPhoto: userBackgroundImage.image)
        
        userReference.updatePic(profilePic: userProfileImage.image)
        
        UD?.userName = settingsUsername.text ?? NSLocalizedString("placeusername", comment: "")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        userBackgroundImage.image = nil
        userProfileImage.image = nil
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)        
    }
    
}


extension SettingsViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsTittles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SettingsTableViewCell
        cell.settingTittleLabel.text = settingsTittles[indexPath.row]
        
        if indexPath.row == 0 {
            cell.addSubview(settingsUsername)
            cell.selectionStyle = .none
        }
        
        if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3{
            cell.addSubview(settingsSwitchs[indexPath.row-1])
            //     settingsSwitchs[indexPath.row-1].centerXAnchor.constraint(equalTo: cell.rightAnchor,constant: 10).isActive = true
            cell.selectionStyle = .none
            updateViewConstraints()
        }
        
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 4:
            //Present View de taregas diárias
            break
        case 5:
            //Email System
            emailSupportView()
            break
        case 6:
            //Present View de termos e condições
            break
        default:
            print("Itens not reactive")
            break
        }
        
        
        
    }
    
    
}


extension SettingsViewController : MFMailComposeViewControllerDelegate{
    
    private func emailSupportView(){
        
        guard MFMailComposeViewController.canSendMail() else {return}
        let emailComposer = MFMailComposeViewController()
        emailComposer.mailComposeDelegate = self
        emailComposer.setToRecipients(["NossoEmailEntraAqui@academy.com"])
        emailComposer.setSubject(NSLocalizedString("UserSupportVersion", comment: ""))
    }
    
}

extension SettingsViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            if picker.title == "profile"{
                userProfileImage.image = image
            } else if picker.title == "background" {
                userBackgroundImage.image = image
            }
        }
        dismiss(animated: true, completion: nil)
    }
}


