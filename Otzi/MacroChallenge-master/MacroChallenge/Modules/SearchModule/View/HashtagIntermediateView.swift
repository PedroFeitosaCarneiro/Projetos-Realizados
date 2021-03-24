//
//  HashtagWhiteView.swift
//  MacroChallenge
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 01/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit



class HashtagIntermediateView: UIViewController, UISearchBarDelegate{
    var presenter: SearchPresenterToView?
    
    
    var searchButton : UIView = {
       let buttonSearchBar = UIView(frame: .init(x: 0, y: 0, width: 300, height: 33))
       buttonSearchBar.sizeToFit()
       buttonSearchBar.clipsToBounds = true
       buttonSearchBar.layer.cornerRadius = 6
       buttonSearchBar.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 233/255, alpha: 1)
        return buttonSearchBar
    }()
    
    
    let searchBar : UISearchBar = {
        
        let sb = UISearchBar()
        sb.sizeToFit()
        sb.placeholder = "Search for HashTags"
        return sb
        
    }()
    
    let searchBarTouchArea : UIView = {
        let searchTouch = UIView(frame: .zero)
        return searchTouch
    }()
    
    
    let iconItem : UIBarButtonItem = {
           let img = UIImage(named: "searchIcon")?.withRenderingMode(.alwaysOriginal)
        
        let ii = UIBarButtonItem(image: img, style: .plain, target: nil, action: nil)
        ii.imageInsets = UIEdgeInsets(top: 0, left: 0.5, bottom: 0, right: 0)
        ii.isEnabled = false
        return ii
    }()
    
    var cancelItem : UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewDidLoad() {
        setupView()
    }

    
    
}


extension HashtagIntermediateView: SearchViewToPresenter{
    
    
}

extension HashtagIntermediateView: ViewCoding{
    
    func setupAdditionalConfiguration() {
        setupSearchBar()
        setupNavBar()
        self.view.backgroundColor = . white
        
        searchBarTouchArea.frame = searchBar.frame
        
        cancelItem = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancelButtonTapped))
        cancelItem.tintColor = .lightGray
        cancelItem.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Arial", size: 12) as Any], for: .application)
        self.navigationItem.setRightBarButton(cancelItem, animated: false)
    }
    
    func buildViewHierarchy() {
        
    }
    
    func setupConstraints() {
        
    }
    
    
    func setupSearchBar(){
    
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        definesPresentationContext = true
        searchBar.addSubview(searchBarTouchArea)
        let tap = UITapGestureRecognizer(target: self, action:#selector(searchButtonTapped))
        searchBar.addGestureRecognizer(tap)
        
    }
    
    
    func setupNavBar(){
        self.navigationItem.setLeftBarButton(iconItem, animated: false)
    }
    
    
    @objc func searchButtonTapped(){
        presenter?.callRouterToSearchView(from: self)
    }
    @objc func cancelButtonTapped(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
