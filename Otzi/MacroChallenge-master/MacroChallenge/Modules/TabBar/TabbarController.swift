//
//  TabbarController.swift
//  MacroChallenge
//
//  Created by Fábio França on 25/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

protocol TabbarPresenterToView {
    
}

protocol TabbarViewToPresenter: class {
    
}


protocol TabBarToView {
    
    func showTabBar()->Void
    func hideTabBar()-> Void
    func changeTabBarState(tabBar state: TabBarState) -> Void
    var didTapConfirmButton: (()->()) {get set}
}

typealias Tabs = (
    feed: UIViewController,
    star: UIViewController
)


enum TabBarState{
    case showConfirmedButton
    case showNormalTabBar
}

class TabbarController: UIViewController {
    var selectedIndex: Int = 0
    var previousIndex: Int = 0
    var isConfirm = false
    
    var viewControllers = [UIViewController]()
    var didTapConfirmButton: (()->()) = { }
    var buttons: [UIButton]?
    private var currentTabBarState: TabBarState = .showNormalTabBar
    
    var tabView: UIView = {
        var tabView = UIView(frame: .zero)
        tabView.backgroundColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 0.3)//.clear
        tabView.translatesAutoresizingMaskIntoConstraints = false
        return tabView
    }()
    
    let stack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 5.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Feed"), for: .normal)
        button.setImage(UIImage(named: "FeedSelected"), for: .highlighted)
        button.setImage(UIImage(named: "FeedSelected"), for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        button.tag = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tabChanged), for: .touchUpInside)
        return button
    }()
    
    let button2: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Star"), for: .normal)
        button.setImage(UIImage(named: "StarSelected"), for: .selected)
        button.setImage(UIImage(named: "StarSelected"), for: .highlighted)
        button.imageView?.contentMode = .scaleAspectFit
        button.tag = 1
        button.isEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tabChanged), for: .touchUpInside)
        return button
    }()
    
    let button3: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Confirm"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tag = 3
        button.isEnabled = true
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(confirmClicked), for: .touchUpInside)
        return button
    }()
    
    let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurView
    }()
    
    var footerHeight: CGFloat = 55
    var widthConstraint: NSLayoutConstraint?
    
    init(tabs: Tabs) {
        super.init(nibName: nil, bundle: nil)
        viewControllers = [tabs.feed, tabs.star]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        tabView.layer.cornerRadius = 5
        tabView.layer.masksToBounds = true
        tabView.clipsToBounds = false

        // shadow
        tabView.layer.shadowColor = UIColor.black.cgColor
        tabView.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabView.layer.shadowOpacity = 0.60
        tabView.layer.shadowRadius = 4.0
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttons = [button,button2]
        
        self.view.addSubview(tabView)
        self.tabView.addSubview(stack)
        self.tabView.addSubview(blurEffectView)
        self.tabView.sendSubviewToBack(blurEffectView)
        
        tabView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        tabView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.06).isActive = true
        widthConstraint = tabView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.44)
        widthConstraint?.identifier = "widthTab"
        widthConstraint?.isActive = true
        tabView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        
        stack.leadingAnchor.constraint(equalTo: tabView.leadingAnchor,constant: 5).isActive = true
        stack.trailingAnchor.constraint(equalTo: tabView.trailingAnchor,constant: -5).isActive = true
        stack.topAnchor.constraint(equalTo: tabView.topAnchor,constant: 5).isActive = true
        stack.bottomAnchor.constraint(equalTo: tabView.bottomAnchor,constant: -5).isActive = true
        
        stack.addArrangedSubview(button)
        stack.addArrangedSubview(button2)
        stack.addArrangedSubview(button3)
        
        buttons![selectedIndex].isSelected = true
        tabChanged(sender: buttons![selectedIndex])

        blurEffectView.topAnchor.constraint(equalTo: tabView.topAnchor).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: tabView.bottomAnchor).isActive = true
        blurEffectView.leadingAnchor.constraint(equalTo: tabView.leadingAnchor).isActive = true
        blurEffectView.trailingAnchor.constraint(equalTo: tabView.trailingAnchor).isActive = true
    }
    
    @objc func tabChanged(sender:UIButton) {
        previousIndex = selectedIndex
        selectedIndex = sender.tag
        
        buttons![previousIndex].isSelected = false
        let previousVC = viewControllers[previousIndex]
        
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        
        sender.isSelected = true
        
        let vc = viewControllers[selectedIndex]
        vc.view.frame = UIApplication.shared.windows[0].frame
        vc.didMove(toParent: self)
        self.addChild(vc)
        self.view.addSubview(vc.view)
        
        self.view.bringSubviewToFront(tabView)
    }
    
    @objc func confirmClicked() {
        didTapConfirmButton()
    }
    
    func hideHeader() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
            self.tabView.frame = CGRect(x: self.tabView.frame.origin.x, y: (self.view.frame.height + self.view.safeAreaInsets.bottom + 16), width: self.tabView.frame.width, height: self.tabView.frame.height)
        })
    }
    
    func showHeader() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
            self.tabView.frame = CGRect(x: self.tabView.frame.origin.x, y: self.view.frame.height - (self.footerHeight + self.view.safeAreaInsets.bottom + 16), width: self.tabView.frame.width, height: self.tabView.frame.height)
        })
    }
    
    func showConfirmBtn(tabBar state: TabBarState) {
        if state == currentTabBarState{
            return
        }
        if state == .showConfirmedButton {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                self.button.isHidden = true
                self.button2.isHidden = true
                self.button3.isHidden = false
                self.widthConstraint?.constant = -90
                self.view.layoutIfNeeded()
            })
        }else{
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                self.button.isHidden = false
                self.button2.isHidden = false
                self.button3.isHidden = true
                self.widthConstraint?.constant = 0
            })
        }
        currentTabBarState = state
    }
}

extension TabbarController: TabbarViewToPresenter {
}

extension TabbarController: TabBarToView {
    func changeTabBarState(tabBar state: TabBarState) {
        self.showConfirmBtn(tabBar: state)
    }
    
    
    func showTabBar() {
        //self.tabView.isHidden = false
        print("aqui 1")
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.showHeader()
        })
        
        //showHeader()
    }
    
    func hideTabBar() {
        //self.tabView.isHidden = true
        print("aqui 2")
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.hideHeader()
        })
        
    }
    
    
}


extension UINavigationController{
    
    static var customTabBar: TabBarToView? = nil
}
