//
//  TaskBlock.swift
//  quarto-mini-challenge
//
//  Created by Guilherme Martins Dalosto de Oliveira on 04/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation
import CoreData

struct TaskBlock: TaskBlockDataLogic, TaskBlockManageLogic{
    
    // Task Block Attributes
    private(set) var taskBlock_id: UUID = UUID()
    private(set) var includedTasks: [Task]  = [];
    private(set) var taskLimit: Int16 = 6
    private(set) var createdDate: Date = Date()
    
    //Initializers
    /// This initializer try to gets the task block in actual date and if cannot get then create a task block with the
    /// uncompleted tasks of the last task block created
    /// - Parameter currentDate: This parameter is the actual date of system
    /// - Author: Antônio Carlos
    public init(createNew: Bool) {
        
        if createNew {
            self.includedTasks = self.verifyTasksUncompletedInLastTaskBlock()
        } else {
            if let taskBlockCD = getTaskBlockCD() {
                self.taskBlock_id = taskBlockCD.taskBlock_uuid!
                self.taskLimit = taskBlockCD.difficulty_limit
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                self.createdDate = dateFormatter.date(from: taskBlockCD.creation_date!)!
                
                taskBlockCD.tasks_uuid?.forEach({ (id) in
                    self.includedTasks.append(Task(id_task: id))
                })
            }
        }

    }
    
    
    func getTaskBlockCD() -> TaskBlockCD? {
        
        let predicate = NSPredicate(format: "current == %@", NSNumber(value: true))
        let taskBlockCD = CoreDataManager.shared.fetch(TaskBlockCD.self, predicate: predicate, fetchLimit: nil)
        
        return taskBlockCD.first
    }
    
    // Task Block Methods
    mutating func postPoneTask() -> [Task]{
        var undoneTasks : [Task] = []
        var index : Int = 0
        for task in includedTasks{
            if !task.completed{
                undoneTasks.append(task)
                includedTasks.remove(at: index)
            }
            index += 1
        }
        return undoneTasks
    }
    
    mutating func actionTask(idTask: UUID, action: TaskActionsEnum){
        
        //Gets the task by uuid and skip the task
        guard var task = self.includedTasks.filter({$0.id_task == idTask}).first else {return}
        
        switch action {
            case .complete:
                task.completeTask()
                self.updateIncludedTasks(task: task)
            case .skip:
                task.skipTask()
                self.skipTask(task: task)
            case .delete:
                self.deleteTask(task: task)
                return
        }
    }
    
    mutating func skipTask(task: Task) {
        //Gets the task index
        guard let taskIndex = self.includedTasks.firstIndex(of: task) else {return}
        
        self.includedTasks.remove(at: taskIndex)
        
        if let taskCompletedIndex = self.includedTasks.compactMap({ (t) -> Int? in
            if(t.completed) {
                if let tIndex = self.includedTasks.firstIndex(of: t) {
                    return tIndex
                }
            }
            return nil
        }).first {
            self.includedTasks.insert(task, at: taskCompletedIndex)
        } else {
            self.includedTasks.append(task)
        }
        
        var tasksId = [UUID]()
        
        self.includedTasks.forEach { (t) in
            tasksId.append(t.id_task)
        }
        
        self.updateIncludedTasksInCoreData(tasksId: tasksId)
    }
    
    mutating func updateIncludedTasks(task: Task) {
        //Gets the task index
        guard let taskIndex = self.includedTasks.firstIndex(of: task) else {return}
        
        //Remove the task from array and append again to move to the last position
        self.includedTasks.remove(at: taskIndex)
        self.includedTasks.append(task)
        
        var tasksId = [UUID]()
        
        self.includedTasks.forEach { (t) in
            tasksId.append(t.id_task)
        }
        
        self.updateIncludedTasksInCoreData(tasksId: tasksId)
    }
    
    mutating func updateIncludedTasksInCoreData(tasksId: [UUID]) {
        //Fetch the taskblockCD
        guard let taskBlockCD = fetchTaskBlockByUUID() else {return}
        
        //Remove the task from array and append again to move to the last position
        taskBlockCD.tasks_uuid = tasksId
        
        CoreDataManager.shared.saveContext()
    }
    
    mutating func deleteTask(task: Task) {
        
        task.deleteTaskInCoreData()
        
        //Gets the task index
        guard let taskIndex = self.includedTasks.firstIndex(of: task) else {return}
        
        self.includedTasks.remove(at: taskIndex)
        
        var tasksId = [UUID]()
        
        self.includedTasks.forEach { (t) in
            tasksId.append(t.id_task)
        }
        
        self.updateIncludedTasksInCoreData(tasksId: tasksId)
    }
    
