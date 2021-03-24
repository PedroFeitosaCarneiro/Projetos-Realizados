//
//  OnboardingInterator.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 27/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation

class OnboardingInterator: OnboardingInteratorToPresenter {
    
    
    
    
    
    var presenter: OnboardingPresenterToInterator?
    
    let dataManager : CoreDataManager
    init(dataManager:  CoreDataManager) {
        self.dataManager = dataManager
    }
    
    func evalueteUserInformation(data: [HashtagSuggest]) {
        
        for tag in data{
            dataManager.insert(with: TagEntity(name: tag.text.lowercased(), rating: 4.0, isSeachedTag: true), completion: nil)
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now()  + .seconds(6)) {
//            self.presenter?.didFinishProcessAllData()
//        }
    }
    
    
    
    
    
    
    
    
}
