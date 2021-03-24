//
//  SettingsViewController.swift
//  quarto-mini-challenge
//
//  Created by Bernardo Nunes on 01/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var settingsTableView: UITableView!
    private let settingsTittles = ["Nome","Notificações","Sons","Feedback Tátil","Limite de tarefas diárias","Suporte ao usuário","Termos e condições"]
    
    private let settingsUsername = UITextField(frame: CGRect(x: 210, y: 11, width: 176, height: 21))
    
    private let settingsNotificacaoSwitch = UISwitch(frame: CGRect(x: 345, y: 6, width: 49, height: 31))
    private let settingsSonsSwitch = UISwitch(frame: CGRect(x: 345, y: 6, width: 49, height: 31))
    private let settingsFeedbackSwitch = UISwitch(frame: CGRect(x: 345, y: 6, width: 49, height: 31))
    
    private var settingsSwitchs : [UISwitch] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSwitch()
        setupUsername()
        
        // Do any additional setup after loading the view.
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
    }
    
    @objc func switchToggle(_ switchTouched: UISwitch) {
        
        switch switchTouched {
        case settingsNotificacaoSwitch:
            print("notificaceos")
            //NOTIFICATIONS
            break
        case settingsSonsSwitch:
            print("sons")
            //SOUNDS
            break
        case settingsFeedbackSwitch:
            print("feedback")
            //FEEDBACK
            break
            
        default:
            break
        }
        
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
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
            cell.selectionStyle = .none
            
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
        emailComposer.setSubject("Suporte Versão 1.0")
    }
    
}
