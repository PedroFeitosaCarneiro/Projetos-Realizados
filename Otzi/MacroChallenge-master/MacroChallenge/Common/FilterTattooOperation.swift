//
//  FilterTattooOperation.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 13/11/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit


/// Uma operation que dada uma imagem, verifica se é uma tatuagem ou não
class FilterTattooOperation: Operation {
    
    let tattoo: UIImage
    
    /// Property que indica se é tattoo ou não
    var isTattoo: Bool = false
    
    
    /// Init da FilterTattooOperation
    /// - Parameter tattoo: imagem a ser análisada
    init(_ tattoo: UIImage) {
        self.tattoo = tattoo
    }
    
    override func main () {
        if isCancelled {
            return
        }
        
        isTattoo = FilterTattoo.shared.isTattoo(image: tattoo)
        
    }
    
    
    
    
}
