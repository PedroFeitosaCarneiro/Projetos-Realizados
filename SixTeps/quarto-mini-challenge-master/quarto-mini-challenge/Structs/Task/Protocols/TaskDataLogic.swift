//
//  TaskDataLogic.swift
//  quarto-mini-challenge
//
//  Created by Guilherme Martins Dalosto de Oliveira on 05/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation

public protocol TaskDataLogic{
    func saveTaskInCoreData()
    func deleteTaskInCoreData()
    func updateScoreInCoreData()
    func fetchTaskByUUID() -> TaskCD?
}
