//
//  OnboardingViewModel.swift
//  Jaque WatchKit Extension
//
//  Created by Filipe Lopes on 28/06/20.
//  Copyright © 2020 Lelio Jorge Junior. All rights reserved.
//

import Foundation

class OnboardingViewModel {
    private let onboardingData = OnboardingData()
    
    private static var oboardingViews : [OnboardingModel] = [OnboardingModel]()
    
    func createOnbardingViews(){
        
        for title in self.onboardingData.phrases{
            let onboardingAux = OnboardingModel(onboardingPhrase: title)
            OnboardingViewModel.oboardingViews.append(onboardingAux)
        }
    }
    
    func getView() -> OnboardingModel {
        if OnboardingViewModel.oboardingViews.count == 0{
            self.createOnbardingViews()
        }
        let view = OnboardingViewModel.oboardingViews.first!
        OnboardingViewModel.oboardingViews.removeFirst()
        return view
    }
    
    
}
