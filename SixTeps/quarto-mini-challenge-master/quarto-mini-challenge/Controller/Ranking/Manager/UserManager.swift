//
//  SortOperator.swift
//  quarto-mini-challenge
//
//  Created by Guilherme Martins Dalosto de Oliveira on 12/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation
import SwiftUI

class UserManager: UserManagerLogic{
    
    let coreManager = CoreDataManager.shared

    func execOrderAndValueSwitch(users: [UserStandard]) -> [UserStandard]{
        users.sorted { (firstUser, secondUser) -> Bool in
            return firstUser.tasksPerformed > secondUser.tasksPerformed
        }
    }
    
    func showRankingByProximityUsers(userId: String,users: [UserStandard]) -> [UserStandard]{
        var indexOfSelf = 0
        // Mudar ambos para 10
        var valueMax = 2
        var valueMin = 2
        var proximityUsers: [UserStandard] = []
        
        print("USER ID -> \(userId)")
        for index in 0..<users.count{
            print(users[index].id)
            if users[index].id == userId {indexOfSelf = index}
        }
        
        for user in users{
            print(user.division)
        }
        // Tirar depois que conseguir criar id no CoreData        
        // Fazer tratamento de erros para verificar se existe limite
        while !(users.indices.contains(indexOfSelf + valueMax)){
            valueMax -= 1
            print(valueMax)
        }
        
        while !(users.indices.contains(indexOfSelf - valueMin)){
            valueMin -= 1
        }
        
        print("max -> \(valueMax)")
        print("min -> \(valueMin)")
        for index in indexOfSelf...indexOfSelf+valueMax{
            proximityUsers.append(users[index])
        }
        
        for index in indexOfSelf-valueMin..<indexOfSelf{
            proximityUsers.append(users[index])
            print("ENTEREDDDD")
        }
        
        return execOrderAndValueSwitch(users: proximityUsers)
    }
    
    func transformDataIntoUserStandard(users: [String], level: [Int],tasks: [Int],id: [String],pictures: [Image], backgroundPhotos: [Image],divisions: [Int]) -> [UserStandard]{
        var allUsers : [UserStandard] = []

        for index in 0..<users.count{
            allUsers.append(UserStandard(username: users[index], tasksPerformed: tasks[index], level: level[index],id: id[index],image: pictures[index],division: divisions[index], backgroundImage: backgroundPhotos[index]))
        }
        return allUsers
    }
    
}
