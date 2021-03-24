//
//  WebManager.swift
//  MacroChallenge
//
//  Created by Lelio Jorge Junior on 20/11/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import WebKit


class WebViewController: UIViewController {
    
    // MARK: - Atributos
    
    private var url: String
    
    private var webURL: URL? {
        URL(string: url)
    }
    
    private var webURLRequest: URLRequest? {
        URLRequest(url: webURL!)
    }
    
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: self.view.frame)
        webView.translatesAutoresizingMaskIntoConstraints = true
        webView.navigationDelegate = self
        return webView
    }()
    
    lazy var acticvityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .black
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    
    // MARK: - Construtor
    
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        setupView()
        loadWebView()
    }
    
    //MARK: - Métodos
    
    /// Faz chamada web.
    private func loadWebView() {
        guard let webURLRequest = webURLRequest else { return }
        webView.load(webURLRequest)
    }
    
    
}

// MARK: - ViewCoding

extension WebViewController: ViewCoding {
    
    func buildViewHierarchy() {
        self.view.addSubview(webView)
        self.view.addSubview(acticvityIndicator)
    }
    
    func setupConstraints() {
        webView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        acticvityIndicator.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        acticvityIndicator.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        acticvityIndicator.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        acticvityIndicator.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    
}

// MARK: - WebDelegate

extension WebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started to load")
        acticvityIndicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished loading")
        acticvityIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
}
