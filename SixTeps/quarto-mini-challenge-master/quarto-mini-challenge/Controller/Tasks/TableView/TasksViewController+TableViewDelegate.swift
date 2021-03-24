//
//  TasksViewController+TableViewDelegate.swift
//  quarto-mini-challenge
//
//  Created by Antonio Carlos on 08/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import UIKit

extension  TasksViewController: UITableViewDelegate {
    
    //This two functions is to set the space between cells
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !self.editionMode {
            let headerView = UIView()
            headerView.backgroundColor = .clear
            return headerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !self.editionMode {
            if section == 0 || section == taskBlock.includedTasks.count {
                return 0
            } else {
                return cellSpacingHeight
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !self.editionMode {
            return tableView.frame.height*0.1175
        } else {
            return tableView.frame.height*0.1175 + self.cellSpacingHeight
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    //drag and drop
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if self.editionMode {
            
            guard let taskBlockBuilder = self.taskBlockBuilder else {return false}
            
            if indexPath.row > taskBlockBuilder.tasks.count-1 {
                return false
            } else {
                return true
            }
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if self.editionMode {
            guard let taskBlockBuilder = self.taskBlockBuilder else {return}
            
            taskBlockBuilder.reorderTasks(origin: sourceIndexPath.row, destination: destinationIndexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}
