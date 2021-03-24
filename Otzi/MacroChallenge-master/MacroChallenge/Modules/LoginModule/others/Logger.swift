//
//  Logger.swift
//  MacroChallenge
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 18/11/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import WebKit

class Logger: UIViewController, WKNavigationDelegate{
     let web = WKWebView()
    weak var delegate : notifyInstagram?
    static var isLogged = false
    func certificate(){
        web.navigationDelegate = self
        web.load(URLRequest(url: URL(string: KEYS.INSTAGRAMURL)!))
    }
    
    func delogar(){
        web.cleanAllCookies()
        web.refreshCookies()
    }
    
    private func getWebHTML(webView: WKWebView, completion: @escaping (_ : String) -> Void)  {
        webView.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML") { innerHTML, error in
            completion(innerHTML as! String)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        getWebHTML(webView: webView) { [weak self] (result) in
            
            if result.contains(KEYS.INSTAGRAM_ALREADY_LOGGED_IN){
                //delegate
                self?.delegate?.isLogged(true)
            } else{
                self?.delegate?.isLogged(false)
            }
        }
    }
    
    
}
extension WKWebView {

    func cleanAllCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        print("All cookies deleted")

        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                print("Cookie ::: (record) deleted")
            }
        }
    }

    func refreshCookies() {
        self.configuration.processPool = WKProcessPool()
    }
}
