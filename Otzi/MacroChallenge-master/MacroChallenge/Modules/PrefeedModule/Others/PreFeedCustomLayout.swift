//
//  PreFeedCustomLayout.swift
//  MacroChallenge
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 19/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit

class PreFeedCustomLayout{

    /// Method de class para criar um compositional Layout
    /// - Returns: UICollectionViewCompositionalLayout
    class func createPreFeedLayout() -> UICollectionViewCompositionalLayout{

//        let width = UIScreen.main.bounds.size.width * 6
        let width = (UIScreen.main.bounds.size.width * 0.91) * 6
        let size = NSCollectionLayoutSize(
            widthDimension: .absolute(UIScreen.main.bounds.size.width * 0.91),
            heightDimension: .fractionalHeight(1.0))

        var margin: CGFloat = 13
        var contentInsests: CGFloat = 6
        let group1 = createLayoutOne(margin: &margin, contentInsests: &contentInsests, size: size)
        let group2 = createLayoutTwo(margin: &margin, contentInsests: &contentInsests, size: size)//groupMainWithTwo(size: size)
        let group3 = createLayoutThree(margin: &margin, contentInsests: &contentInsests, size: size)//groupWithTwoSmallAndOneBig(size: size)
        let group4 = createLayoutFour(margin: &margin, contentInsests: &contentInsests, size: size)
        let group5 = createLayoutFive(margin: &margin, contentInsests: &contentInsests, size: size)
        let group6 = createLayoutSix(margin: &margin, contentInsests: &contentInsests, size: size)
        
        
       


