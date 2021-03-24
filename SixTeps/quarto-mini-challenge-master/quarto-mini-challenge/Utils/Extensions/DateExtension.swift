//
//  DateExtension.swift
//  quarto-mini-challenge
//
//  Created by Antonio Carlos on 08/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation

extension Date {
    
    func tomorrow() -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.setValue(1, for: .day); // +1 day
        
        let now = Date() // Current date
        let tomorrow = Calendar.current.date(byAdding: dateComponents, to: now)  // Add the DateComponents
        
        return tomorrow!
    }
    
    func yesterday() -> Date {
     
       var dateComponents = DateComponents()
       dateComponents.setValue(-1, for: .day) // -1 day
     
       let now = Date() // Current date
       let yesterday = Calendar.current.date(byAdding: dateComponents, to: now) // Add the DateComponents
     
       return yesterday!
    }
}
