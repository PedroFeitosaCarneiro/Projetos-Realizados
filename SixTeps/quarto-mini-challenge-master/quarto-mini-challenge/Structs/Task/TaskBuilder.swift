//
//  TaskBuilder.swift
//  quarto-mini-challenge
//
//  Created by Antonio Carlos on 05/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation


/// Builder protocol to build the task
public protocol TaskBuilder {
    
    func produceName(_ taskName: String?) throws
    func produceCategory(_ taskCategory: CategoryTaskType)
    func produceDifficulty(_ taskDifficulty: DifficultyType)
    func producePriority(_ taskPriority: PriorityType)
    
}
