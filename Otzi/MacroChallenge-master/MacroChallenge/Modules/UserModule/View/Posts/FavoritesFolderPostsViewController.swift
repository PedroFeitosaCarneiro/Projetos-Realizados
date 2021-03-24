//
//  FavoritesFolderPostsViewController.swift
//  MacroChallenge
//
//  Created by Fábio França on 23/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

class FavoritesFolderPostsViewController: UIViewController {
    
    var presenter: FavoritesFolderPostsPresenterToView?
    var folder: Folder {
        didSet {
            DispatchQueue.main.async {
                self.images = self.folder.images?.allObjects as! [Image] 
                self.applySnapShot()
            }
        }
    }
    var images: [Image] = []
    var editActive = false
    
    var cells: [FavoritesFolderPostsCell] = []
    var cellsToPopulate: [IndexPath:FavoritesFolderPostsCell] = [:]
    var imagesSelected: [Image] = [] {
        didSet{
            print(imagesSelected)
        }
    }
    
    var indexPathSelected: Int?
    
    var editBtn: UIBarButtonItem!
    var cancelBtn: UIBarButtonItem!
    private let feedCellID = "feedCellID"
    //var uiImagesPosts = [UIImage]()
    
    var dataSource: UICollectionViewDiffableDataSource<Folder, Image>?
    var snapShot = NSDiffableDataSourceSnapshot<Folder,Image>()
    var indexPathsWithImage = [IndexPath:UIImage]()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: FeedCustomLayout.createCustomLayout(hasHeader: false))
        collectionView.isDirectionalLockEnabled = false
        collectionView.alwaysBounceVertical = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.isScrollEnabled = true
        collectionView.allowsSelection = true
        collectionView.isUserInteractionEnabled = true
        collectionView.register(FavoritesFolderPostsCell.self, forCellWithReuseIdentifier: self.feedCellID)
        collectionView.register(
            FavoritesSectionHeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: FavoritesSectionHeaderReusableView.reuseIdentifier
        )
        collectionView.backgroundColor = .white
        collectionView.contentSize.height = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.alwaysBounceHorizontal = true
        collectionView.delegate = self
        return collectionView
    }()
    
    var animationModal: FeedAnimation!
    var animationMode = false {
        didSet{
            if animationMode {
                cancelBtn.action = #selector(animationModeWasStarted(_:))
                editBtn.title = ""
            }else{
                editBtn.title = "Edit"
                cancelBtn.action = #selector(editBtnWasPressed(_:))
            }
        }
    }
    
    init(folder: Folder) {
        self.folder = folder
        images = folder.images?.allObjects as! [Image]
        super.init(nibName: nil, bundle: nil)
        animationModal = createAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = folder.name!
        self.navigationController?.navigationBar.tintColor = ViewColor.FeedView.NavigationBackButton.color
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ViewColor.FeedView.NavigationTitle.color]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.heavy)]
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationItem.setRightBarButton(editBtn, animated: false)
        self.navigationItem.setLeftBarButton(cancelBtn, animated: false)
        
        presenter?.updateFolder(folder: folder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        editBtn = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(self.editBtnWasPressed))
        cancelBtn = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(self.editBtnWasPressed))
        setupView()
        createDataSource()
        applySnapShot()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Cache.removeAllImages()
    }
    @objc func animationModeWasStarted(_ sender:UIBarButtonItem) {
        animationModal.deinitAnimation()
    }
    
    @objc func editBtnWasPressed(_ sender:UIBarButtonItem) {
        if (editBtn == sender) && editActive {
            if (imagesSelected.count - folder.images!.count) == 0 {
                for image in imagesSelected {
                    presenter?.deleteImage(image: image)
                }
                presenter?.deleteUserFolder(folder: folder)
                return
            }
            
            for image in imagesSelected {
                presenter?.deleteImage(image: image)
            }
        }
        
        editActive = !editActive
        
        for cell in cells {
            cell.setupEdit(isEditing: editActive)
        }
        if editActive && sender == editBtn{
            editBtn.title = "Delete"
            editBtn.tintColor = #colorLiteral(red: 0.8352941176, green: 0.3294117647, blue: 0.3294117647, alpha: 1)
            cancelBtn.title = "Cancel"
        }else if cancelBtn.title == "Cancel"{
            //decelecionar os butoes
            cancelBtn.title = "Back"
            editBtn.title = "Edit"
            editBtn.tintColor = #colorLiteral(red: 0.2431372549, green: 0.2392156863, blue: 0.2392156863, alpha: 1)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Folder, Image>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, post) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.feedCellID, for: indexPath) as! FavoritesFolderPostsCell
            
            if let image = self.indexPathsWithImage[indexPath] {
                cell.populate(with: image)
            }else{
                self.presenter?.requestDowloadImage(with: post.link!, at: indexPath)
            }
            
            cell.image = post
            cell.addPostToDelete = self.addPostToRemove
            cell.removePostToDelete = self.removePostToRemove
            self.cells.append(cell)
            self.cellsToPopulate[indexPath] = cell
            return cell
        })
    }
    
    func applySnapShot(){
        snapShot = NSDiffableDataSourceSnapshot<Folder,Image>()
        snapShot.appendSections([folder])
        
        let posts = images
        snapShot.appendItems(posts, toSection: folder)
        
        dataSource?.apply(snapShot)
    }
    
    func addPostToRemove(post: Image) {
        imagesSelected.append(post)
    }
    
    func removePostToRemove(post: Image) {
        if let postToRemoveIndex = imagesSelected.firstIndex(of: post) {
            imagesSelected.remove(at: postToRemoveIndex)
        }
    }
    
    func createPopUpController(image: Image) -> PopUpViewController? {
        let newPost = self.presenter?.createPost(image: image)
        
        guard let post = newPost else {
            return nil
        }
        let popUpController = PopUpViewController(post: post)
        popUpController.popUpView.translatesAutoresizingMaskIntoConstraints = false
        let popUpInteractor: PopUpInteractor = PopUpInteractor()
        let popUpPresenter: PopUpPresenter = PopUpPresenter()
        popUpPresenter.interactor = popUpInteractor
        popUpController.presenter = popUpPresenter
        //popUpController.popUpView.animation = self
        return popUpController
    }
    
    func createPopUpConstraint(popView: UIView) {
        popView.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 15).isActive = true
        popView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: -100).isActive = true
        popView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        popView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
}

