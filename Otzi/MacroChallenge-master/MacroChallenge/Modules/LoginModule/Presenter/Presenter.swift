//
//  Presenter.swift
//  MacroChallenge
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 18/11/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import WebKit


class LoginPresenter: LoginPresenterToView{
    
    var view: LoginViewToPresenter?
    var interactor: LoginInteractorToPresenter?
    var router: LoginRouterProtocol?
    
    
    func webProvisionalNavigation(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        interactor?.logicalProvisionalNavigation(webView, didStartProvisionalNavigation: navigation)
    }
    
    func webFinishNavigation(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        interactor?.logicalFinishNavigation(webView, didFinish: navigation)
    }
    
    func webFailNavigation(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        interactor?.logicalFailNavigation(webView, didFail: navigation, withError: error)
    }
    
    
}

extension LoginPresenter:LoginPresenterToInteractor{
    func dealingWithProvisionalNavigation() {
    }
    
    func dealingWithFinishedNavigation() {
        view?.applyProvisionalNavigation()
    }
    
    func dealingWithFailedNavigation() {
        
    }
    
    
}
