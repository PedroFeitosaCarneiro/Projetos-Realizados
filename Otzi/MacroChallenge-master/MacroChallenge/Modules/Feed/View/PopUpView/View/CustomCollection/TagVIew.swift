//
//  TagVIew.swift
//  MacroChallenge
//
//  Created by Lelio Jorge Junior on 16/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

/// Classe model das tags.
class TagView: UIButton {
    
    open var textFont: UIFont = .systemFont(ofSize: 14) {
        didSet {
            titleLabel?.font = textFont
            setupSize()
        }
    }
    
    /// Caso algum bota seja tocado.
    var onTap: (()->())?
    
    
    /// Configura o tamanho da tag.
    private func setupSize() {
        var size = titleLabel?.text?.size(withAttributes: [NSAttributedString.Key.font: textFont]) ?? CGSize.zero
        size.width += 10
        self.bounds.size = size
    }

}

