//
//  PopUpView+CollectionDataSource.swift
//  MacroChallenge
//
//  Created by Lelio Jorge Junior on 24/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit


extension PopUpView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.getTag()?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HashtagCell", for: indexPath) as! PopUpViewCell
        cell.hashtagLabelView.text = self.getTag()?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? PopUpViewCell {
            if cell.hashtagLabelView.text == "+" {
                self.isMoreTags = true
            }
        }
    }
    
}

extension PopUpView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let label : UILabel = UILabel()
        label.text = self.getTag()?[indexPath.row]
        let labelTextWidth: CGFloat = label.intrinsicContentSize.width + 20
        
        
        return CGSize(width: labelTextWidth, height: 21)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
}
