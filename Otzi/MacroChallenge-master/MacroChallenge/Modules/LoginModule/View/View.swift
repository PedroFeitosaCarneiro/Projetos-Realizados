//
//  View.swift
//  MacroChallenge
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 18/11/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit
import WebKit


class LoginView: UIViewController, LoginViewToPresenter{
    
    
    var presenter: LoginPresenterToView?
    
    var flag = false
    var webPage = WKWebView()
    
    weak var delegage: LoginAutheticated? = nil
    
    
    override func viewDidLoad() {
        setupWebView()
        setupView()
    }
    
    
}

extension LoginView: ViewCoding{
    func buildViewHierarchy() {
        
    }
    
    func setupConstraints() {
        
    }
    
    func setupAdditionalConfiguration() {
        
    }
    
    func setupWebView(){
        
        self.view = webPage
        webPage.navigationDelegate = self
        webPage.load(URLRequest(url: URL(string: KEYS.INSTAGRAMURL)!))
        
    }
    
    func applyProvisionalNavigation() {
        self.dismiss(animated: true) {
            self.delegage?.didLogin()
        }
    }
    
}

extension LoginView: WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        presenter?.webProvisionalNavigation(webView, didStartProvisionalNavigation: navigation)
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        presenter?.webFinishNavigation(webView, didFinish: navigation)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        presenter?.webFailNavigation(webView, didFail: navigation, withError: error)
    }
    
}


protocol LoginAutheticated : class{
    
    func didLogin()
}
