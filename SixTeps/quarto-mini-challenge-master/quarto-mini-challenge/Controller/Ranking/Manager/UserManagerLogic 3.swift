//
//  UserManagerLogic.swift
//  quarto-mini-challenge
//
//  Created by Guilherme Martins Dalosto de Oliveira on 12/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation

protocol UserManagerLogic{    
    func execOrderAndValueSwitch(users: [UserStandard]) -> [UserStandard]
    func transformDataIntoUserStandard(users: [String], level: [Int],tasks: [Int]) -> [UserStandard]
}
