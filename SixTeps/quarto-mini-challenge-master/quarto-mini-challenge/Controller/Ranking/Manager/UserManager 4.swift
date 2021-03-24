//
//  SortOperator.swift
//  quarto-mini-challenge
//
//  Created by Guilherme Martins Dalosto de Oliveira on 12/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation

class UserManager: UserManagerLogic{
    
    func execOrderAndValueSwitch(users: [UserStandard]) -> [UserStandard]{
        users.sorted { (firstUser, secondUser) -> Bool in
            return firstUser.tasksPerformed > secondUser.tasksPerformed
        }
    }
    
    func transformDataIntoUserStandard(users: [String], level: [Int],tasks: [Int]) -> [UserStandard]{
        var allUsers : [UserStandard] = []
        
        for index in 0..<users.count{
            allUsers.append(UserStandard(username: users[index], tasksPerformed: tasks[index], level: level[index]))
        }
        return allUsers
    }
    
}
