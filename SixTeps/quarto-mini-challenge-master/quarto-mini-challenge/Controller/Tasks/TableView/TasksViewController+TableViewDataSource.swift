//
//  TasksViewController+TableViewDataSource.swift
//  quarto-mini-challenge
//
//  Created by Antonio Carlos on 08/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import UIKit

extension TasksViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.editionMode {
            return 1
        } else {
            if self.taskBlock.includedTasks.count > self.taskBlock.taskLimit {
                self.tasksTableView.isScrollEnabled = true
            }
            
            return self.taskBlock.includedTasks.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.editionMode {
            return 6
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.editionMode {
            guard let taskBlockBuilder = self.taskBlockBuilder else {return}
            
            if indexPath.row > taskBlockBuilder.tasks.count-1 {
                self.presentWith(task: nil)
            } else {
                self.presentWith(task: taskBlockBuilder.tasks[indexPath.row])
            }
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.editionMode {
            
            guard let taskBlockBuilder = self.taskBlockBuilder else {return UITableViewCell()}
            let deviceName = AutoLayout.getDeviceNameBasedOnProportion(viewSize: self.view.frame.size)
            
            if indexPath.row > taskBlockBuilder.tasks.count-1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell") as! EmptyTableViewCell
                
                cell.setLayout(cellSpacingHeight: self.cellSpacingHeight, deviceName: deviceName)
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCellEditing") as! TaskCellEditing
                
                
                
                cell.setLayout(task: taskBlockBuilder.tasks[indexPath.row], deviceName: deviceName, tableView: tableView, cellSpacingHeight: cellSpacingHeight)
                
                return cell
            }
            
        } else {
            //Instatiate the taskCell
            let taskCell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
            
            //Set his layout based if the task is completed
            taskCell.setLayout(task: self.taskBlock.includedTasks[indexPath.section], deviceName: AutoLayout.getDeviceNameBasedOnProportion(viewSize: self.view.frame.size), tableView: tableView)
            
            if indexPath.section != 0 || self.taskBlock.includedTasks[indexPath.section].completed {
                taskCell.setAlphaOfCell(alpha: 0.5)
            }
            
            return taskCell
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if !self.editionMode {
            guard let taskCell = tableView.cellForRow(at: indexPath) as? TaskCell else {return nil}
            
            if taskCell.task.completed {
                self.presentSimpleAlertController(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("taskDone", comment: ""))
                return nil
            }
            
            if(indexPath.section != 0) {
                self.presentSimpleAlertController(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("orderTask", comment: ""))
                return nil
            }
            
            let completeAction = UIContextualAction(style: .normal, title: NSLocalizedString("complete", comment: "")) { (action, view, nil) in
                self.actionTask(indexPath: indexPath, action: .complete)
            }
            
            completeAction.backgroundColor = UIColor(rgb: 0x65DB9C)
            
            let config = UISwipeActionsConfiguration(actions: [completeAction])
            
            return config
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if !self.editionMode {
            guard let taskCell = tableView.cellForRow(at: indexPath) as? TaskCell else {return nil}
            
            if taskCell.task.completed {
                self.presentSimpleAlertController(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("taskDone", comment: ""))
                return nil
            }
            
            if(indexPath.section != 0) {
                self.presentSimpleAlertController(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("orderTask", comment: ""))
                return nil
            }
            
            let doLatterAction = UIContextualAction(style: .normal, title: NSLocalizedString("doAfter", comment: "")) { (action, view, nil) in
                self.actionTask(indexPath: indexPath, action: .skip)
            }
            
            doLatterAction.backgroundColor = UIColor(rgb: 0x6069DA)
            
            let deleteAction = UIContextualAction(style: .destructive, title: NSLocalizedString("giveUp", comment: "")) { (action, view, nil) in
                self.actionTask(indexPath: indexPath, action: .delete)
            }
            
            deleteAction.backgroundColor = UIColor(rgb: 0xC63E40)
            
            return UISwipeActionsConfiguration(actions: [doLatterAction, deleteAction])
        }
        return nil
    }
}
