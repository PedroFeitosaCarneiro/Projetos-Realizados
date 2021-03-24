//
//  Interactor.swift
//  MacroChallenge
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 18/11/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import WebKit


class LoginInteractor: LoginInteractorToPresenter{
    
    var presenter: LoginPresenterToInteractor?
    
    
    func logicalProvisionalNavigation(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        if webView.url?.absoluteString.contains(KEYS.INSTAGRAM_LOGGED_IN) == true || webView.url?.absoluteString.contains(KEYS.INSTAGRAM_REGISTERED) == true || webView.url?.absoluteString.contains(KEYS.INSTAGRAM_FB_ACCEPT) == true {
            self.presenter?.dealingWithFinishedNavigation()
        }
        
    }
    
    func logicalFinishNavigation(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    func logicalFailNavigation(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    
    
    private func getWebHTML(webView: WKWebView, completion: @escaping (_ : String) -> Void)  {
        webView.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML") { innerHTML, error in
            completion(innerHTML as! String)
        }
    }
    
    
    
    
    
    
}

