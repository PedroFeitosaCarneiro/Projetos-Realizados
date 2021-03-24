//
//  ProfileViewController+PickerDelegate.swift
//  quarto-mini-challenge
//
//  Created by Guilherme Martins Dalosto de Oliveira on 04/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import UIKit

extension ProfileViewController: ImagePickerDelegate{
    func didSelect(image: UIImage?, tag: String?) {
        self.profilePhoto.image = image
    }
    
}
