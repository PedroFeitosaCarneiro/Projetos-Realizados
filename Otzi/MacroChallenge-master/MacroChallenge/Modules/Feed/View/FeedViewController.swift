//
//  FeedViewController.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 08/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit


/// Enum que indica os estados de uma view
public enum ViewState{
    case firstLoad
    case featchingData
    case error
    case finished
    case emptyData
}
public enum FaviteButtonStatus{
    case Favorited
    case NotFavorited
}

class FeedViewController: UIViewController, FeedViewToPresenter,SkeletonDisplayable {
   
    
    
    //MARK: -> Properties
    var presenter: FeedPresenterToView?
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, Post>?
    
    private var sectionsWithImagens = Section.sectionsWithPosts
    
    private let feedCellID = "feedCellID"
    
    private let feedCollectionViewDelegate = FeedViewDelegate()
    
    var currentHashtag: String?
    
    
    //MARK: -> Views
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: FeedCustomLayout.createCustomLayout())
        collectionView.isDirectionalLockEnabled = false
        collectionView.alwaysBounceVertical = false
        collectionView.contentInsetAdjustmentBehavior = .never
        
                collectionView.isPagingEnabled = false
        collectionView.isScrollEnabled = true
        collectionView.isUserInteractionEnabled = true
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: self.feedCellID)
        collectionView.backgroundColor = .white
        collectionView.contentSize.height = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.alwaysBounceHorizontal = true
        return collectionView
    }()
    
    var animationModal: FeedAnimation?
    
    lazy var acticvityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .black
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = true
        return activityIndicator
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 3
        label.isHidden = true
        return label
    }()
    
    lazy var reloadButton: UIButton = {
        let rect = CGRect(origin: .zero, size: CGSize(width: 100, height: 38))
        let text = "Reload"
        let button = CustomExploreButton(frame: rect, text: text, tag: 1)
        button.isSelected = true
        button.addTarget(self, action: #selector(self.reloadData), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    var isAnimationModalShowed: Bool = false {
        didSet {
            if isAnimationModalShowed {
                self.navigationItem.rightBarButtonItem = nil
            } else {
                self.navigationItem.rightBarButtonItem = self.favoriteButton
            }
        }
    }
    
    ///var que indica o estado da viewController
    public var appState: ViewState!{
        didSet{
            switch appState {
            case .firstLoad:
                
                DispatchQueue.main.async { [self] in
                    self.acticvityIndicator.isHidden = true
                    self.errorLabel.isHidden = true
                    self.presenter?.fetchData()
                    self.collectionView.isHidden = false
                }
            case .emptyData:
                DispatchQueue.main.async {
                    self.acticvityIndicator.stopAnimating()
                    self.errorLabel.isHidden = false
                    self.reloadButton.isHidden = false
                    self.collectionView.isHidden = true
                }
            case .featchingData:
                
                DispatchQueue.main.async {[self] in
                    self.errorLabel.isHidden = true
                    self.presenter?.fetchData()
                    self.collectionView.isHidden = true
                }
            case .finished:
                DispatchQueue.main.async {
                    self.acticvityIndicator.stopAnimating()
                    self.errorLabel.isHidden = true
                    self.collectionView.reloadData()
                    self.reloadButton.isHidden = true
                    self.collectionView.isHidden = false
                }
            case .error:
                DispatchQueue.main.async {
                    self.acticvityIndicator.stopAnimating()
                    self.acticvityIndicator.isHidden = true
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = ServiceError.connectionError.localizedDescription
                    self.reloadButton.isHidden = false
                    self.collectionView.isHidden = true
                }
            default:
                print("default")
            }
        }
    }
    
    let queue = DispatchQueue(label: "PrefetchQueue", qos: .userInteractive, attributes: .concurrent)

    
    
    var backButton: UIBarButtonItem!
    var favoriteButton : UIBarButtonItem!
    var oldFavoriteButton : UIBarButtonItem!
    var footerView: CustomFooterView?
    var lastContentOffesetX: CGFloat = 0
    let footerViewReuseIdentifier = "RefreshFooterView"
    private var hasReachToTheEnd = false
    
    private var isPopulated = false
    
    
    //MARK:-> View LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "#".appending(currentHashtag ?? "Feed")
        self.navigationController?.navigationBar.tintColor = ViewColor.FeedView.NavigationBackButton.color
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ViewColor.FeedView.NavigationTitle.color]
        self.navigationController?.navigationBar.isHidden = false
        self.setupAdditionalConfiguration()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
        
        if !isPopulated{
            showSkeleton()
        }
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionView()
        self.view.backgroundColor = .white
        appState = .firstLoad
        self.feedCollectionViewDelegate.animation = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        hasReachToTheEnd = false
        
    }

    
    @objc func didTapLeftBatButton(){
        print("Clicouuu")
    }
    //MARK: -> FeedViewToPresenter
    
    func showData(posts: [Post]) -> Void{
        if sectionsWithImagens[0].posts == nil{
            sectionsWithImagens[0].posts = [Post]()
            hideSkeleton()
            isPopulated = true
        }
        sectionsWithImagens[0].posts?.append(contentsOf: posts)
        appState = .finished
        self.footerView?.stopAnimate()
    }
    

    func showErrorMsg(_ error: ServiceError) {
        hideSkeleton()
        if !(sectionsWithImagens[0].posts?.isEmpty ?? true) && error == ServiceError.emptyData{
            hasReachToTheEnd = true
            return
        }
        
        DispatchQueue.main.async { [self] in
            self.errorLabel.text = error.localizedDescription
            self.errorLabel.isHidden = false
        }
        self.appState = error == ServiceError.emptyData ? ViewState.emptyData : ViewState.error
        
    }
    
    func updatePost(from index: IndexPath, post: Post, image: UIImage?) {
        updateCell(at: index, post: post, image: image)
    }
    
    
    @objc func reloadData(){
        
        appState = .featchingData
        self.acticvityIndicator.isHidden = false
        self.acticvityIndicator.startAnimating()
    }
    
}

