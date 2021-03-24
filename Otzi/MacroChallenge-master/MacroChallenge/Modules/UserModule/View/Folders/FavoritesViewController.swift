//
//  FavoritesViewController.swift
//  MacroChallenge
//
//  Created by Fábio França on 06/11/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    var imageAPI: ImageAPI!
    var dataManager: CoreDataManager!
    
    var segment: CustomSegmentControl!
    
    var currentView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var postsViewController: UserFavoritesViewController!
    var hashtagsViewController: UIViewController!
    
    override func loadView() {
        self.view = UIView()
        self.view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segment = CustomSegmentControl(frame: .zero, buttonTitle: ["Posts","Hashtags"])
        segment.delegate = self
        
        setupView()
        setupInitialView()
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        currentView.addSubview(viewController.view)
        viewController.view.frame = currentView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    func setupInitialView() {
        changeToIndex(index: 0)
    }
    
}

extension FavoritesViewController: CustomSegmentedCOntrolDelegate {
    func changeToIndex(index: Int) {
        if index == 0 {
            remove(asChildViewController: hashtagsViewController)
            add(asChildViewController: postsViewController)
        } else {
            remove(asChildViewController: postsViewController)
            add(asChildViewController: hashtagsViewController)
        }
    }
}

extension FavoritesViewController: ViewCoding {
    func buildViewHierarchy() {
        self.view.addSubview(segment)
        self.view.addSubview(currentView)
    }
    
    func setupConstraints() {
        segment.translatesAutoresizingMaskIntoConstraints = false
        
        segment.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 10).isActive = true
        segment.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50.0).isActive = true
        segment.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 50).isActive = true
        segment.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.03).isActive = true
        
        currentView.topAnchor.constraint(equalTo: self.segment.bottomAnchor,constant: 10).isActive = true
        currentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        currentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        currentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func setupAdditionalConfiguration() {
        segment.backgroundColor = .clear
        currentView.backgroundColor = .clear
    }
}
