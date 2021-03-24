//
//  ExploreCollectionViewCustomLayout.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 22/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit

class ExploreCollectionViewCustomLayout {
    
    
    /// Função para criar layout da collection view da tela de explore
    /// - Returns: UICollectionViewCompositionalLayout - Layout criado
    class func create() -> UICollectionViewCompositionalLayout{
        
        let estimetedHeight: CGFloat = 90
        let margin: CGFloat = 0
        let contentInsests: CGFloat = 0.5

        
        let smallItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalWidth(1/3)))
        
        smallItem.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsests,
            leading: contentInsests,
            bottom: contentInsests,
            trailing: contentInsests)
        
  
        let tripletGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(estimetedHeight)),
            subitems: [smallItem, smallItem, smallItem])
        
        let largeItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(2/3),
                heightDimension: .fractionalWidth(1/3)))
        
        
        largeItem.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsests,
            leading: contentInsests,
            bottom: contentInsests,
            trailing: contentInsests)
        
        let largeWithOneGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(estimetedHeight)),
            subitems: [smallItem, largeItem])//.fractionalWidth(4/9)
        
        
        let largeWithOneReversedGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(estimetedHeight)),
            subitems: [largeItem,smallItem])
        
        let nestedGroupHeight = (tripletGroup.layoutSize.heightDimension.dimension*2) + (largeWithOneGroup.layoutSize.heightDimension.dimension*3)
        
        var subitens = [
            tripletGroup,
            largeWithOneGroup,
            
            largeWithOneReversedGroup,
            largeWithOneGroup
        ].shuffled()
        subitens.append(tripletGroup)
        
        let nestedGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(nestedGroupHeight)),
            subitems: subitens
        )
        
        let section = NSCollectionLayoutSection(group: nestedGroup)
        
        
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 1,
            leading: margin,
            bottom: 1,
            trailing: margin)
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .vertical
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration = configuration
        return layout
    }
    
    
}

