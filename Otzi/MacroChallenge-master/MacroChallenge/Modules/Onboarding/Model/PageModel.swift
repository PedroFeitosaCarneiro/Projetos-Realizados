//
//  PageModel.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 26/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation

/// Model referente a cada página do onboarding
struct PageModel{
    
    let contents : [HashtagSuggest]
    let titleText: String
    let subTitleText: String?
    let currentPage: OnboardingPages
    var nextPage: OnboardingPages?
    var backPage: OnboardingPages?
  
    init(content: [HashtagSuggest], title: String, subTitle: String?, onboarding page: OnboardingPages) {
        self.contents = content
        self.titleText = title
        self.subTitleText = subTitle
        self.currentPage = page
        self.setPages()
    }
    
    /// método que setta a página anterior e a próxima de acordo com a atual
    private mutating func setPages(){
        switch currentPage {
        case .initial:
            backPage = nil
            nextPage = .step1
        case .step1:
            backPage = .initial
            nextPage = .step2
        case .step2:
            backPage = .step1
            nextPage = nil
        case .loginPage:
            backPage = .step2
            nextPage = nil
        }
    }
}
