//
//  EnumTypesProtocol.swift
//  quarto-mini-challenge
//
//  Created by Bernardo Nunes on 13/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation

/// Protocol to make all enum type iterable and return a string with its name
protocol EnumTypesProtocol: CaseIterable {
    var getName: String { get }
}
