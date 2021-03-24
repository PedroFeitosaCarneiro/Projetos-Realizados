//
//  ErrorHandling.swift
//  quarto-mini-challenge
//
//  Created by Antonio Carlos on 05/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation

public enum TaskError: Error  {
    case noValidName
    case emptyName
}
