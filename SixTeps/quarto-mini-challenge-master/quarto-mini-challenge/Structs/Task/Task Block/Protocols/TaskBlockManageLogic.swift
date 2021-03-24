//
//  TaskBlockManageLogic.swift
//  quarto-mini-challenge
//
//  Created by Guilherme Martins Dalosto de Oliveira on 05/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation

protocol TaskBlockManageLogic{
    mutating func postPoneTask() -> [Task]
    mutating func actionTask(idTask: UUID, action: TaskActionsEnum)
    mutating func deleteTask(task: Task)
    
    func formatDateToString(date: Date) -> String
    func verifyTasksUncompletedInLastTaskBlock() -> [Task]
}
