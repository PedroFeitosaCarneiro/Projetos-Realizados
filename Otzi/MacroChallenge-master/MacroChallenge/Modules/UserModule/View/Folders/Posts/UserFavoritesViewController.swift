//
//  UserFavoritesViewController.swift
//  MacroChallenge
//
//  Created by Fábio França on 08/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

class UserFavoritesViewController: UIViewController {
    
    var presenter: UserFavoritesPresenterToView?
    var screen: UserFavoritesFoldersScreen!
    
    var folders: [Folder] = [] {
        didSet{
            // Alterar folders da View
            DispatchQueue.main.async {
                self.screen.folders = self.folders
                if self.folders.isEmpty {
                    self.editBtn.title = ""
                }else{
                    self.editBtn.title = "Edit"
                }
            }
        }
    }
    
    var editBtn: UIBarButtonItem!
    var cancelBtn: UIBarButtonItem!
    
    var editActive = false
    var fetched = false
    
    override func loadView() {
        self.screen = UserFavoritesFoldersScreen()
        screen.controller = self
        self.view = screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editBtn = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(self.editBtnWasPressed))
        cancelBtn = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(self.editBtnWasPressed))
        cancelBtn.tintColor = #colorLiteral(red: 0.8352941176, green: 0.3294117647, blue: 0.3294117647, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.parent?.navigationItem.title = "Favorites"

        self.parent?.navigationController?.navigationBar.tintColor = ViewColor.FeedView.NavigationBackButton.color
        self.parent?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ViewColor.FeedView.NavigationTitle.color]
        self.parent?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.heavy)]
        
        self.parent?.navigationController?.navigationBar.isHidden = false
        self.parent?.navigationItem.setRightBarButton(editBtn, animated: false)
        self.parent?.navigationItem.setLeftBarButton(cancelBtn, animated: false)
        
        presenter?.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        editMod(editActive: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
         if !fetched {
            createLoadingScreen()
        }
    }
    
    private func logout() {
        let alertLogout = UIAlertController(title: "Logout", message: "Are you sure you want to log out", preferredStyle: .alert)
        
        let acaoLogout = UIAlertAction(title: "Logout", style: .destructive) { (alert) in
            DispatchQueue.main.async {
                self.presenter?.logout()
            }
        }
        
        let acaoReturn = UIAlertAction(title: "Return", style: .cancel)
        
        alertLogout.addAction(acaoLogout)
        alertLogout.addAction(acaoReturn)
        
        present(alertLogout,animated: true,completion: nil)
    }
    
    @objc func editBtnWasPressed(_ sender:UIBarButtonItem) {
        if(sender == cancelBtn && cancelBtn.title == "Logout") {
            logout()
            return
        }
        if (editBtn == sender) && editActive {
            let foldersSelected = screen.foldersSelected
            for folder in foldersSelected {
                for image in folder.images?.allObjects as! [Image] {
                    presenter?.deleteImage(image: image)
                }
                presenter?.deleteUserFolder(folder: folder)
            }
        }
        
        editMod(editActive: !editActive)
    }
    
    func editMod(editActive: Bool) {
        self.editActive = editActive
        screen.setupEdit(isEditing: editActive)
        if editActive {
            editBtn.title = "Delete"
            editBtn.tintColor = #colorLiteral(red: 0.8352941176, green: 0.3294117647, blue: 0.3294117647, alpha: 1)
            cancelBtn.title = "Cancel"
            cancelBtn.tintColor = #colorLiteral(red: 0.2431372549, green: 0.2392156863, blue: 0.2392156863, alpha: 1)
        }else {
            //decelecionar os butoes
            cancelBtn.title = ""
            cancelBtn.tintColor = #colorLiteral(red: 0.8352941176, green: 0.3294117647, blue: 0.3294117647, alpha: 1)
            editBtn.title = "Edit"
            editBtn.tintColor = #colorLiteral(red: 0.2431372549, green: 0.2392156863, blue: 0.2392156863, alpha: 1)
        }
    }
    
    func getImage(with url: String, indexPath: IndexPath, folder: Folder) {
        presenter?.requestDowloadImage(with: url, at: indexPath, folder: folder)
    }
}

extension UserFavoritesViewController: UserFavoritesViewToPresenter {
    func postWasDeletes(post: Image) {
        //screen.indexPathsWithImage[indexPath] = nil
    }
    
    func folderWasDeletes(folder: Folder) {
        if let folderToRemoveIndex = screen.folders.firstIndex(of: folder) {
            folders.remove(at: folderToRemoveIndex)
            screen.indexPathsWithImage.removeAll()
        }
    }
    
    func imageWasFetched(image: UIImage, indexPath: IndexPath, folder: Folder) {
        screen.imageWasFetched(image: image, indexPath: indexPath, folder: folder)
    }

    func updateFolders(folders: [Folder]) {
        hideSkeleton()
        fetched = true
        if folders.isEmpty {
            self.screen.errorLabel.isHidden = false
        }else{
            self.screen.errorLabel.isHidden = true
        }
        self.folders = folders
    }
}

extension UserFavoritesViewController: SkeletonDisplayable {
    func createLoadingScreen() {
        screen.createLoadingScreen()
        showSkeleton()
    }
}

