//
//  WalkThroughOnBoardDelegate.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 26/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

/// Protocolo para navegar no onboarding
 protocol WalkThroughOnBoardDelegate {
    func goNextPage(fowardTo page: OnboardingPages?)
    func goBeforePage(reverseTo page: OnboardingPages?)
    func didFinishPage(with data: [HashtagSuggest])
    func skipOnboarding()
}

/// Protocolo que representa uma página do onboarding
 protocol OnboardingPage: UIViewController{
    var pageDelegate: WalkThroughOnBoardDelegate? { get set }
}
