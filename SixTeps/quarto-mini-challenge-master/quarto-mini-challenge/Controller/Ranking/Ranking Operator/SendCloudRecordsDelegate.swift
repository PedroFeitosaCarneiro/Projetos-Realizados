//
//  SendCloudRecordsDelegate.swift
//  quarto-mini-challenge
//
//  Created by Guilherme Martins Dalosto de Oliveira on 12/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation
import SwiftUI

protocol SendCloudRecordsDelegate{
    func operateValues(users: [String],level: [Int],tasks: [Int],id: [String],pictures: [Image], backgroundPhotos: [Image],divisions: [Int])
}
