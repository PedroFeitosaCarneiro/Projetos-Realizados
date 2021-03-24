//
//  FeedCustomLayout.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 08/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit



class FeedCustomLayout{
    
    //MARK: -> My custom Layout
    
    /// Método auxiliar para criar um grupo, com duas pequenas no meio e uma cade no top e bottom
    /// - Parameter size: Tamanho do grupo
    /// - Returns: NSCollectionLayoutGroup
    private class func groupWithTwoSmallAndOneBig(size: NSCollectionLayoutSize) -> NSCollectionLayoutGroup{
        
        
        let inset: CGFloat = 8

          // Large item on top
          let topItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(9/16))
          let topItem = NSCollectionLayoutItem(layoutSize: topItemSize)
          topItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)

          // Bottom item
          let bottomItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
          let bottomItem = NSCollectionLayoutItem(layoutSize: bottomItemSize)
          bottomItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)

          // Group for bottom item, it repeats the bottom item twice
          let bottomGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.6))
          let bottomGroup = NSCollectionLayoutGroup.horizontal(layoutSize: bottomGroupSize, subitem: bottomItem, count: 2)

          // Combine the top item and bottom group

          let nestedGroup2 = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [topItem, bottomGroup,topItem])
        
        
        
        
        return nestedGroup2
    }
    
    /// Método auxiliar para criar um grupo, com uma image grande com duas pequenas na latel e abaixo 6 imagens pequenas em grid
    /// - Parameter size: Tamanho do grupo
    /// - Returns: NSCollectionLayoutGroup
    class private func groupMainWithTwo(size: NSCollectionLayoutSize) -> NSCollectionLayoutGroup{
        
        //Second Type: Main item with two Pair
        let mainItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3), heightDimension: .fractionalWidth(9/16)))
        mainItem.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        
        let pairItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5)))
        pairItem.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalWidth(9/16)), subitem: pairItem, count: 2)
        
        
        let mainGroup = NSCollectionLayoutGroup.horizontal(layoutSize:NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(9/16)), subitems: [mainItem, trailingGroup])
        
        //grup 2
        let smallItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                  heightDimension: .fractionalHeight(1.0)))
        smallItem.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let mainSmallItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.45)))
        mainSmallItem.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        
        let smallItemGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                   heightDimension: .fractionalHeight(0.4)),
                                                                subitem: smallItem, count: 2)
        
        let nestedGroup2 = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [mainGroup,smallItemGroup,mainSmallItem])
        
        
        
        
        return nestedGroup2
    }
    
    
    
    
    
    /// Método auxiliar para criar um grupo em grip, com duas imagens em cima, uma grande no meio e duas em bixo
    /// - Parameter size: Tamanho do grupo
    /// - Returns: NSCollectionLayoutGroup
    class private func groupGrid(size: NSCollectionLayoutSize) -> NSCollectionLayoutGroup{
        let trailingItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.33)))
        trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        

        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let twoItemGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.30)),
            subitem: item, count: 2)
        
        let centerItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.4)))
        centerItem.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing:4)
        
        let trailingGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: size,
            subitems: [twoItemGroup, centerItem, twoItemGroup])
        
        
      
        return trailingGroup
    }
    
    
    
}


extension FeedCustomLayout{
    
    /// Method de class para criar um compositional Layout
    /// - Returns: UICollectionViewCompositionalLayout
    class func createCustomLayout(hasHeader: Bool = true) -> UICollectionViewCompositionalLayout{
        
        let amoutOfGrinds: CGFloat = 6
        let width = (UIScreen.main.bounds.size.width * 0.91) * amoutOfGrinds //- ( 6 * 26 - 13)
        
        let size = NSCollectionLayoutSize(
            widthDimension: .absolute(UIScreen.main.bounds.size.width * 0.91),
            heightDimension: .fractionalHeight(1.0))
        
