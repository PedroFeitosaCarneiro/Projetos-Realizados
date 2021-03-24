//
//  CustomSegmentControl.swift
//  MacroChallenge
//
//  Created by Fábio França on 04/11/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

protocol CustomSegmentedCOntrolDelegate: class {
    func changeToIndex(index: Int)
}

class CustomSegmentControl : UIView {

    private var buttonTitles: [String]!
    private var labels: [UILabel]!
    private var buttons: [UIButton]!
    private var selectorView: UIView!

    var textColor: UIColor = #colorLiteral(red: 0.2431372549, green: 0.2392156863, blue: 0.2392156863, alpha: 1)
    var selectorViewColor: UIColor = #colorLiteral(red: 0.2431372549, green: 0.2392156863, blue: 0.2392156863, alpha: 1)
    var selectorTextColor: UIColor = .white
    var trailingSelector: NSLayoutConstraint?
    var leadingSelector: NSLayoutConstraint?
    var edge = false
    var indexSelected = 0
    
    weak var delegate: CustomSegmentedCOntrolDelegate?
    
    init(frame: CGRect, buttonTitle: [String]) {
        self.buttonTitles = buttonTitle
        super.init(frame: frame)
        updateView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateView()
    }
    
    func setButtonTitles(buttonTitles: [String]) {
        self.buttonTitles = buttonTitles
        updateView()
    }

    private func configStackView() {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        //stack.bounds = stack.frame.insetBy(dx: 10.0, dy: 10.0)
        addSubview(stack)

        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: self.topAnchor,constant: 3).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: 3).isActive = true
        stack.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: 3).isActive = true
        stack.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 3).isActive = true
    }

    private func configSelectorView() {
        //let selectorWidth = frame.width / CGFloat(self.buttonTitles.count)
        selectorView = UIView(frame: .zero)
        addSubview(selectorView)
        
        selectorView.translatesAutoresizingMaskIntoConstraints = false
        selectorView.topAnchor.constraint(equalTo: self.topAnchor, constant: 3).isActive = true
        selectorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
        
        leadingSelector = selectorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 3)
        trailingSelector = selectorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(self.bounds.width)/2)
        
        leadingSelector?.isActive = true
        trailingSelector?.isActive = true
        
        selectorView.backgroundColor = selectorViewColor
        
    }
    
    private func createButton() {
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach({$0.removeFromSuperview()})
        
        for _ in buttonTitles {
            let button = UIButton()
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            button.setTitleColor(textColor, for: .normal)
            buttons.append(button)
        }
    }
    
    private func createLabels() {
        labels = [UILabel]()
        labels.removeAll()
        
        for (index, buttonTitle) in buttonTitles.enumerated() {
            let label = UILabel()
            label.textColor = textColor
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = buttonTitle
            
            self.addSubview(label)
            label.centerXAnchor.constraint(equalTo: buttons[index].centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            self.bringSubviewToFront(label)
            //label.heightAnchor.constraint(equalToConstant: 10).isActive = true
            labels.append(label)
        }
        
        labels[0].textColor = selectorTextColor
    }
    
    @objc func buttonAction(sender: UIButton) {
        edge = !edge
        for(buttonIndex, btn) in buttons.enumerated() {
            if btn == sender {
                //let selectorPostion = (self.frame.width/CGFloat(buttonTitles.count) * CGFloat(buttonIndex))
                self.delegate?.changeToIndex(index: buttonIndex)
                UIView.animate(withDuration: 0.3) {
                    //self.selectorView.frame.origin.x = selectorPostion
                    if self.edge{
                        self.leadingSelector?.constant = (self.bounds.width)/2
                        self.trailingSelector?.constant = -3
                    }else{
                        self.leadingSelector?.constant = 3
                        self.trailingSelector?.constant = -(self.bounds.width)/2
                    }
                    self.layoutIfNeeded()
                }
                labels[buttonIndex].textColor = selectorTextColor
                labels[indexSelected].textColor = textColor
                indexSelected = buttonIndex
            }
        }
    }
    
    private func updateView() {
        createButton()
        configStackView()
        configSelectorView()
        createLabels()
        
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
    }
}