//MARK: -> ViewCoding
extension FeedViewController: ViewCoding{
    
    func buildViewHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(errorLabel)
        view.addSubview(reloadButton)
        view.addSubview(acticvityIndicator)
    }
    
    func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        acticvityIndicator.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 20),
            collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,constant: 5)
        ])
        
        NSLayoutConstraint.activate([acticvityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     acticvityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 15)])
        
        NSLayoutConstraint.activate([errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                                     errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)])
        
        NSLayoutConstraint.activate([reloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     reloadButton.centerYAnchor.constraint(equalTo: errorLabel.centerYAnchor,constant: 60),
                                     reloadButton.widthAnchor.constraint(equalToConstant: 100 ),
                                     reloadButton.heightAnchor.constraint(equalToConstant: 37 ),
        ])
    }
    
    
    func setupAdditionalConfiguration() {
        acticvityIndicator.isHidden = true
        backButton = UIBarButtonItem(title: "Back", style: .done, target: self, action:  #selector(cancelAction))
        
        if let font = UIFont(name: "Coolvetica", size: 18) {
            backButton.setTitleTextAttributes([NSAttributedString.Key.font : font], for: .normal)
        }
        self.navigationItem.setLeftBarButton(backButton, animated: true)
        
        backButton.isEnabled = true
        
        let img = UIImage(named: "FavoriteBlankButton")?.withRenderingMode(.alwaysOriginal)
        favoriteButton = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(favoriteHashtagAction))
        favoriteButton.imageInsets = UIEdgeInsets(top: 0, left: 0.5, bottom: 0, right: 0)
        favoriteButton.isEnabled = true
        self.navigationItem.setRightBarButton(favoriteButton, animated: true)
        
    }
    
    
    @objc func cancelAction(){
        
        guard isAnimationModalShowed else {
            self.presenter?.viewWillDismiss(from: self)
            isPopulated = false
            return
        }
        
        self.animationModal?.deinitAnimation()
        
    }
    
    @objc func favoriteHashtagAction(){
        presenter?.saveHashtag()
    }
    
    func updateFavoriteButton(status: FaviteButtonStatus) {
        if status == .NotFavorited{
            favoriteButton.image = UIImage(named: "FavoriteBlankButton")?.withRenderingMode(.alwaysOriginal)
        }else{
            favoriteButton.image = UIImage(named: "FavoriteGrayButton")?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    
    
    
}

extension FeedViewController: AnimationProtocol {
    
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
            self.isAnimationModalShowed = false
        }
        animationModal.didAppear = {
            self.isAnimationModalShowed = true
            self.collectionView.isUserInteractionEnabled = true
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
    
}


//MARK: -> DataSource

extension FeedViewController: UICollectionViewDataSource, UICollectionViewDataSourcePrefetching{
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let model = sectionsWithImagens[0].posts?[indexPath.row]{
                presenter?.fetchImage(with: model, from: indexPath)
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            presenter?.pauseImageRequest(at: indexPath)
        }
    }
    
    
    private func updateCell(at indexPath: IndexPath, post: Post, image: UIImage?) {
        
        DispatchQueue.main.async { [self] in
            
            if let cell = self.collectionView
                .cellForItem(at: indexPath) as? FeedCell, let image = image {
                self.sectionsWithImagens[0].posts?[indexPath.row] = post
                cell.populate(with: image)
                cell.post = post
            }
        
        }
   
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sectionsWithImagens[0].posts?.count ?? 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       return confiCell(index: indexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath) as! CustomFooterView
            self.footerView = aFooterView
            self.footerView?.backgroundColor = UIColor.clear
            return aFooterView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath)
            return headerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.footerView?.prepareInitialAnimation()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.footerView?.stopAnimate()
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width/4, height:  collectionView.bounds.height)
    }
    
    
    private func setupCollectionView(){
        
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: self.feedCellID)
        collectionView.register(CustomFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerViewReuseIdentifier)
        
        collectionView.delegate = feedCollectionViewDelegate
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.isPrefetchingEnabled = true  
        feedCollectionViewDelegate.didScroll = { [self] (scrollView) in
            
            let threshold = 10
            let contentOffset = scrollView.contentOffset.x
            let contentWidth = scrollView.contentSize.width
            let diffWidth = contentWidth - contentOffset
            let frameWidth = scrollView.bounds.size.width
            var triggerThreshold  = Float((diffWidth - frameWidth))/Float(threshold);
            triggerThreshold   =  min(triggerThreshold, 0.0)
            let pullRatio  = min(abs(triggerThreshold),1.0)
            
            
            if contentOffset > contentWidth - scrollView.frame.size.width && self.appState == .finished && !hasReachToTheEnd{
                self.footerView?.backgroundColor = .white
                self.footerView?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
                self.footerView?.startAnimate()
                self.appState = .featchingData
                if pullRatio >= 1 {
                    self.footerView?.animateFinal()
                }
            }
        }

        feedCollectionViewDelegate.willDisplayItemAt = { [self] indexPath in
            self.presenter?.fetchImage(with:  self.sectionsWithImagens[0].posts?[indexPath.row], from: indexPath)
        }

        feedCollectionViewDelegate.didEndDisplaying = {indexPath in
            self.presenter?.pauseImageRequest(at: indexPath)
        }

        
        feedCollectionViewDelegate.willBeginDragging = {
            self.presenter?.suspendAllOperations()
        }

        feedCollectionViewDelegate.didEndDragging = {
            self.presenter?.loadImagesForOnscreenCells(indexPathsForVisibleRows: self.collectionView.indexPathsForVisibleItems)
            self.presenter?.resumeAllOperations()
        }

        self.feedCollectionViewDelegate.didEndDecelerating = { _ in
            self.presenter?.loadImagesForOnscreenCells(indexPathsForVisibleRows: self.collectionView.indexPathsForVisibleItems)
            self.presenter?.resumeAllOperations()
        }
    }
    
    
    
    private func confiCell(index: IndexPath)->UICollectionViewCell{
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.feedCellID, for: index) as? FeedCell else {
            return UICollectionViewCell()
        }
        cell.titleLabel.text = "\(index.row)"
        if let postDownloaded = Cache.getImageOnCache(index: index){
            presenter?.pauseImageRequest(at: index)
            cell.populate(with: postDownloaded.imageDownloaded.image)
            cell.post = postDownloaded.post

        }else{
            if  self.sectionsWithImagens[0].posts != nil {
                cell.acticvityIndicator.isHidden = false
                cell.acticvityIndicator.startAnimating()
            }
        }
        
        if !isPopulated {
            let animator = Animator(animation: .fromRight(duration: 0.3, delay: 0.3))
            animator.animate(cell, index, collectionView)
        }
    
//        cell.vc = self
        return cell
    }
    
}


/// Enum para as seções do feed
private enum Section: Hashable{
    
    case main
    
    static var sectionsWithPosts: [(section: Section, posts: [Post]?)] {
        [
            (.main, nil),
        ]
    }
}







