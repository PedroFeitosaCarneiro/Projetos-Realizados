//
//  RankingOperator.swift
//  quarto-mini-challenge
//
//  Created by Guilherme Martins Dalosto de Oliveira on 12/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation
import SwiftUI
class RankingOperator{
    
    var delegate: SendCloudRecordsDelegate
    let rankingWorker = CloudWorker()
    
    
    init(view: SendCloudRecordsDelegate){
        self.delegate = view
        rankingWorker.fetchUsers { (users, level,tasks) in
            self.delegate.operateValues(users: users, level: level,tasks: tasks)
        }
    }
    
}