    public func getAmountOfUncompletedTasks() -> Int {
        let uncompletedTasks = self.includedTasks.compactMap { (t) -> Task? in
            if !t.completed{
                return t
            }
            return nil
        }
        
        return uncompletedTasks.count
    }
    
    
    /// This functions insert the task block in core data
    /// - Author: Antônio Carlos
    func insertTaskBlockInCoreData(){
        self.finishPreviousTaskBlock()
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        
        guard let usersEntity = NSEntityDescription.entity(forEntityName: "TaskBlockCD", in: managedContext) else { return }
        
        let object = NSManagedObject(entity: usersEntity, insertInto: managedContext) as! TaskBlockCD
        
        object.creation_date = self.formatDateToString(date: self.createdDate)
        object.difficulty_limit = self.taskLimit
        object.current = true
        
        var includedTasksUUID: [UUID] = []
        
        for task in self.includedTasks {
            includedTasksUUID.append(task.id_task)
        }
        
        object.tasks_uuid = includedTasksUUID
        object.taskBlock_uuid = self.taskBlock_id
        
        CoreDataManager.shared.saveContext()
    }
    
    private func finishPreviousTaskBlock() {
        guard let previousTaskBlock = self.getTaskBlockCD() else { return }
        let includedTaskIDS = self.includedTasks.map({$0.id_task})
        
        previousTaskBlock.tasks_uuid = previousTaskBlock.tasks_uuid?.compactMap({ (taskID) -> UUID? in
            if includedTaskIDS.contains(taskID) {
                return nil
            }
            return taskID
        })
        
        previousTaskBlock.current = false
    }
    
    
    /// This functions is to insert a new task in the TaskBlock
    /// - Parameter idTask: the Task ID of the new task
    mutating func insertTasksInTaskBlock(tasks: [Task]) {
        self.includedTasks = tasks
        self.includedTasks.forEach { (task) in
            task.saveTaskInCoreData()
        }
    }
    
    
    /// This functions format some date in dd-MM-yyyy and returns the formatted date as String
    /// - Parameter date: Some date
    /// - Returns: Formatted Date as String
    /// - Author: Antônio Carlos
    func formatDateToString(date: Date) -> String {
        let formatter = DateFormatter()
        
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "dd-MM-yyyy"
        
        let dateString = formatter.string(from: date) // string purpose I add here
        
        return dateString
    }
    
    
    /// This functions verifies if has some task uncompleted in the last task block to add in the current task block
    /// - Returns: Returns the uncompleted tasks, if exists
    /// - Author: Antônio Carlos
    //    func verifyTasksUncompletedInLastTaskBlock() -> [Task] {
    //
    //        var tasks: [Task] = []
    //
    //        //Gets the last task block inserted in coreData
    //        if let taskBlockCD = CoreDataManager.shared.fetch(TaskBlockCD.self, predicate: nil, fetchLimit: 1).first {
    //
    //            //Iterate over the tasks id and see if has any uncompleted and if has append to the array of tasks
    //            for taskUUID in taskBlockCD.tasks_uuid! {
    //                let task = Task(id_task: taskUUID)
    //
    //                if !task.completed {
    //                    tasks.append(task)
    //                }
    //            }
    //
    //            //Iterate over the tasks array and remove of the task block to add in the new.
    //            for task in tasks {
    //
    //                guard let taskIndex = taskBlockCD.tasks_uuid?.firstIndex(of: task.id_task) else {continue}
    //
    //                taskBlockCD.tasks_uuid?.remove(at: taskIndex)
    //            }
    //
    //            CoreDataManager.shared.saveContext()
    //        }
    //
    //        return tasks
    //    }
    
    func verifyTasksUncompletedInLastTaskBlock() -> [Task] {
        
        var tasks: [Task] = []
        
        //Gets the last task block inserted in coreData
        if let taskBlockCD = getTaskBlockCD() {
            
            //Iterate over the tasks id and see if has any uncompleted and if has append to the array of tasks
            for taskUUID in taskBlockCD.tasks_uuid! {
                let task = Task(id_task: taskUUID)
                
                if !task.completed {
                    tasks.append(task)
                } else {
                    break
                }
            }
        }
        
        return tasks
    }
    
    /// Fetch the task block by ID
    /// - Returns: Returns a TaskBlockCD if has one
    /// - Author: Antônio Carlos
    func fetchTaskBlockByUUID() -> TaskBlockCD? {
        
        let predicate = NSPredicate(format: "taskBlock_uuid == %@", self.taskBlock_id as CVarArg)
        
        return CoreDataManager.shared.fetch(TaskBlockCD.self, predicate: predicate, fetchLimit: nil).first
        
    }
}