        let nestedGroup =  NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
              widthDimension: .absolute(width),
              heightDimension: .absolute(UIScreen.main.bounds.size.height * 0.6)),
            subitems: [group1,group2,group3,group4,group5,group6]//.shuffled()
          )




        let section = NSCollectionLayoutSection(group: nestedGroup)

        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 13,
            bottom: 0,
            trailing: 12)

        section.orthogonalScrollingBehavior = .continuous

        let headerFooterSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .absolute(40)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: headerFooterSize,
          elementKind: UICollectionView.elementKindSectionHeader,
          alignment: .top
        )
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
//        configuration.scrollDirection = .horizontal
        layout.configuration = configuration

        return layout


    }

    class func createLayoutOne(margin: inout CGFloat, contentInsests: inout CGFloat, size: NSCollectionLayoutSize) -> NSCollectionLayoutGroup{


        if UIScreen.main.bounds.width < 414{
            margin = 10
            contentInsests = 6
        }

        let fatBox = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.63)))

        fatBox.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsests,
            leading: contentInsests,
            bottom: contentInsests,
            trailing: contentInsests)
        
        
        
        let item55x44 = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.55),
            heightDimension: .fractionalHeight(1.0)))

        item55x44.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsests,
            leading: contentInsests,
            bottom: contentInsests,
            trailing: contentInsests)
        

        let item44x44 = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.44),
            heightDimension: .fractionalHeight(1.0)))

        item44x44.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsests,
            leading: contentInsests,
            bottom: contentInsests,
            trailing: contentInsests)
        
        
        
         let group2 = NSCollectionLayoutGroup.horizontal(
           layoutSize: NSCollectionLayoutSize(
             widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.37)),//.estimated(170))
           subitems: [item44x44, item55x44])


        let nestedGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: size.widthDimension, heightDimension: size.heightDimension),
          subitems: [
            fatBox,
            group2
          ]
        )
        return nestedGroup
    }
    /// Cria a segunda página de feed layout
    /// - Parameters:
    ///   - margin: CGFloat - margens
    ///   - contentInsests: CGFloat - espaço entre os itens
    ///   - size: NSCollectionLayoutSize - Tamanho do group
    /// - Returns: NSCollectionLayoutGroup - layout group
    class func createLayoutTwo( margin: inout CGFloat, contentInsests: inout CGFloat, size: NSCollectionLayoutSize) -> NSCollectionLayoutGroup{
        
        

        let tallBox = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)))

      
        
        
        tallBox.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsests,
            leading: contentInsests,
            bottom: contentInsests,
            trailing: contentInsests)
        
        
        
        let groupTall = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5)), subitems: [tallBox,tallBox])
        

        
        
        let nestedGroup = NSCollectionLayoutGroup.vertical(
          layoutSize:NSCollectionLayoutSize(widthDimension: size.widthDimension, heightDimension: size.heightDimension),
          subitems: [
            groupTall,
            groupTall
          ]
        )
        
       
        return nestedGroup

        
    }
    
    
    /// Cria a terceira página de feed layout
    /// - Parameters:
    ///   - margin: CGFloat - margens
    ///   - contentInsests: CGFloat - espaço entre os itens
    ///   - size: NSCollectionLayoutSize - Tamanho do group
    /// - Returns: NSCollectionLayoutGroup - layout group
    class func createLayoutThree(margin: inout CGFloat, contentInsests: inout CGFloat,  size: NSCollectionLayoutSize) -> NSCollectionLayoutGroup{
        
        
    //    var estimetedHeight: CGFloat = 90
        if UIScreen.main.bounds.width < 414{
            margin = 10
    //        estimetedHeight = 90
            contentInsests = 6
        }
        

       
        let halfBox = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.5)))

      
        
        
        halfBox.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsests,
            leading: contentInsests,
            bottom: contentInsests,
            trailing: contentInsests)
        
        
        let nestedGroup = NSCollectionLayoutGroup.vertical(
          layoutSize:NSCollectionLayoutSize(widthDimension: size.widthDimension, heightDimension: size.heightDimension),
          subitems: [
            halfBox,
            halfBox
          ]
        )
        
       
        return nestedGroup
    }

    
    /// Cria a quarta página de feed layout
    /// - Parameters:
    ///   - margin: CGFloat - margens
    ///   - contentInsests: CGFloat - espaço entre os itens
    ///   - size: NSCollectionLayoutSize - Tamanho do group
    /// - Returns: NSCollectionLayoutGroup - layout group
    class func createLayoutFour(margin: inout CGFloat, contentInsests: inout CGFloat,  size: NSCollectionLayoutSize) -> NSCollectionLayoutGroup{
        
 
        if UIScreen.main.bounds.width < 414{
            margin = 10
            contentInsests = 6
        }
        

        
        
         let halfBox = NSCollectionLayoutItem(
           layoutSize: NSCollectionLayoutSize(
             widthDimension: .fractionalWidth(1.0),
             heightDimension: .fractionalHeight(0.5)))

         
         halfBox.contentInsets = NSDirectionalEdgeInsets(
             top: contentInsests,
             leading: contentInsests,
             bottom: contentInsests,
             trailing: contentInsests)

        
        let tallBox = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)))

      
        
        
        tallBox.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsests,
            leading: contentInsests,
            bottom: contentInsests,
            trailing: contentInsests)
        
        
        
        let groupTall = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5)), subitems: [tallBox,tallBox])
        
      
        let nestedGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: size.widthDimension, heightDimension: size.heightDimension),
          subitems: [
            halfBox,
            groupTall
          ]
        )
        
        return nestedGroup
        
        

        
    }
    
    
    /// Cria a quinta página de feed layout
    /// - Parameters:
    ///   - margin: CGFloat - margens
    ///   - contentInsests: CGFloat - espaço entre os itens
    ///   - size: NSCollectionLayoutSize - Tamanho do group
    /// - Returns: NSCollectionLayoutGroup - layout group
    class func createLayoutFive(margin: inout CGFloat, contentInsests: inout CGFloat,  size: NSCollectionLayoutSize) -> NSCollectionLayoutGroup{
        
 
        if UIScreen.main.bounds.width < 414{
            margin = 10
            contentInsests = 6
        }
        

        
         let halfBox = NSCollectionLayoutItem(
           layoutSize: NSCollectionLayoutSize(
             widthDimension: .fractionalWidth(1.0),
             heightDimension: .fractionalHeight(0.5)))

         
         halfBox.contentInsets = NSDirectionalEdgeInsets(
             top: contentInsests,
             leading: contentInsests,
             bottom: contentInsests,
             trailing: contentInsests)

        
        let tallBox = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)))

      
        
        
        tallBox.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsests,
            leading: contentInsests,
            bottom: contentInsests,
            trailing: contentInsests)
        
        
        
        let groupTall = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5)), subitems: [tallBox,tallBox])
        
      
        let nestedGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: size.widthDimension, heightDimension: size.heightDimension),
          subitems: [
            groupTall,
            halfBox
          ]
        )
        
        return nestedGroup
        
        

        
    }
    
    /// Cria a quinta página de feed layout
    /// - Parameters:
    ///   - margin: CGFloat - margens
    ///   - contentInsests: CGFloat - espaço entre os itens
    ///   - size: NSCollectionLayoutSize - Tamanho do group
    /// - Returns: NSCollectionLayoutGroup - layout group
    class func createLayoutSix(margin: inout CGFloat, contentInsests: inout CGFloat,  size: NSCollectionLayoutSize) -> NSCollectionLayoutGroup{
        
 
        if UIScreen.main.bounds.width < 414{
            margin = 10
            contentInsests = 6
        }
        

        
       
        let fatBox = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.63)))

        fatBox.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsests,
            leading: contentInsests,
            bottom: contentInsests,
            trailing: contentInsests)
        
        
        
        let item55x44 = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.55),
            heightDimension: .fractionalHeight(1.0)))

        item55x44.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsests,
            leading: contentInsests,
            bottom: contentInsests,
            trailing: contentInsests)
        

        let item44x44 = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.44),
            heightDimension: .fractionalHeight(1.0)))

        item44x44.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsests,
            leading: contentInsests,
            bottom: contentInsests,
            trailing: contentInsests)
        
        
        
         let group2 = NSCollectionLayoutGroup.horizontal(
           layoutSize: NSCollectionLayoutSize(
             widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.37)),//.estimated(170))
           subitems: [item44x44, item55x44])


        let nestedGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: size.widthDimension, heightDimension: size.heightDimension),
          subitems: [
            group2,
            fatBox
          ]
        )
        return nestedGroup
        
        

        
    }
    
}
