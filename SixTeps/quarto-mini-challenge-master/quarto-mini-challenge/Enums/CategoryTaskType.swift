//
//  CategoryTaskType.swift
//  quarto-mini-challenge
//
//  Created by Guilherme Martins Dalosto de Oliveira on 04/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation

public enum CategoryTaskType: Int16, EnumTypesProtocol{
    case Work = 0;
    case Studies = 1;
    case Health = 2;
    case Recreation = 3;
    case Others = 4;
    
    var maxPoints: Int {
        switch self {
        case .Work:
            return 15
        case .Studies:
            return 12
        case .Health:
            return 10
        case .Recreation:
            return 8
        case .Others:
            return 10
        }
    }
    
    var getName: String {
        switch self {
        case .Work:
         return NSLocalizedString("Work",comment:"")
        case .Studies:
          return NSLocalizedString("Studies",comment:"")
        case .Health:
            return NSLocalizedString("Health",comment:"")
        case .Recreation:
            return NSLocalizedString("Entertainment",comment:"")
        case .Others:
            return NSLocalizedString("Others",comment:"")
        }
    }
}
