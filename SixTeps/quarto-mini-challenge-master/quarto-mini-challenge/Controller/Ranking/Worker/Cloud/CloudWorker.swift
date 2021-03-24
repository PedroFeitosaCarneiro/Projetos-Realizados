//
//  FetchUsers.swift
//  quarto-mini-challenge
//
//  Created by Guilherme Martins Dalosto de Oliveira on 12/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class CloudWorker: CloudWorkerLogic{
    
    let publicDatabase = CKContainer(identifier: "iCloud.com.panterimar.quarto-mini-challenge").publicCloudDatabase
    
    func fetchUsers(completion: @escaping ([String],[Int],[Int],[String],[UIImage], [UIImage], [Int])-> Void){
        print("Fetching...")
        var assetPictures: [NSData] = []
        var backgroundImgs: [NSData] = []
        var usernames: [String] = []
        var stringIds: [String] = []
        var levelUsers: [Int] = []
        var tasksUsers: [Int] = []
        var divisionUsers: [Int] = []
        
        let user = User()        
        stringIds.append(user.user_id ?? "")
        if let profilePic = user.profilePic as NSData? {
            assetPictures.append(profilePic)
        } else {
            assetPictures.append(UIImage(named: "userProfilePic")!.pngData()! as NSData)
        }
        if let backgroundPhoto = user.backgroundPhoto {
            backgroundImgs.append(backgroundPhoto as NSData)
        } else {
            backgroundImgs.append(UIImage(named: "backGroundBlue")!.pngData()! as NSData)
        }
        usernames.append(user.username!)
        levelUsers.append(user.getLevel())
        tasksUsers.append(Int(user.amountTasksPerformed))
        divisionUsers.append(user.getDivision())
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: "User", predicate:  predicate)
        let queryOperation = CKQueryOperation(query: query)
        
        queryOperation.desiredKeys =  ["profilePicture","username","level","amountTasksPerformed","divisionId"]
        
        queryOperation.recordFetchedBlock = { (record) -> Void in
            if record.recordID.recordName != UserDefaultLogic().userId {
                stringIds.append(record.recordID.recordName)
                if let profilePic = record["profilePicture"] as? NSData {
                    assetPictures.append(profilePic)
                } else {
                    assetPictures.append(UIImage(named: "userProfilePic")!.pngData()! as NSData)
                }
                if let profilePic = record["backgroundPhoto"] as? NSData {
                    assetPictures.append(profilePic)
                } else {
                    backgroundImgs.append(UIImage(named: "backGroundBlue")!.pngData()! as NSData)
                }
                usernames.append(record.value(forKey: "username") as? String ?? "user")
                levelUsers.append(record.value(forKey: "level") as! Int)
                tasksUsers.append(record.value(forKey: "amountTasksPerformed") as! Int)
                divisionUsers.append(record.value(forKey: "divisionId") as! Int)
            }
            
        }
                 
        queryOperation.queryCompletionBlock = ( { (_,_)-> Void in
            
            let profilePictures = assetPictures.compactMap({UIImage(data: $0 as Data)})
            let bakgroundPics = backgroundImgs.compactMap({UIImage(data: $0 as Data)})
            
            completion(usernames,levelUsers,tasksUsers,stringIds,profilePictures,bakgroundPics,divisionUsers)
        })
        
        
        print("Performing operation...")
        publicDatabase.add(queryOperation)
    }
    
    func transformDataIntoImage(file: NSData) -> UIImage{
        return UIImage(data: file as Data)!        
    }
}
