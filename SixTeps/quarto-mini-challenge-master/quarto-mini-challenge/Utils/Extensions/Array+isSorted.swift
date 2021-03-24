//
//  Array+isSorted.swift
//  quarto-mini-challenge
//
//  Created by Guilherme Martins Dalosto de Oliveira on 05/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation

extension Array where Iterator.Element: Comparable {
    func isSorted(isOrderedBefore: (Iterator.Element, Iterator.Element) -> Bool) -> Bool  {
        for i in 1 ..< self.count {
            if isOrderedBefore(self[i], self[i-1]) {
                return false
            }
        }
        return true
    }
}
