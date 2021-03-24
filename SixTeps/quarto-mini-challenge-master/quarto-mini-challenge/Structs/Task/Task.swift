//
//  Task.swift
//  quarto-mini-challenge
//
//  Created by Guilherme Martins Dalosto de Oliveira on 04/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation
import CoreData

public struct Task: TaskManageLogic, TaskDataLogic{
    
    // Identifiers
    private(set) var id_task: UUID = UUID();
    private(set) var id_category: CategoryTaskType = .Others;
    private(set) var id_priority: PriorityType = .Low;
    private(set) var id_difficulty: DifficultyType = .Easy;
    
    // Task Attributes
    private(set) var name: String = "";
    private(set) var completed: Bool = false;
    private(set) var numberCompleted: Int16 = 0;
    private(set) var score: Int16 = 0;
    
    var delegate: NotifyUserProtocol?
    
    //Initializers
    public init() {}
    
    /// This initializer is used when already has a task and needs to instatiate a Struct Task
    /// - Parameter id_task: The Task ID of type UUID
    ///- Author: Antonio Carlos
    public init(id_task: UUID) {
        self.id_task = id_task
        if let taskCD = self.fetchTaskByUUID() {
            self.id_category = CategoryTaskType(rawValue: taskCD.category_id)!
            self.id_priority = PriorityType(rawValue: taskCD.priority_id)!
            self.id_difficulty = DifficultyType(rawValue: taskCD.difficulty_id)!
            self.name = taskCD.name!
            self.completed = taskCD.is_done
            self.numberCompleted = taskCD.done_amount
            self.score = taskCD.score
        }
    }
    
    // MARK: - Task Data Logic functions
    
    
    /// This  fuction save the task in CoreData
    ///- Author: Antonio Carlos
    public func saveTaskInCoreData(){
        //Gets the managedContext
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        
        //Get the entity by name
        guard let usersEntity = NSEntityDescription.entity(forEntityName: "TaskCD", in: managedContext) else {return}
        
        //Creates the object by entity and context
        let object = NSManagedObject(entity: usersEntity, insertInto: managedContext) as! TaskCD
        
//        //Verify if the task already has in CoreData
//        if let taskCD = fetchTaskByUUID() {
//
//            //Set the completed number and the task id
//            self.numberCompleted = taskCD.done_amount
//            //Set the object as the taskCD
//            object = taskCD
//        }
        
        //Set the taskCD variables
        object.task_uuid = self.id_task
        object.category_id = self.id_category.rawValue
        object.difficulty_id = self.id_difficulty.rawValue
        object.priority_id = self.id_priority.rawValue
        object.name = self.name
        object.is_done = self.completed
        object.done_amount = self.numberCompleted
        
        //Save context
        CoreDataManager.shared.saveContext()
    }
    
    
    /// This function delete the task in CoreData
    /// - Author: Antonio Carlos
    public func deleteTaskInCoreData(){
        //Get the task by UUID
        guard let taskCD = self.fetchTaskByUUID() else {return}
        //Delete the task
        CoreDataManager.shared.delete(taskCD)
    }
    
    
    /// This functions updates the score of the task in CoreData
    /// - Author: Antonio Carlos
    public func updateScoreInCoreData(){
        //Get the task by UUID
        guard let taskCD = self.fetchTaskByUUID() else {return}
        //Update Score
        taskCD.score = Int16(self.score)
        //Save context
        CoreDataManager.shared.saveContext()
    }
    
    
    /// This function fetch the task by his UUID
    /// - Returns: This return is of type TaskCD? and it is optional because when we cannot found the task by the UUID, then will return nil.
    /// - Author: Antonio Carlos
    public func fetchTaskByUUID() -> TaskCD? {
        let predicate = NSPredicate(format: "task_uuid == %@", self.id_task as CVarArg)
        
        let tasks = CoreDataManager.shared.fetch(TaskCD.self, predicate: predicate, fetchLimit: nil)
        
        if tasks.isEmpty {
            return nil
        } else {
            return tasks.first!
        }
    }
    
    
    // MARK: - Getters and Setters
    
    /// Sets the Task Id
    /// - Parameter idTask: Task Id of type UUID
    /// - Author: Antonio Carlos
    mutating func setUUID(idTask: UUID) {
        self.id_task = idTask
    }
    
    
    /// Sets the Task Name
    /// - Parameter name: Task Name of type String
    /// - Author: Antonio Carlos
    mutating func setName(name: String?) throws {
        guard let name = name?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty else { throw TaskError.emptyName }
        
        if name.count > 35 {
            throw TaskError.noValidName
        } else {
            self.name = name
        }
    }
    
    /// Sets the Task Category
    /// - Parameter category: Task Category of type CategoryTaskType
    /// - Author: Antonio Carlos
    mutating func setCategory(category: CategoryTaskType) {
        self.id_category = category
    }
    
    /// Sets the Task Priority
    /// - Parameter priority: Task Priority of type PriorityType
    /// - Author: Antonio Carlos
    mutating func setPriority(priority: PriorityType) {
        self.id_priority = priority
    }
    

    /// Sets the Task Difficulty
    /// - Parameter difficulty: Task Difficulty of type DifficultyType
    mutating func setDifficulty(difficulty: DifficultyType) {
        self.id_difficulty = difficulty
    }
    
    
    // MARK: - Task Manage Logic
    
    
    /// This function complete the task and save in core data
    public mutating func completeTask(){
        guard completed == false else {return}
        self.completed.toggle()
        self.delegate = User()
        self.setScore()
        self.delegate?.sendCompletedTask(score: self.score, category: self.id_category)
        
        guard let taskCD = self.fetchTaskByUUID() else { return }
    
        
        taskCD.is_done = self.completed
        
        CoreDataManager.shared.saveContext()
    }
    
    public mutating func setScore(){
        switch self.id_difficulty {
        case .Easy:
            score = Int16.random(in: 0...1)
            break;
        case .Medium:
            score = Int16.random(in: 2...3)
            break;
        case.Hard:
            score = Int16.random(in: 4...5)
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
    
    public mutating func penalizeTask(){
        
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
    
    public mutating func skipTask() {
        self.penalizeTask()
        self.updateScoreInCoreData()
    }
    
    // MARK: - Delegate Implementation
    func sendToUser(){
        guard completed == true else {return}
        delegate?.sendCompletedTask(score: self.score, category: self.id_category)
    }
    
    
}

//Extension to conform to the Equatable Protocol
extension Task: Equatable {
    
    public static func == (lhs: Task, rhs: Task) -> Bool {
        if(lhs.id_task == rhs.id_task) {
            return true
        } else {
            return false
        }
    }
    
}
