//
//  ClearNavBarController.swift
//  IvyLeeStudy
//
//  Created by Bernardo Nunes on 19/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import UIKit

class ClearNavBarController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setClearNavBar()
    }
    
    func setClearNavBar(){
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.view.backgroundColor = .clear
    }
}
