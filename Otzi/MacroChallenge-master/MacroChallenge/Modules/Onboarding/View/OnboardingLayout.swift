//
//  OnboardingLayout.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 05/11/20.
//  Copyright © 2020 macro.com. All rights reserved.
//



import UIKit

final class OnboardingLayout{
    
    
    class func create()-> UICollectionViewCompositionalLayout{
        
     
        let margin: CGFloat = 25
        let contentInsests: CGFloat = 25

        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsests-10,
            leading: contentInsests,
            bottom: contentInsests-10,
            trailing: contentInsests)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1/3)),
            subitems: [item,item])
        
    
        
        let nestedGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)),
            subitems: [group,group,group]
        )
        
        let section = NSCollectionLayoutSection(group: nestedGroup)
        
        
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: margin,
            bottom: 0,
            trailing: margin)
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .vertical
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration = configuration
        return layout

        
        
        
        
    }
    
}
