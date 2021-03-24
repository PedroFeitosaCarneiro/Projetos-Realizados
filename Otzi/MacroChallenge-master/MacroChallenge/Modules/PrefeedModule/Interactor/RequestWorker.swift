//
//  RequestWorker.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 18/11/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class RequestWorker: UIViewController, WKNavigationDelegate{
    
    var delegate: RequestWorkerObserver?
    let web = WKWebView()
    var hashtag: String?
    var workGroup: DispatchGroup?
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.web.navigationDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func HTTPRequest(with url: URL){
        web.load(URLRequest(url: url))
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        webView2(webView: webView) { [self] (stringJSON) in
            defer {
                
                self.workGroup?.leave()
                
                debugPrint("Saiu do group")
            }
            
            guard let data = stringJSON.data(using: .utf8) else {
                delegate?.notify(with: nil, from: hashtag ?? "")
                return
            }
            let obj = try? JSONDecoder().decode(Graphql.self, from: data)
            delegate?.notify(with: obj, from: hashtag ?? "")
            
            
            
            
        }
        
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        delegate?.notify(with: nil, from: hashtag ?? "")
        debugPrint("Saiu do grouppor error")
        self.workGroup?.leave()
    }
    
    
    func webView2(webView: WKWebView, completion: @escaping (_ : String) -> Void)  {
        webView.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML") { innerHTML, error in
            completion(self.parseString(innerHTML as! String))
        }
    }
    
    
    func parseString(_ str: String) -> String{
        
        let keyOne = """
        <head></head><body><pre style="word-wrap: break-word; white-space: pre-wrap;">
        """
        
        let keyTwo = """
        </pre></body>
        """
        
        let keyThree = """
        amp;
        """
        
        var copy = str.replacingOccurrences(of: keyOne, with: "")
        copy = copy.replacingOccurrences(of: keyTwo, with: "")
        copy = copy.replacingOccurrences(of: keyThree, with: "")
        
        return copy
        
    }
    
    
    
}


protocol RequestWorkerObserver: class {
    func notify(with object: Graphql?, from hashtag: String)
}
