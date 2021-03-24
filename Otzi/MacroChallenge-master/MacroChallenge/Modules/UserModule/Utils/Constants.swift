//
//  Constants.swift
//  MacroChallenge
//
//  Created by Fábio França on 16/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

typealias FoldersCompletion = ([Folder]) -> Void
typealias PostsCompletion = ([Image]) -> Void
typealias ImageDowloadCompletion = (Result<UIImage, Error>) -> Void
typealias deleteCompletion = (DataControllerError?)->()
    

