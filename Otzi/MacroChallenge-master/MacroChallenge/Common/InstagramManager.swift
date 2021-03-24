//
//  ProfileInstagram.swift
//  MacroChallenge
//
//  Created by Lelio Jorge Junior on 25/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

class InstagramManager: NSObject, UIDocumentInteractionControllerDelegate {
    
    let user: String!
    
    private let appURL: String!
    
    private let webURL: String!
    
    init(user: String) {
        self.user = user
        self.appURL = "instagram://user?screen_name=\(user)"
        self.webURL = "https://www.instagram.com/\(user)/"
    }
    
}

// MARK: - Profile
extension InstagramManager {
    
    func callInstagramProfileApp(){
        guard let url = URL(string: appURL)  else { return }
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func callInstagramProfileWebSite(){
        guard let url = URL(string: webURL)  else { return }
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func callBingWebSite() {
        guard let url = URL(string: user)  else { return }
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

// MARK: - Post Feed
extension InstagramManager {
    
    func shareToInstagramFeed(image: UIImage,view: UIView) {
        // build the custom URL scheme
        guard let instagramUrl = URL(string: "instagram://app") else {
            return
        }

        // check that Instagram can be opened
        if UIApplication.shared.canOpenURL(instagramUrl) {
            // build the image data from the UIImage
            guard let imageData = image.jpegData(compressionQuality: 100) else {
                return
            }

            // build the file URL
            let path = (NSTemporaryDirectory() as NSString).appendingPathComponent("instagram.ig")
            let fileUrl = URL(fileURLWithPath: path)

            // write the image data to the file URL
            do {
                try imageData.write(to: fileUrl, options: .atomic)
            } catch {
                // could not write image data
                return
            }

            // instantiate a new document interaction controller
            // you need to instantiate one document interaction controller per file
            let documentController = UIDocumentInteractionController(url: fileUrl)
            documentController.delegate = self
            // the UTI is given by Instagram
            documentController.uti = "com.instagram.photo"

            // open the document interaction view to share to Instagram feed
            documentController.presentOpenInMenu(from: view.frame, in: view, animated: true)
        } else {
            // Instagram app is not installed or can't be opened, pop up an alert
        }
    }
}



