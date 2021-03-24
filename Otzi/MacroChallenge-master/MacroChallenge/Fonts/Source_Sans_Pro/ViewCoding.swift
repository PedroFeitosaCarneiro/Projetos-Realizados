//
//  ViewCoding.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 08/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation



public protocol ViewCoding {
    
    ///Métodos para configurar as subviews na view
    func buildViewHierarchy()
    
    ///Método para configurar as constraints nas subviews
    func setupConstraints()
    
    /// Método para fazer alguma configuração adicional na view
    func setupAdditionalConfiguration()
    
    /// Método que chama os métodos auxiliares para configurar a view
    func setupView()
}


extension ViewCoding{
    
    func setupView(){
        buildViewHierarchy()
        setupConstraints()
        setupAdditionalConfiguration()
    }
    
    func setupAdditionalConfiguration(){}

}
