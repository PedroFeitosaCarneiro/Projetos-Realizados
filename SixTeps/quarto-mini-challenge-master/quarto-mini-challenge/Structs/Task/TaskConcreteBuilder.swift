//
//  TaskConcreteBuilder.swift
//  quarto-mini-challenge
//
//  Created by Antonio Carlos on 05/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation

public class TaskConcreteBuilder: TaskBuilder {
    
    //Parameters
    public var task = Task()
    
    //Initialiazers
    public init() {}
    
    //MARK: - TaskBuilder Functions
    
    /// Produces Task Id
    /// - Parameter taskId: Task Id of type UUID
    public func produceUUID(_ taskId: UUID) {
        task.setUUID(idTask: taskId)
    }
    
    
    /// Produces the Task Name
    /// - Parameter taskName: Task Name of type String
    /// - Throws: Throws an noValidName error if the name is empty
    /// - Author: Antonio Carlos
    public func produceName(_ taskName: String?) throws {
        try task.setName(name: taskName)
    }
    
    /// Produces the Task Category
    /// - Parameter taskCategory: Task Category of type CategoryTaskType
    /// - Author: Antonio Carlos
    public func produceCategory(_ taskCategory: CategoryTaskType) {
        task.setCategory(category: taskCategory)
    }
    
    
    /// Produces the Task Difficulty
    /// - Parameter taskDifficulty: Task Difficulty of type DifficultyType
    /// - Author: Antonio Carlos
    public func produceDifficulty(_ taskDifficulty: DifficultyType) {
        task.setDifficulty(difficulty: taskDifficulty)
    }
    
    
    /// Produces the Task Priority
    /// - Parameter taskPriority: Task Priority of type PriorityType
    /// - Author: Antonio Carlos
    public func producePriority(_ taskPriority: PriorityType) {
        task.setPriority(priority: taskPriority)
    }
    
    //MARK: - Functions
    
    /// Builds the task
    /// - Returns: Return a task of type Task
    public func build() -> Task {
        //Set the score
        task.setScore()
        
        return task
    }
    
}
