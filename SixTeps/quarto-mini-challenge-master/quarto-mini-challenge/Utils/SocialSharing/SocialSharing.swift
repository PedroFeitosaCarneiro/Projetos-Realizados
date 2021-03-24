//
//  SocialSharing.swift
//  quarto-mini-challenge
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 05/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation
import UIKit



class SocialSharing {
    
    //https://developers.facebook.com/docs/instagram/sharing-to-stories
    
    public func shareToInstagram(image: UIImage?){
        if let storiesUrl = URL(string: "instagram-stories://share"){
             if UIApplication.shared.canOpenURL(storiesUrl){
                 
                 guard let image = image else {return}
                 guard let imageData = image.pngData() else {return}
                 let pasteBoardItems : [String:Any] = [
                 "com.instagram.sharedSticker.stickerImage": imageData,
                 "com.instagram.sharedSticker.backgroundTopColor" : "#636e72",
                 "com.instagram.sharedSticker.backgroundBottomColor" : "#b2bec3"
                 ]
                 
                 let pasteBoardOptions = [
                     UIPasteboard.OptionsKey.expirationDate : Date().addingTimeInterval(300)
                 ]
                 
                 UIPasteboard.general.setItems([pasteBoardItems], options: pasteBoardOptions)
                 UIApplication.shared.open(storiesUrl, options: [:], completionHandler: nil)
                 
                 
             } else {
                 print("no instagrama :C")
             }
         }
    }
    
    private func defaultIosSharing(viewController : UIViewController, customText : String){
        let activityController = UIActivityViewController(activityItems: [customText], applicationActivities: nil)
            viewController.present(activityController, animated: true, completion: nil)
    }
    
    
}
