//
//  DivisionType.swift
//  quarto-mini-challenge
//
//  Created by Guilherme Martins Dalosto de Oliveira on 04/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation

enum DivisionType: Int16, EnumTypesProtocol{
    case Estagiário = 0;
    case Junior = 1;
    case Pleno = 2;
    case Senior = 3;
    case Diretor = 4;
    case Gerente = 5;
    
    var getName: String {
        switch self {
        case .Estagiário:
            return NSLocalizedString("estagiario", comment: "")
        case .Junior:
            return NSLocalizedString("junior", comment: "")
        case .Pleno:
            return NSLocalizedString("pleno", comment: "")
        case .Senior:
            return NSLocalizedString("senior", comment: "")
        case .Diretor:
            return NSLocalizedString("diretor", comment: "")
        case .Gerente:
            return NSLocalizedString("ceo", comment: "")
        }
    }
}
