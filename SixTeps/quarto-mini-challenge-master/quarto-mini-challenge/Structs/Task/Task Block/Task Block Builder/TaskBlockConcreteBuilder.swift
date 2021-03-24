//
//  TaskBlockConcreteBuilder.swift
//  quarto-mini-challenge
//
//  Created by Bernardo Nunes on 14/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation

class TaskBlockConcreteBuilder: TaskBlockBuilder {
    
    private(set) var tasks = [Task]()
    private var taskBlock = TaskBlock(createNew: true)
    
    init() {
        self.tasks = taskBlock.includedTasks
    }
    
    func addTask(task: Task) {
        if let index = self.tasks.firstIndex(where: { (iTask) -> Bool in
            return iTask == task
        }) {
            self.tasks.remove(at: index)
        }
      
        self.tasks.append(task)
        self.tasks.sort { (t1, t2) -> Bool in
            return t1.id_priority.rawValue < t2.id_priority.rawValue
        }
    }
    
    func reorderTasks(origin: Int, destination: Int) {
        let taskToMove = self.tasks[origin]
        
        tasks.remove(at: origin)
        tasks.insert(taskToMove, at: destination)
        
        
    }
    
    func buildTaskBlock() {
        self.taskBlock.insertTasksInTaskBlock(tasks: self.tasks)
        self.taskBlock.insertTaskBlockInCoreData()
    }
}
