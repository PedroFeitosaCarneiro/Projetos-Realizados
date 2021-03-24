//
//  UIOutlinedLabel.swift
//  IvyLeeStudy
//
//  Created by Antonio Carlos on 21/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//


import UIKit

class UIOutlinedLabel: UILabel {

    var outlineWidth: CGFloat = 1
    var outlineColor: UIColor = .black

    override func drawText(in rect: CGRect) {

        let strokeTextAttributes = [
            NSAttributedString.Key.strokeColor : outlineColor,
            NSAttributedString.Key.strokeWidth : -1 * outlineWidth,
            ] as [NSAttributedString.Key : Any]

        self.attributedText = NSAttributedString(string: self.text ?? "", attributes: strokeTextAttributes)
        super.drawText(in: rect)
    }
}
