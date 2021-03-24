//
//  CoreDataTests.swift
//  MacroChallengeTests
//
//  Created by Lelio Jorge Junior on 18/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import XCTest
@testable import MacroChallenge


class CoreDataTests: XCTestCase {
    
    func test_insert_obj(){
        let data = DataController()
        
        data.insertData(handler: { (context) in
            
            let user = User(context: context)
            user.name = "Lélio"
            user.email = "lelio_ljj@hotmail.com"
            user.accountType = true
            
        }, completion: nil)
    }
    
    func test_retrieve_obj(){
        let data = DataController()
        
        data.retrieveData(fetch: User.fetch(), handler: { (results) in
            let results = results as! [User]
            for result in results {
                print(result.name!)
            }
        }, completion: nil)
    }
    
    
    // MARK: - Test Specialist
    
    func test_insert_obj_with_specialist(){
        let core = CoreDataManager()
        let folder = UserEntity(name: "1", email: "1", accountType: true)

        core.insert(with: folder, completion: nil)
    }
    
    func test_fetch_obj_with_specialist(){
        let core = CoreDataManager()
        core.fetch(entity: Folder.self, completion: { (folders, error) in
            if let folders = folders {
                for folder in folders {
                    print("--",folder.name!)
                    let al = folder.images?.allObjects as! [Image]
                    for image in folder.images!{
                        let image = image as! Image
                        print("--",image.id!)
                        print("--",image.owner)
                        print("--",image.link!)
                        print("--",image.descriptionPost!)
                        
                    }
                }
            }
            
            if let error = error {
                print(error)
            }
        })
        
    }
    
    func test_add_obj_with_specialist(){
//        let core = CoreDataManager()
//        let images = [ImageEntity(name: "Goku", link: "www.Goku.com"),
//                      ImageEntity(name: "Picolo", link: "www.Picolo.com")]
//        let predicate = NSPredicate(format: "name = %@", "DBZ")
        
//        core.add(images: images, predicate: predicate, completion: { print($0)})
    }
    
    func test_update_obj_with_specialist(){
        let core = CoreDataManager()
        let predicate = NSPredicate(format: "name = %@", "Geral")
        let image = ImageEntity(id: "11", owner: "Lelio", description: "2020202020202", link: "www.com")
        core.add(image: image, predicateFolder: predicate) { (error) in
            print(error)
        }
        
        
    }
    
//    func test_delete_obj_with_specialist(){
//        let core = CoreDataManager()
//        let predicate = NSPredicate(format: "name = %@", "Lélio")
//
//        core.delete(entity: User.self, predicate: predicate, completion: {print($0)})
//    }
}
