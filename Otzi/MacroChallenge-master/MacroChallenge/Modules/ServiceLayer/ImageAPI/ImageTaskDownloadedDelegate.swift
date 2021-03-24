//
//  ImageTaskDownloadedDelegate.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 31/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit


protocol ImageTaskDownloadedDelegate {
    
    /// Método que é chamado quando a imagem termina de baixar
    /// - Parameter position: posição da celélua que requisitou a imagem
    func imageDownloaded(position: IndexPath)
}
