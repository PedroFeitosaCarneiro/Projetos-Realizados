//
//  User.swift
//  quarto-mini-challenge
//
//  Created by Bernardo Nunes on 01/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation
import CloudKit
import UIKit
import CoreData 

class User: NotifyUserProtocol {
    
    //MARK: - Properties
    private let defaults = UserDefaultLogic()
    private let cloud = CloudManager.shared
    private let coreData = CoreDataManager.shared
    private let context = CoreDataManager.shared.persistentContainer.viewContext
    private let levelPass = [1, 1, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 18, 18, 18, 18, 18]
    
    private var userCD: UserCD!
    private var userCK: CKRecord?
    
    private(set) var user_id: String? {
        get {
            return self.userCD.user_rec_id
        }
        
        set {
            self.userCD.user_rec_id = newValue
        }
    }
    
    private(set) var username: String? {
        get {
            return self.userCD.username
        }
        
        set {
            self.userCD.username = newValue
        }
    }
    
    private(set) var profilePic: Data? {
        get {
            return self.userCD.profile_picture
        }
        
        set {
            self.userCD.profile_picture = newValue
        }
    }
    
    private(set) var backgroundPhoto: Data? {
        get {
            return self.userCD.backgroundPhoto
        }
        
        set {
            self.userCD.backgroundPhoto = newValue
        }
    }
    
    private(set) var score: Int16 {
        get {
            return self.userCD.pointsAmount
        }
        
        set {
            self.userCD.pointsAmount = newValue
        }
    }
    
    private(set) var levelCategories = [CategoryLevel]()
    
    private(set) var amountTasksPerformed: Int16 {
        get {
            return self.userCD.tasks_amount_performed
        }
        
        set {
            self.userCD.tasks_amount_performed = newValue
        }
    }
    
    //MARK: - Initializer
    /// Init that creates user in Core Data if it does not already exist
    /// - Author: Bernardo
    init() {
        if let user = self.coreData.fetch(UserCD.self, predicate: nil, fetchLimit: nil).first {
            self.userCD = user
        } else {
            guard let usersEntity = NSEntityDescription.entity(forEntityName: "UserCD", in: context) else { return }
            let user = NSManagedObject(entity: usersEntity, insertInto: context) as! UserCD
            
            user.tasks_amount_performed = 0
            user.pointsAmount = 0
            
            self.userCD = user
            
            coreData.saveContext()
        }
        
        for category in CategoryTaskType.allCases {
            self.levelCategories.append(CategoryLevel(category: category))
        }
    }
    
    //MARK: - Methods
    
    /// Method used to build ckrecord from properties of object
    /// - Parameter userID: user ID to be used as record name
    /// - Author: Bernardo
    func buildCKRecord (userID: String) {
        let recordID = CKRecord.ID(recordName: userID)
        let userRecord = CKRecord(recordType: "User", recordID: recordID)
        

        userRecord.setValue(self.username, forKey: "username")
        userRecord.setValue(self.profilePic, forKey: "profilePicture")
        userRecord.setValue(self.backgroundPhoto, forKey: "backgroundPhoto")
        userRecord.setValue(self.score, forKey: "pointsAmount")
        userRecord.setValue(self.amountTasksPerformed, forKey: "amountTasksPerformed")
        userRecord.setValue(self.getDivision(), forKey: "divisionId")
        userRecord.setValue(self.getLevel(), forKey: "level")
        let categoryRefs = self.levelCategories.map { $0.getCKReference() }
        userRecord.setValue(categoryRefs, forKey: "categoriesLevel")
        
        self.userCK = userRecord
    }
    
    /// Method to login multiplayer validating if player already exists
    /// - Parameters:
    ///   - userID: user ID to be used as record name (from sign in with apple)
    ///   - completion: Completion to treat if user wants to override his account or keep it in case one already exists in the cloud
    /// - Author: Bernardo
    func loginMultiplayer(userID: String, completion: @escaping ((Bool) -> Void)) {
        let recordID = CKRecord.ID(recordName: userID)
        self.user_id = userID
        self.coreData.saveContext()
        
        self.cloud.fetchRecords(recordIDs: [recordID], desiredKeys: nil) { (recordsDic, _) in
            guard let dictionary = recordsDic, dictionary.count > 0 else {
                self.createUserCK(userID: userID)
                completion(false)
                return
            }
            self.userCK = dictionary.first?.value
            completion(true)
        }
    }
    
    /// Method that creates user in the cloud
    /// - Parameter userID: user ID to be used as record name (from sign in with apple)
    /// - Author: Bernardo
    func createUserCK(userID: String) {
        self.userCK = nil
        self.buildCKRecord(userID: userID)
        
        guard let record = self.userCK else { return }
        
        self.cloud.createRecords(records: [record], perRecordCompletion: {_, error in
            if error == nil {
                self.defaults.userId = userID
            }
        }, finalCompletion: {})
    }
    
