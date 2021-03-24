//
//  Extension+Array.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 16/11/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation


extension Array {
    func splitInTwo() -> [[Element]] {
        let ct = self.count
        let half = ct / 2
        let leftSplit = self[0 ..< half]
        let rightSplit = self[half ..< ct]
        return [Array(leftSplit), Array(rightSplit)]
    }
}
