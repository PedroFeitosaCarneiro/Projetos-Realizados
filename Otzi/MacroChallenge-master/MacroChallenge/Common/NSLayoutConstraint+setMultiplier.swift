//
//  NSLayoutConstraint+setMultiplier.swift
//  MacroChallenge
//
//  Created by Fábio França on 26/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit
extension NSLayoutConstraint {
    /**
     Modifica o Multiplier da Constraint
     
     - parameter multiplier: CGFloat
     - returns: NSLayoutConstraint
     */
    func setMultiplier(_ constraint: NSLayoutConstraint, multiplier: CGFloat) -> NSLayoutConstraint {
        let newConstraint = NSLayoutConstraint(
            item: constraint.firstItem as Any,
            attribute: constraint.firstAttribute,
            relatedBy: constraint.relation,
            toItem: constraint.secondItem,
            attribute: constraint.secondAttribute,
            multiplier: multiplier,
            constant: constraint.constant)
        
        newConstraint.priority = constraint.priority
        
        NSLayoutConstraint.deactivate([constraint])
        NSLayoutConstraint.activate([newConstraint])
        
        return newConstraint
    }
}
