//
//  CategoryLevel.swift
//  quarto-mini-challenge
//
//  Created by Guilherme Martins Dalosto de Oliveira on 04/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

class CategoryLevel {
        
    //MARK: - Properties
    private let levelPass = [1, 2, 3, 5, 8, 11, 14, 17, 20, 24, 28, 32, 36, 40, 45, 50, 55, 60, 65, 71, 77, 83, 89, 98]
    private let coreData = CoreDataManager.shared
    private let context = CoreDataManager.shared.persistentContainer.viewContext
    private let cloud = CloudManager.shared
    
    private var categoryLevelCD: CategoryLevelCD!
    private var categoryLevelCK: CKRecord?
    
    private(set) var cat_id: CategoryTaskType {
        get {
            return CategoryTaskType(rawValue: categoryLevelCD.category_id)!
        }
        
        set {
            self.categoryLevelCD.category_id = newValue.rawValue
        }
    }
    
    private(set) var category_rec_id: String {
        get {
            return categoryLevelCD.category_rec_id
        }
        
        set {
            self.categoryLevelCD.category_rec_id = newValue
        }
    }
    
    private(set) var points: Int16 {
        get {
            return categoryLevelCD.points_amount
        }
        
        set {
            self.categoryLevelCD.points_amount = newValue
        }
    }
    
    //MARK: - Init
    
    /// Init creates category level if it does not already exist in cloud kit
    /// - Parameter category: category type
    /// - Author: Bernardo
    init(category: CategoryTaskType) {
        let predicate = NSPredicate(format: "category_id == %ld", category.rawValue)
        if let categoryLevel = self.coreData.fetch(CategoryLevelCD.self, predicate: predicate, fetchLimit: nil).first {
            self.categoryLevelCD = categoryLevel
        } else {
            guard let categoryLevelEntity = NSEntityDescription.entity(forEntityName: "CategoryLevelCD", in: context) else { return }
            let categoryLevel = NSManagedObject(entity: categoryLevelEntity, insertInto: context) as! CategoryLevelCD
            
            categoryLevel.category_id = category.rawValue
            categoryLevel.points_amount = 0
            categoryLevel.category_rec_id = CKRecord.ID().recordName
            
            self.categoryLevelCD = categoryLevel
            
            coreData.saveContext()
        }
    }
    
    /// Init to override from cloud
    /// - Parameter recordID: recordID to make override
    /// - Author: Bernardo
    init(recordID: CKRecord.ID) {
        self.cloud.fetchRecords(recordIDs: [recordID], desiredKeys: nil) { (dictionary, _) in
            guard let record = dictionary?.first?.value else { return }
            
            self.categoryLevelCK = record
            let categoryID = Int16(record.value(forKey: "categoryId") as! Int64)
            
            let predicate = NSPredicate(format: "category_id == %ld", categoryID)
            guard let categoryLevel = self.coreData.fetch(CategoryLevelCD.self, predicate: predicate, fetchLimit: nil).first else { return }
           
            categoryLevel.category_id = categoryID
            categoryLevel.points_amount = Int16(record.value(forKey: "pointsAmount") as! Int64)
            categoryLevel.category_rec_id = record.recordID.recordName
            
            self.categoryLevelCD = categoryLevel
            
            self.coreData.saveContext()
        }
    }
    
    //MARK: - Methods
    /// Method to update points
    /// - Parameter quantity: points to be added
    /// - Author: Bernardo
    internal func updatePoints(quantity: Int16) {
        self.points += quantity
        self.coreData.saveContext()
    }
    
    /// Method to update Category level in cloud
    /// - Author: Bernardo
    func getCategoryLevelCK() -> CKRecord?{
        self.createCKRecord()
        guard let record = self.categoryLevelCK else { return nil }
        
        return record
    }
    
    /// Method to create CKRecord
    /// - Author: Bernardo
    func createCKRecord() {
        let record = CKRecord(recordType: "CategoryLevel", recordID: CKRecord.ID(recordName: self.category_rec_id))
        
        record.setValue(self.cat_id.rawValue, forKey: "categoryId")
        record.setValue(self.points, forKey: "pointsAmount")
        
        self.categoryLevelCK = record
    }
    
    /// Method to get ckreference of record
    /// - Returns: CKReference
    /// - Author: Bernardo
    func getCKReference() -> CKRecord.Reference? {
        return CKRecord.Reference(recordID: CKRecord.ID(recordName: self.category_rec_id), action: .deleteSelf)
    }
    
    /// Method to create CategoryLevel in cloud
    /// - Author: Bernardo
    func createCategoryLevelCK() {
        self.createCKRecord()
        guard let record = self.categoryLevelCK else { return }
        
        self.cloud.createRecords(records: [record], perRecordCompletion: {_,_ in }, finalCompletion: {})
    }
    
    /// Method to get level and progress in category
    /// - Returns: Level, progress in level
    /// - Author: Bernardo
    func getLevelProgress() -> (Int, Float) {
        switch self.points {
        case let x where x>=(levelPass.last ?? 98)*cat_id.maxPoints:
            return (25, 0)
        case 0:
           return (1, 0)
        default:
            var level = 1
            var progress: Float = 0
            
            for i in 0...levelPass.count {
                if points<levelPass[i]*cat_id.maxPoints {
                    level = i
                    break
                }
            }
            
            if level == 0 {
                let pointsOnLevel = Float(points)
                let pointsToPass = Float(levelPass[level]*cat_id.maxPoints)
                
                return (1, pointsOnLevel/pointsToPass)
            }
            
            let pointsOnLevel = Float(Int(points)-(levelPass[level-1]*cat_id.maxPoints))
            let pointsToPass = Float((levelPass[level] - levelPass[level-1])*cat_id.maxPoints)
            
            progress = pointsOnLevel/pointsToPass
           
            
            return(level, progress)
        }
    }
}
