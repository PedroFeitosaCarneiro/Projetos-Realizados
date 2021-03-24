//
//  CloudWorkerLogic.swift
//  quarto-mini-challenge
//
//  Created by Guilherme Martins Dalosto de Oliveira on 12/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation
import UIKit

protocol CloudWorkerLogic{
    func fetchUsers(completion: @escaping ([String],[Int],[Int],[String],[UIImage], [UIImage],[Int])-> Void)
}