extension FavoritesFolderPostsViewController: ViewCoding {
    func buildViewHierarchy() {
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 25).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    }
    
    func setupAdditionalConfiguration() {
        
    }
}

extension FavoritesFolderPostsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            if editActive{
                let cell = collectionView.cellForItem(at: indexPath) as! FavoritesFolderPostsCell
                cell.editBtnWasPressed(sender: cell.editBtn)
            }else{
                let cell = collectionView.cellForItem(at: indexPath) as! FavoritesFolderPostsCell
                if let post = presenter?.createPost(image: images[indexPath.row]) {
                    animationModal.feed?.populateAnimationView(post: post, main: cell.coverImage.image!, outherImages: [], owner: images[indexPath.row].owner)
                    animationModal.feed?.run()
                    indexPathSelected = indexPath.row
                }
            }
        }
    }
}

extension FavoritesFolderPostsViewController: FavoritesFolderPostsViewToPresenter {
    func updateFolder(folder: Folder) {
        self.folder = folder
    }
    
    func folderWasDeletes() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func postWasDeletes(post: Image) {
        if let postToRemoveIndex = images.firstIndex(of: post) {
            images.remove(at: postToRemoveIndex)
        }
        DispatchQueue.main.async {
            self.applySnapShot()
        }
    }
    
    func imageWasFetched(image: UIImage, indexPath: IndexPath) {
        DispatchQueue.main.async { [self] in
                self.indexPathsWithImage[indexPath] = image
                cellsToPopulate[indexPath]?.populate(with: image)
        }
    }
}

extension FavoritesFolderPostsViewController: AnimationProtocol {
    
    var animation: FeedAnimation {
        get {
            return animationModal!
        }
        set {
            animationModal = newValue
        }
    }
    
    func createAnimation() -> FeedAnimation {
        let animationModal = FeedAnimation(frame: self.collectionView.frame)
        animationModal.translatesAutoresizingMaskIntoConstraints = false
        animationModal.feed = self
        animationModal.didDisappear = {
            self.animationMode = false
        }
        animationModal.didAppear = {
            self.animationMode = true
        }
        return animationModal
    }
    
    func buildHierarchy(of animation: FeedAnimation) {
        self.view.addSubview(animation)
    }
    
    func setupConstraints(of animation: FeedAnimation) {
        animation.topAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true
        animation.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        animation.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor).isActive = true
        animation.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor).isActive = true
    }
    
    func didRemoveFolder() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didRemoveOnlyPost() {
        self.animation.deinitAnimation()
        self.indexPathsWithImage.removeAll()
        
        if let indexPathSelected = indexPathSelected {
            images.remove(at: indexPathSelected)
        }
    
        DispatchQueue.main.async {
            self.applySnapShot()
        }
    }
}



