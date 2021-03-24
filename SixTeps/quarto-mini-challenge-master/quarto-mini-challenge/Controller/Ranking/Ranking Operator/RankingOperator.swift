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
        rankingWorker.fetchUsers { (usernames, level, tasks, ids, pictures, backgrounds, divisions)  in
            let picturesConverted = self.transformUIImagetoImage(pictures: pictures)
            let backgroundConverted = self.transformUIImagetoImage(pictures: backgrounds)
            self.delegate.operateValues(users: usernames, level: level,tasks: tasks,id: ids, pictures: picturesConverted, backgroundPhotos: backgroundConverted, divisions: divisions)
        }
    }
    
    func transformUIImagetoImage(pictures: [UIImage]) -> [Image]{
        var allPicturesConverted: [Image] = []
        
        for picture in pictures{
            var image = Image(uiImage: picture)
            image = image.resizable()
            allPicturesConverted.append(image)
        }
        return allPicturesConverted
    }
}
