//
//  DifficultyType.swift
//  quarto-mini-challenge
//
//  Created by Guilherme Martins Dalosto de Oliveira on 04/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation

public enum DifficultyType: Int16, EnumTypesProtocol{
    case Easy = 0;
    case Medium = 1;
    case Hard = 2;
    
    var getName: String {
        switch self {
        case .Easy:
            return NSLocalizedString("Easy", comment: "")
        case .Medium:
            return NSLocalizedString("MediumD", comment: "")
        case .Hard:
            return NSLocalizedString("Hard", comment: "")
        }
    }
}
