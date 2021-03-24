//
//  PriorityType.swift
//  quarto-mini-challenge
//
//  Created by Guilherme Martins Dalosto de Oliveira on 04/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation

public enum PriorityType: Int16, EnumTypesProtocol{
    case High = 0;
    case Medium = 1;
    case Low = 2;
    
    var getName: String {
        switch self {
        case .High:
            return NSLocalizedString("High", comment: "")
        case .Medium:
            return NSLocalizedString("Medium", comment: "")
        case .Low:
            return NSLocalizedString("Low", comment: "")
        }
    }
}
