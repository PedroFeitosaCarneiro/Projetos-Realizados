//
//  OnboardingPresenter.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 27/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation

class OnboardingPresenter: OnboardingPresenterToView {
    
    
    var interator: OnboardingInteratorToPresenter? = nil
    var router: OnboardingRouterToPresenter? = nil
    
    func userInformationCollected(data: [HashtagSuggest]) {
        interator?.evalueteUserInformation(data: data)
    }
    
}


extension OnboardingPresenter: OnboardingPresenterToInterator{
 
    
    func didFinishProcessAllData() {
        router?.goToExplore()
    }

}
