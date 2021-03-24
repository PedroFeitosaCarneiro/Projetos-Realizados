//
//  UserProfileViewController.swift
//  quarto-mini-challenge
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 08/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var profile_Bg_RoundedView: UIView!
    
    @IBOutlet weak var profile_Bg_CollectionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackGroundView()
        setupBackGroundCellView()

        // Do any additional setup after loading the view.
    }
    
    private func setupBackGroundView(){
        profile_Bg_RoundedView.clipsToBounds = true
        profile_Bg_RoundedView.layer.cornerRadius = 150
        
    }
    
    private func setupBackGroundCellView(){
        profile_Bg_CollectionView.clipsToBounds = true
        profile_Bg_CollectionView.layer.cornerRadius = 20
        profile_Bg_CollectionView.layer.masksToBounds = false
        profile_Bg_CollectionView.layer.shadowColor = UIColor.darkGray.cgColor
        profile_Bg_CollectionView.layer.shadowOpacity = 0.2
        profile_Bg_CollectionView.layer.shadowOffset = CGSize(width: 0, height: 15.5)
        profile_Bg_CollectionView.layer.shadowRadius = 20
        
        profile_Bg_CollectionView.layer.shouldRasterize = true
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UserProfileViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! UserProfileCollectionViewCell
        
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 20
        
        return cell
    }
    
    
    
    
    
    
}
