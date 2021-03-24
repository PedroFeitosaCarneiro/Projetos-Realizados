//
//  ExploreViewDelegate.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 24/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit

class ExploreViewDelegate: NSObject, UICollectionViewDelegate, UIScrollViewDelegate{
    
   
    var numberMaxOfSelectedItens: Int
    
    ///Closure chamada quando o usuário selecionar um item
    var didSelectItemAt:((IndexPath)->()) = {_ in}
    ///Closure chamada quando o usuário deselecionar um item
    var didDeselectItemAt:((IndexPath)->()) = {_ in}
    
    ///Closure chamada quando o item for aparecer
    var willDisplayItemAt:((IndexPath)->()) = {_ in}
    
    
    /// Init do delegate
    /// - Parameter numberMaxOfSelectedItens: Número máximo de células que pode ser selecionadas
    init(numberMaxOfSelectedItens: Int) {
        self.numberMaxOfSelectedItens = numberMaxOfSelectedItens
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        didSelectItemAt(indexPath)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        didDeselectItemAt(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if !(collectionView.indexPathsForSelectedItems?.count ?? 0 <=  (self.numberMaxOfSelectedItens-1)){
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            return false
        }
    
        return true
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        willDisplayItemAt(indexPath)
    }
    
}

