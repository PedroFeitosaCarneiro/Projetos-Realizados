//
//  ProfileViewController.swift
//  quarto-mini-challenge
//
//  Created by Bernardo Nunes on 01/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var imagePicker: Camera!
    @IBOutlet weak var profilePhoto: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // -- TESTE -- //
        let onboardingST = UIStoryboard(name: "Onboarding", bundle: nil)
        let onboardingVC = onboardingST.instantiateViewController(withIdentifier: "PageOneOnboardingViewController") as! PageOneOnboardingViewController
        self.navigationController?.present(onboardingVC, animated: true, completion: nil)
        // -- TESTE -- //
        

        self.imagePicker = Camera(presentationController: self, delegate: self as ImagePickerDelegate, tag: nil)
        
       // Set to CloudKit
    //    self.profilePhoto.image = UIImage(data: data)
      
    }
    
    @IBAction func takePicture(_ sender: UIButton) {
        self.imagePicker.present(from: sender as UIView)
    }
    
    
    
    
    
}
