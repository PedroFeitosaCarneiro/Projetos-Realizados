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
    
    func showRankingByProximityUsers(userScore: Int,users: [UserStandard]){
        var mostProxAux = 0
        
        for index in 0..<users.count{
            if index == 0 {mostProxAux = users[index].tasksPerformed - userScore} else{
                if users[index].tasksPerformed <= userScore && users[index].tasksPerformed - userScore < mostProxAux {
                    mostProxAux = users[index].tasksPerformed
                }
            }
            
        }
        print(mostProxAux)
        
    }
    
    func transformDataIntoUserStandard(users: [String], level: [Int],tasks: [Int]) -> [UserStandard]{
        var allUsers : [UserStandard] = []
        
        for index in 0..<users.count{
            allUsers.append(UserStandard(username: users[index], tasksPerformed: tasks[index], level: level[index]))
        }
        return allUsers
    }
    
}
