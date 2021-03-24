//
//  UserDefaults.swift
//  quarto-mini-challenge
//
//  Created by Guilherme Martins Dalosto de Oliveira on 11/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation

public class UserDefaultLogic {
    
    typealias UD = UserDefaults
    
    var userNotification: Bool {
        get{return UD.standard.value(forKey: "UserNotification") as? Bool ?? false}
        set{UD.standard.set(newValue, forKey:"UserNotification")}
    }
    
    var firstLaunch: Bool{
        get{return UD.standard.value(forKey: "FirstLaunch") as? Bool ?? false}
        set{UD.standard.set(newValue, forKey:"FirstLaunch")}
    }
    
    var firstTimeAddingTask: Bool {
        get{return UD.standard.value(forKey: "FirstTimeAddingTask") as? Bool ?? true}
        set{UD.standard.set(newValue, forKey:"FirstTimeAddingTask")}
    }
    
    var soundStatus: Bool{
        get{return UD.standard.value(forKey: "SoundStatus") as? Bool ?? false}
        set{UD.standard.set(newValue, forKey:"SoundStatus")}
    }
    
    var feedbackStatus: Bool{
        get{return UD.standard.value(forKey: "FeedbackStatus") as? Bool ?? false}
        set{UD.standard.set(newValue, forKey:"FeedbackStatus")}
    }
    

    var userId: String? {
        get{ return UD.standard.value(forKey: "UserID") as? String }
        set{ UD.standard.set(newValue, forKey: "UserID") }
    }
    
    var userName: String {
        get{return UD.standard.value(forKey: "UserName") as? String ?? NSLocalizedString("username", comment: "")}
        set{UD.standard.set(newValue, forKey: "UserName")}        
    }
    
    var didSetUsername: Bool {
        get{return UD.standard.value(forKey: "didSetUsername") as? Bool ?? false}
        set{UD.standard.set(newValue, forKey: "didSetUsername")}
    }
    
    var askForReview: Bool{
        get{return UD.standard.value(forKey: "askForReview") as? Bool ?? false}
        set{UD.standard.set(newValue, forKey: "askForReview")}
    }
    
    var isEnglish: Bool{
        get{return UD.standard.value(forKey: "isEnglish") as? Bool ?? false}
        set{UD.standard.set(newValue, forKey: "isEnglish")}
    }
}
