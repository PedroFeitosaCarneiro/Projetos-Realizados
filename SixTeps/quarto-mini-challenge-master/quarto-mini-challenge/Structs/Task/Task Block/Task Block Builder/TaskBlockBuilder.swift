//
//  TaskBlockBuilder.swift
//  quarto-mini-challenge
//
//  Created by Bernardo Nunes on 14/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation

protocol TaskBlockBuilder {
    func addTask(task: Task)
    func buildTaskBlock()
}
