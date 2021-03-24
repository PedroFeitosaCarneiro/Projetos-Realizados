//
//  UserList.swift
//  quarto-mini-challenge
//
//  Created by Guilherme Martins Dalosto de Oliveira on 11/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import SwiftUI
import Combine

public class UserList: ObservableObject{
    
    var usersTest = [UserStandard(username: "Gui", tasksPerformed: 2, level: 2, id: "aaa",image: Image("GuiPicture"), division: 2, backgroundImage: Image("GuiPicture"))]
    var usersTop: [UserStandard] = []
    
    public var objectWillChange = PassthroughSubject<Void, Never>()
    var users : [UserStandard] = [] {
        
        willSet{
            DispatchQueue.main.async{
                self.objectWillChange.send()
            }
        }
    }
}