    /// Method used to override user in coredata
    /// - Parameter userID: user ID to be used as record name (from sign in with apple)
    /// - Author: Bernardo
    func overrideUser(userID: String) {
        self.user_id = self.userCK?.recordID.recordName
        self.amountTasksPerformed = Int16(self.userCK?.value(forKey: "amountTasksPerformed") as! Int64)
        let catRefs = self.userCK?.value(forKey: "categoriesLevel") as! [CKRecord.Reference]
        self.levelCategories = catRefs.map { (refs) -> CategoryLevel in
            return CategoryLevel(recordID: refs.recordID)
        }        
        self.score = Int16(self.userCK?.value(forKey: "pointsAmount") as! Int64)
        self.profilePic = self.userCK?.value(forKey: "profilePicture") as? Data
        self.username = self.userCK?.value(forKey: "username") as? String
        self.backgroundPhoto = self.userCK?.value(forKey: "backgroundPhoto") as? Data
        
        self.defaults.userId = userID
        self.defaults.didSetUsername = true
        
        self.coreData.saveContext()
    }
    
    
    // Delegate method
    func sendCompletedTask(score: Int16, category: CategoryTaskType) {
        self.amountTasksPerformed+=1
        let catLevel = self.levelCategories.first { (cat) -> Bool in
            return cat.cat_id == category
        }
        
        if let categorLevel = catLevel {
            categorLevel.updatePoints(quantity: score)
            self.coreData.saveContext()
        }
    }
    
    /// Method used to update user in cloud everytime he goes in profile screen
    /// - Author: Bernardo
    func updateUserCK(completion: @escaping (() -> Void)) {
        guard let recordName = self.user_id else { return }
        self.buildCKRecord(userID: recordName)
        
        guard let userRecord = self.userCK else { return }
        
        var records = self.levelCategories.compactMap { (catLevel) -> CKRecord? in
            return catLevel.getCategoryLevelCK()
        }
        
        records.append(userRecord)
        
        self.cloud.updateRecords(records: records, perRecordCompletion: {_, error in
            if error == nil {
                self.defaults.userId = recordName
            }
        }, finalCompletion: {})
    }
    
    /// Method to change username validating if it is not repeated
    /// - Parameters:
    ///   - username: username to be changed
    ///   - completion: Completion with boolean with permission or not to change username
    /// - Author: Bernardo
    func setUsername(username: String, completion: @escaping ((Bool) -> Void)) {
        
        if self.defaults.userId == nil {
            self.username = username
            self.coreData.saveContext()
            completion(true)
            return
        }
        
        var canSet = true
        let predicate = NSPredicate(format: "username == %@", username)
        
        self.cloud.readRecords(recorType: "User", predicate: predicate, desiredKeys: [username], perRecordCompletion: {_ in
            canSet = false
        }, finalCompletion: {
            if canSet {
                guard let userID = self.user_id else { return }
                self.username = username
                self.buildCKRecord(userID: userID)
                guard let record = self.userCK else { return }
                
                
                self.cloud.updateRecords(records: [record], perRecordCompletion: {_, error in
                    guard error != nil else {
                        self.defaults.didSetUsername = true
                        self.coreData.saveContext()
                        return
                    }
                }, finalCompletion: {})
            }
            completion(canSet)
        })
    }
    
    /// updates score in coredata
    /// - Parameter amount: amount to be added
    /// - Author: Bernardo
    func uptadeScore(amount: Int) {
        self.amountTasksPerformed+=Int16(amount)
        self.coreData.saveContext()
    }
    
    
    func getDivision() -> Int{
        let division: Int = getLevel()        
        switch(division){
        case 0...9: do {return 1}
        case 10...19: do {return 2}
        case 20...29: do {return 3}
        case 30...39: do {return 4}
        case 40...49: do {return 5}
        default:
            return 6
        }
    }
    
    
    /// Method that calculates and returns the level of the user
    /// - Returns: Method of user
    /// - Author: Bernardo
    func getLevel() -> Int {
        
        switch self.amountTasksPerformed {
        case let x where x>=396:
            return 50
        case 0:
            return 1
        default:
            var sum = 0
            var level = 2
            
            for i in 0...levelPass.count {
                sum+=levelPass[i]
                if self.amountTasksPerformed < sum{
                    level = i+1
                    break
                }
            }
            return level
        }
    }
    
    /// Updates pic in core data
    /// - Parameter profilePic: pic to be added
    /// - Author: Bernardo
    func updatePic(profilePic: UIImage?) {
        let compressedPic = profilePic?.jpegData(compressionQuality: 0.1)
        self.profilePic = compressedPic
        self.coreData.saveContext()
    }
    
    /// Method to update user's background picture in core data
    /// - Parameter backgroundPhoto: Image to be added
    /// - Author: Pedro Paulo
    func updateBackgroundPhoto(backgroundPhoto : UIImage?) {
        let compressedPic = backgroundPhoto?.jpegData(compressionQuality: 0.1)
        self.backgroundPhoto = compressedPic
        self.coreData.saveContext()
    }
    
    /// Method to set user's username in core data
    /// - Parameter name: Name entered
    /// - Author: Pedro Paulo
    func setUsernameCD(name: String){
        self.username = name
    }

}
