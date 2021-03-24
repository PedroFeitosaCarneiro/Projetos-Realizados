//
//  Router.swift
//  MacroChallenge
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 18/11/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit

class LoginRouter: LoginRouterProtocol{
    
    func createLoginModule() -> UIViewController {
        
        let viewController = LoginView()
        let presenter = LoginPresenter()
        let interactor = LoginInteractor()
        
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = self
        interactor.presenter = presenter
        
        return viewController
        
        
        
    }
    
    
}