        var margin: CGFloat = 13
        var contentInsests: CGFloat = 6
        let group1 = createLayoutOne(margin: &margin, contentInsests: &contentInsests, size: size)//groupGrid(size: size)
        let group2 = createLayoutTwo(margin: &margin, contentInsests: &contentInsests, size: size)//groupMainWithTwo(size: size)
        let group3 = createLayoutThree(margin: &margin, contentInsests: &contentInsests, size: size)//groupWithTwoSmallAndOneBig(size: size)
        let group4 = createLayoutFour(margin: &margin, contentInsests: &contentInsests, size: size)
        let group5 = createLayoutFive(margin: &margin, contentInsests: &contentInsests, size: size)
        let group6 = createLayoutSix(margin: &margin, contentInsests: &contentInsests, size: size)
        
        
        let nestedGroup =  NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
              widthDimension: .absolute(width),
                heightDimension: .absolute(UIScreen.main.bounds.size.height * 0.76)),//.absolute(group4.layoutSize.heightDimension.dimension)
            subitems: [group1,group2,group3,group4,group5,group6]
          )

       
   
        
        let section = NSCollectionLayoutSection(group: nestedGroup)
        
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 13,
            bottom: 0,
            trailing: 12)
    
        let layout = UICollectionViewCompositionalLayout(section: section)

        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(
                                                                    widthDimension: .absolute(UIScreen.main.bounds.size.width/2),
                                                                    heightDimension: .absolute(UIScreen.main.bounds.size.height * 0.82)),
                                                                 elementKind: UICollectionView.elementKindSectionFooter,
                                                                 alignment: .trailing)
        
        
        header.pinToVisibleBounds = false
        header.zIndex = Int.max
        header.extendsBoundary = true
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .horizontal
        if hasHeader {
            configuration.boundarySupplementaryItems = [header]
        }
        layout.configuration = configuration
        return layout
        
        
    }
    

    
    
    
    
    
    
    
    
    
    
    /// Cria a primeira página de feed layout
    /// - Parameters:
    ///   - margin: CGFloat - margens
    ///   - contentInsests: CGFloat - espaço entre os itens
    ///   - size: NSCollectionLayoutSize - Tamanho do group
    /// - Returns: NSCollectionLayoutGroup - layout group
    class func createLayoutOne(margin: inout CGFloat, contentInsests: inout CGFloat, size: NSCollectionLayoutSize) -> NSCollectionLayoutGroup{
        
        
        if UIScreen.main.bounds.width < 414{
            margin = 10
    //        estimetedHeight = 90
            contentInsests = 6
        }
        

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
        
        
        
         let group1 = NSCollectionLayoutGroup.horizontal(
           layoutSize: NSCollectionLayoutSize(
             widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.23)),//.estimated(170))
           subitems: [item44x44, item55x44])
        
        
        //__________//
        
        
        let item55x55 = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
              widthDimension: .fractionalWidth(0.55),
              heightDimension: .fractionalHeight(1.0)))
        
        item55x55.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsests,
            leading: contentInsests,
            bottom: contentInsests,
            trailing: contentInsests)

        let item44x55 = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.44),
            heightDimension: .fractionalHeight(1.0)))

        item44x55.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsests,
            leading: contentInsests,
            bottom: contentInsests,
            trailing: contentInsests)
        
        
        let group2 = NSCollectionLayoutGroup.horizontal(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.31)),//.estimated(200)
          subitems: [item55x55, item44x55])
        
        
        
         let group1Reversed = NSCollectionLayoutGroup.horizontal(
           layoutSize: NSCollectionLayoutSize(
             widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.23)),
           subitems: [item55x44,item44x44])
        
        
        let nestedGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: size.widthDimension, heightDimension: size.heightDimension),
          subitems: [
            group1,
            group1Reversed,
            group2,
            group1
            
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
        
        
    //    var estimetedHeight: CGFloat = 90
       
        if UIScreen.main.bounds.width < 414{
            margin = 10
    //        estimetedHeight = 90
            contentInsests = 6
        }
        

        let fatBox = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.43)))//.fractionalWidth(0.61)

        fatBox.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsests,
            leading: contentInsests,
            bottom: contentInsests,
            trailing: contentInsests)


        
        //__________//
     
        let littleFatBox = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.35)))//.fractionalWidth(0.5)

        littleFatBox.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsests,
            leading: contentInsests,
            bottom: contentInsests,
            trailing: contentInsests)

        
    
        //__________//
        //Group 2
        
        let item55x44 = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.55),
            heightDimension: .fractionalHeight(1.0)))//.fractionalWidth(0.44)

        item55x44.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsests,
            leading: contentInsests,
            bottom: contentInsests,
            trailing: contentInsests)
        

        let item44x44 = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.44),
            heightDimension: .fractionalHeight(1.0)))//.fractionalWidth(0.44)

        item44x44.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsests,
            leading: contentInsests,
            bottom: contentInsests,
            trailing: contentInsests)
        
        
        
         let group2 = NSCollectionLayoutGroup.horizontal(
           layoutSize: NSCollectionLayoutSize(
             widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.22)),//.estimated(160)
           subitems: [item55x44, item44x44])
        
        
        let nestedGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: size.widthDimension, heightDimension: size.heightDimension),
          subitems: [
           fatBox,
            group2,
            littleFatBox
            
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
        

        let tallBox = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)))

      
        
        
        tallBox.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsests,
            leading: contentInsests,
            bottom: contentInsests,
            trailing: contentInsests)
        
        
        
        let groupTall = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.33)), subitems: [tallBox,tallBox])
        

        let tallBigBox = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)))

        tallBigBox.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsests,
            leading: contentInsests,
            bottom: contentInsests,
            trailing: contentInsests)
        
        let groupBigTall = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.34)), subitems: [tallBigBox,tallBigBox])
        
        
        let nestedGroup = NSCollectionLayoutGroup.vertical(
          layoutSize:NSCollectionLayoutSize(widthDimension: size.widthDimension, heightDimension: size.heightDimension),
          subitems: [
            groupTall,
            groupBigTall,
            groupTall
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
                heightDimension: .fractionalHeight(0.5)))//fractionalWidth(1/3)
        
        halfBox.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsests,
            leading: contentInsests,
            bottom: contentInsests,
            trailing: contentInsests)

        
        
        
      
        let nestedGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: size.widthDimension, heightDimension: size.heightDimension),
          subitems: [
            halfBox,
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
    class func createLayoutFive(margin: inout CGFloat, contentInsests: inout CGFloat,  size: NSCollectionLayoutSize) -> NSCollectionLayoutGroup{
        
 
        if UIScreen.main.bounds.width < 414{
            margin = 10
            contentInsests = 6
        }
        

        
        let threeBox = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.33)))
        
        threeBox.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsests,
            leading: contentInsests,
            bottom: contentInsests,
            trailing: contentInsests)

        
        
        let threeBigBox = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.34)))
        
        threeBigBox.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsests,
            leading: contentInsests,
            bottom: contentInsests,
            trailing: contentInsests)
        
      
        let nestedGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: size.widthDimension, heightDimension: size.heightDimension),
          subitems: [
            threeBox,
            threeBigBox,
            threeBox
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
        

        
        let threeBox = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.33)))
        
        threeBox.contentInsets = NSDirectionalEdgeInsets(
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
        
        
        
        let groupTall = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.34)), subitems: [tallBox,tallBox])
        
        
      
        let nestedGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: size.widthDimension, heightDimension: size.heightDimension),
          subitems: [
            groupTall,
            threeBox,
            threeBox
          ]
        )
        
        return nestedGroup
        
        

        
    }
    
    
}
