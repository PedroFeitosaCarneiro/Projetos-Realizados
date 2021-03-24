//
//  UserFavoritesFoldersScreen.swift
//  MacroChallenge
//
//  Created by Fábio França on 23/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

class UserFavoritesFoldersScreen: UIView {
    var controller: UserFavoritesViewController!
    
    lazy var folders: [Folder] = [] {
        didSet {
            self.imagesFolder.removeAll()
            DispatchQueue.main.async {
                self.applyUserFavoritesSnapShot()
                if self.folders.isEmpty {
                    self.errorLabel.isHidden = false
                }
            }
        }
    }
    
    var imagesFolder: [Folder: [UIImage]] = [:]
    var editMode = false
    
    var foldersSelected: [Folder] = []
    var indexPathsWithImage = [IndexPath:UIImage?]()
    var cellsToPopulate: [IndexPath:FoldersCollectionViewCell] = [:]
    
    var viewsHeader = [FavoritesSectionHeaderReusableView]()
    
    lazy var foldersCollectionView : UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: PreFeedCustomLayout.createPreFeedLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .white
        collection.register(FoldersCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.delegate = self
        collection.register(
            FavoritesSectionHeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: FavoritesSectionHeaderReusableView.reuseIdentifier
        )
        return collection
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You still don't have any folders"
        label.font = UIFont.init(name: "Coolvetica", size: 25)
        label.isHidden = true
        return label
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Folder, Image>?
    var snapShot = NSDiffableDataSourceSnapshot<Folder,Image>()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
        createDataSource()
        applyUserFavoritesSnapShot()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Folder, Image>(collectionView: foldersCollectionView, cellProvider: { (collectionView, indexPath, post) -> UICollectionViewCell? in
            // Criar uma nova cell com botao no canto superior esquerdo
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FoldersCollectionViewCell
            
            self.cellsToPopulate[indexPath] = cell
            
            if let image = self.indexPathsWithImage[indexPath] {
                cell.loadView(with: image)
           }else{
                if let link = post.link{
                    self.controller.getImage(with: link, indexPath: indexPath, folder: post.folder!)
                }
           }
            
            self.dataSource!.supplementaryViewProvider = { collectionView, kind, indexPath in
                
                guard kind == UICollectionView.elementKindSectionHeader else {
                    return nil
                }
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FavoritesSectionHeaderReusableView.reuseIdentifier, for: indexPath) as? FavoritesSectionHeaderReusableView
                view!.presenter = self.controller.presenter
                view?.addFolderToDelete = self.addFolderToRemove
                view?.removeFolderToDelete = self.removeFolderToRemove
                
                let section = self.dataSource?.snapshot().sectionIdentifiers[indexPath.section]
                view!.titleLabel.text = section?.name
                view!.folder = self.folders[indexPath.section]
                self.viewsHeader.append(view!)
                
                return view!
            }
            
            return cell
        })
    }
    
    func applyUserFavoritesSnapShot(){
        snapShot = NSDiffableDataSourceSnapshot<Folder,Image>()
        snapShot.appendSections(folders)
        
        for folder in folders{
            let posts = folder.images?.allObjects as! [Image]
            snapShot.appendItems(posts, toSection: folder)
        }
        dataSource?.apply(snapShot)
    }
    
    func imageWasFetched(image: UIImage, indexPath: IndexPath, folder: Folder) {
        DispatchQueue.main.async { [self] in
            cellsToPopulate[indexPath]?.loadView(with: image)
            self.indexPathsWithImage[indexPath] = image
            self.imagesFolder[folder]?.append(image)
        }
    }
    
    func setupEdit(isEditing: Bool) {
        editMode = isEditing
        for view in viewsHeader {
            view.setupEdit(isEditing: isEditing)
        }
    }
    
    func addFolderToRemove(folder: Folder) {
        foldersSelected.append(folder)
    }
    
    func removeFolderToRemove(folder: Folder) {
        if let folderToRemoveIndex = foldersSelected.firstIndex(of: folder) {
            foldersSelected.remove(at: folderToRemoveIndex)
        }
        self.imagesFolder[folder]?.removeAll()
        self.indexPathsWithImage.removeAll()
    }
    
    func createLoadingScreen() {
        var fakeFolders = [Folder]()
        for _ in 0...3 {
            let folder = Folder(context: CoreDataStack.persistentContainer.viewContext)
            folder.name = "RangelTheNerdola123"
            folder.addToImages(Image(context: CoreDataStack.persistentContainer.viewContext))
            folder.addToImages(Image(context: CoreDataStack.persistentContainer.viewContext))
            folder.addToImages(Image(context: CoreDataStack.persistentContainer.viewContext))
            folder.addToImages(Image(context: CoreDataStack.persistentContainer.viewContext))
            folder.addToImages(Image(context: CoreDataStack.persistentContainer.viewContext))
            folder.addToImages(Image(context: CoreDataStack.persistentContainer.viewContext))
            
            fakeFolders.append(folder)
        }
        self.folders = fakeFolders
        applyUserFavoritesSnapShot()
    }
}

extension UserFavoritesFoldersScreen: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !editMode {
            controller.presenter?.goToFavoritesFoldersPosts(with: folders[indexPath.section])
        }
    }
}

extension UserFavoritesFoldersScreen: ViewCoding {
    func buildViewHierarchy() {
        self.addSubview(foldersCollectionView)
        self.addSubview(errorLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            foldersCollectionView.topAnchor.constraint(equalTo:  self.topAnchor, constant: 0),
            foldersCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            foldersCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            foldersCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            errorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30)
        ])
    }
    
    func setupAdditionalConfiguration() {
        self.backgroundColor = .white
    }
}

