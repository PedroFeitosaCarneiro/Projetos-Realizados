//
//  PageOnboardingModel.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 26/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation


/// Model referente ao onboarding, o PageViewController precisa desse model para ser instanciado
struct PageOnBoardingModel {
    
    private var initialPage = OnboardingPages.initial.vc as! FirstViewController
    private var pageStep1 = OnboardingPages.step1.vc as! FirstViewController
    private var pageStep2 = OnboardingPages.step2.vc as! OnBoardViewController
//     private var loginPage = OnboardingPages.loginPage.vc as! LoginViewController
    
    init() {
    }
    
    
    func getVC(by page: OnboardingPages) -> OnboardingPage{
        switch page {
        case .initial:
            return initialPage
        case .step1:
            return pageStep1
        case .step2:
            return pageStep2
        default:
            return pageStep1
//        case .loginPage:
//            return loginPage
        }
    }
    
}
