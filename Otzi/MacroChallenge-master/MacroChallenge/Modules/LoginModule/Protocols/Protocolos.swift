//
//  Protocols.swift
//  MacroChallenge
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 18/11/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit
import WebKit
/**
 view -> presenter
 
 presenter -> view
 presenter -> Interactor
 presenter -> Router
 
 interactor -> Presenter
 */

protocol LoginViewToPresenter: class {
    var presenter:LoginPresenterToView?{get set}
    
    
    func applyProvisionalNavigation()
    
}

protocol LoginPresenterToView: class {
    var view:LoginViewToPresenter?{get set}
    var router: LoginRouterProtocol?{get set}
    
    func webProvisionalNavigation(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    
    func webFinishNavigation(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    
    func webFailNavigation(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error)
    
}

protocol LoginPresenterToInteractor: class {
    var interactor:LoginInteractorToPresenter?{get set}
    
    
    func dealingWithProvisionalNavigation()
    func dealingWithFinishedNavigation()
    func dealingWithFailedNavigation()
    
    
}

protocol LoginInteractorToPresenter: class {
    var presenter:LoginPresenterToInteractor?{get set}
    
    
    func logicalProvisionalNavigation(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    
    func logicalFinishNavigation(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    
    func logicalFailNavigation(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error)
    
    
    
}

protocol LoginRouterProtocol: class {
    func createLoginModule() -> UIViewController
}

protocol notifyInstagram: class{
    func isLogged(_ result: Bool)
}
