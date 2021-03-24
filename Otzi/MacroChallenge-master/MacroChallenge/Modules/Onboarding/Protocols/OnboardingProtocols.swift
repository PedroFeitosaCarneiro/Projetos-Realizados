//
//  OnboardingProtocols.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 27/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation



//Primeiro é quem implementa e o segundo é onde terar uma referência.
protocol OnboardingPresenterToInterator: class {
    
    /// Método chamdo quando terminou de processar todos os dados do onboarding
    func didFinishProcessAllData()

}

protocol OnboardingInteratorToPresenter: class {
    
    var presenter: OnboardingPresenterToInterator? {get set}
    
    /// Método para processar os dados coletados no onboarding
    /// - Parameter data: dados colotadis
    func evalueteUserInformation(data: [HashtagSuggest])
}

protocol OnboardingViewToPresenter: class{
}

protocol OnboardingPresenterToView: class{
    /// Método que a view avisa para o presenter que todas as informações do onboarding foi coletada
    /// - Parameter data: os dados coletados
    func userInformationCollected(data: [HashtagSuggest])
    
    
    /// Método chamdo quando terminou de processar todos os dados do onboarding
    func didFinishProcessAllData()
}

protocol OnboardingRouterToPresenter{
    
    /// Método para ir para o ir para o explore módulo
    func goToExplore()
}
