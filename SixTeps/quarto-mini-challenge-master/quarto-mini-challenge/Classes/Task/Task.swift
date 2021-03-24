//
//  Task.swift
//  quarto-mini-challenge
//
//  Created by Guilherme Martins Dalosto de Oliveira on 04/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation
import CoreData

public struct Task{
    
    // Identifiers
    private var id_task: UUID = UUID();
    private var id_category: CategoryTaskType = .Others;
    private var id_priority: PriorityType = .Low;
    private var id_difficulty: DifficultyType = .Easy;
    
    // Task Attributes
    private var name: String = "";
    private var completed: Bool = false;
    private var numberCompleted: Int = 0;
    private var score: Int = 0;
    
    //Initializers
    public init() {}
    
    // Complete task
    public mutating func completeTask(){
        guard completed == false else {return}
        self.completed.toggle()
    }
    
    
    // Class Getters and Setters
    func getCompleted() -> Bool{
        return self.completed
    }
    mutating func setScore(){
        switch self.id_difficulty {
        case .Easy:
            score = Int.random(in: 0...1)
            break;
        case .Medium:
            score = Int.random(in: 2...3)
            break;
        case.Hard:
            score = Int.random(in: 4...5)
            break;
        }
        switch self.id_category {
        case .Work:
            self.score += 10;
        case .Health:
            self.score += 5;
        case .Recreation:
            self.score += 3;
        case .Studies:
            self.score += 7;
        case .Others:
            self.score += 5;
        }
    }
    
    mutating func setUUID(idTask: UUID) {
        self.id_task = idTask
    }
    
    mutating func setName(name: String) {
        self.name = name
    }
    
    mutating func setCategory(category: CategoryTaskType) {
        self.id_category = category
    }
    
    mutating func setPriority(priority: PriorityType) {
        self.id_priority = priority
    }
    
    mutating func setDifficulty(difficulty: DifficultyType) {
        self.id_difficulty = difficulty
    }
    
    mutating func saveInCoreData() {
        
        var taskCD: TaskCD = NSManagedObject(context: CoreDataManager.shared.persistentContainer.viewContext) as! TaskCD
        
        if let taskCoreData = fetchTasksByUUID() {
            
            self.numberCompleted = Int(taskCoreData.done_amount)
            self.id_task = taskCoreData.task_uuid!
            taskCD = taskCoreData
            
        }
        
        taskCD.category_id = self.id_category.rawValue
        taskCD.difficulty_id = self.id_difficulty.rawValue
        taskCD.priority_id = self.id_priority.rawValue
        taskCD.name = self.name
        taskCD.is_done = self.completed
        
        CoreDataManager.shared.saveContext()
        
    }
    
    func fetchTasksByUUID() -> TaskCD? {
        
        let tasks = CoreDataManager.shared.fetch(TaskCD.self)
        
        let task = tasks.filter({ $0.task_uuid == self.id_task })
        
        if task.isEmpty {
            return nil
        } else {
            return task.first!
        }
    }
    
    // Class score system
    mutating func penalizeTask(){
        
        if !self.completed{
            switch self.id_difficulty {
            case .Easy:
                self.score -= 1
            case .Medium:
                self.score -= 2
            case .Hard:
                self.score -= 3
                
            }
        }
        
    }
    
}
