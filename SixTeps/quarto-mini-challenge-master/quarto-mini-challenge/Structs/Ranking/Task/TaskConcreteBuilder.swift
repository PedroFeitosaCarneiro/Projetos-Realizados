//
//  TaskConcreteBuilder.swift
//  quarto-mini-challenge
//
//  Created by Antonio Carlos on 05/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation

public class TaskConcreteBuilder: TaskBuilder {
    
    public var task = Task()
    
    public init() {}
    
    public func reset() {
        self.task = Task()
    }
    
    public func produceUUID(_ taskId: UUID) {
        task.setUUID(idTask: taskId)
    }
    
    public func produceName(_ taskName: String) {
        task.setName(name: taskName)
    }
       
    public func produceCategory(_ taskCategory: CategoryTaskType) {
        task.setCategory(category: taskCategory)
    }
    
    public func produceDifficulty(_ taskDifficulty: DifficultyType) {
        task.setDifficulty(difficulty: taskDifficulty)
    }
    
    public func producePriority(_ taskPriority: PriorityType) {
        task.setPriority(priority: taskPriority)
    }
    
    public func build() -> Task {
        var task = self.task
        task.setScore()
        task.saveInCoreData()
        self.reset()
        return task
    }
    
}
