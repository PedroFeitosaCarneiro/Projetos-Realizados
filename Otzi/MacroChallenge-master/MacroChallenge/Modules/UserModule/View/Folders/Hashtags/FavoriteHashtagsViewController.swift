//
//  FavoriteHashtagsViewController.swift
//  MacroChallenge
//
//  Created by Fábio França on 06/11/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit

class FavoriteHashtagsViewController: UIViewController{
    
    //MARK: -> Views
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: ExploreCollectionViewCustomLayout.create())
        collectionView.isDirectionalLockEnabled = true
        collectionView.alwaysBounceVertical = true
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.isPagingEnabled = false
        collectionView.isScrollEnabled = true
        collectionView.isUserInteractionEnabled = true
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        collectionView.register(ExploreCell.self, forCellWithReuseIdentifier: self.exploreCellID)
        collectionView.backgroundColor = .white
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector((reloadColletionView)), for: .valueChanged)
        collectionView.refreshControl = refresh
        return collectionView
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 3
        label.font = UIFont.init(name: "Coolvetica", size: 25)
        label.isHidden = true
        return label
    }()
    
    lazy var confirmButton: UIBarButtonItem = {
        let confirmButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(confirmedButtonTapped))
        confirmButton.imageInsets = UIEdgeInsets(top: 0, left: 0.5, bottom: 0, right: 0)
        confirmButton.isEnabled = true
        confirmButton.tintColor = UIColor(red: 185/255, green: 139/255, blue: 14/255, alpha: 1.0)
        return confirmButton
    }()
    
    lazy var cancelButton: UIBarButtonItem = {
        let cancel = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelSelection))
        cancel.isEnabled = true
        cancel.title = "Cancel"
        cancel.tintColor = UIColor(red: 62/255, green: 61/255, blue: 61/255, alpha: 1.0)
        return cancel
    }()
    
    ///CollectionView data source
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, HashtagSuggest>!
    ///CollectionView delegate
    private let collectionViewDelegate = ExploreViewDelegate(numberMaxOfSelectedItens: 2)
    ///CollectionView cell id
    private let exploreCellID = "exploreCellID"
    ///Coleção com as hashtags sugeridas
    private var hashtags: [HashtagSuggest] = [HashtagSuggest]()
    ///Coleção com as hashtags selecionadas
    private var selectedHashtags: [HashtagSuggest] = [HashtagSuggest](){
        didSet{
            if selectedHashtags.isEmpty{
                // MARK: -> Colocar tabbar em normal state
                self.parent?.navigationItem.setRightBarButton(nil, animated: true)
                self.parent?.navigationItem.setLeftBarButton(nil, animated: true)
                self.parent?.navigationItem.title = "Favorites"
            }else{
                // MARK: -> Colocar tabbar em confirmed state
                self.parent?.navigationItem.title = "\(selectedHashtags.count) Selected(s)"
                self.parent?.navigationItem.setLeftBarButton(cancelButton, animated: false)
                self.parent?.navigationItem.setRightBarButton(confirmButton, animated: false)
            }
        }
    }
    
    var presenter: ExplorePresenterToView? = nil
    var selectedIndexPaths = [IndexPath]()
    var hashtagsType: HashtagsType = .Suggest
    var selectedIndexPath: IndexPath?
    
    //MARK: -> View LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.deselectAllItems(animated: false)
        presenter?.fetchHashtags(.Favorites, reloadContent: false)
        
        self.parent?.navigationController?.navigationBar.tintColor = ViewColor.FeedView.NavigationBackButton.color
        self.parent?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ViewColor.FeedView.NavigationTitle.color]
        self.parent?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.heavy)]
        
        self.parent?.navigationController?.navigationBar.isHidden = false
        self.parent?.navigationItem.setRightBarButton(confirmButton, animated: false)
        self.parent?.navigationItem.setLeftBarButton(cancelButton, animated: false)
        
        self.selectedHashtags.removeAll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.selectedHashtags.removeAll()
        self.selectedIndexPath = nil
        self.selectedIndexPaths.removeAll()
    }
    
    override func viewDidLoad() {
        setupView()
        setupCollectionView()
        // MARK: -> Fetching na Hashtag
        presenter?.fetchHashtags(.Favorites, reloadContent: false)
        
    }
    
    /// Método chamado quando usuário clicar no botão confirmar seleção
    @objc private func confirmedButtonTapped(){
        guard !selectedHashtags.isEmpty else {return}
        //presenter?.goToPreFeed(hashtags: selectedHashtags, from: self)
        presenter?.goToFeed(hashtags: selectedHashtags, from: self)
        resetView()
    }
    
    @objc private func cancelSelection() {
        selectedHashtags.removeAll()
        collectionView.deselectAllItems(animated: true)
    }
    
    /// Método auxiliar para resetar o estado inicial da view
    private func resetView(){
        collectionView.deselectAllItems(animated: false)
        selectedHashtags.removeAll()
    }
    
    @objc func reloadColletionView(){
        if hashtagsType == .Favorites {
            collectionView.refreshControl?.endRefreshing()
            return
        }
        
        // MARK: -> Fetching na Hashtag
        presenter?.fetchHashtags(.Favorites, reloadContent: false)
    }
    
    
}

//MARK: -> ViewCoding
extension FavoriteHashtagsViewController: ViewCoding{
    
    func buildViewHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(errorLabel)
    }
    
    func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 15),
            collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: 0)
        ])
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                                     errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)])
        
    }
    
    func setupAdditionalConfiguration() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Explore"
        view.backgroundColor = .white
    }

}


//MARK: -> DataSource
extension FavoriteHashtagsViewController: UICollectionViewDelegate{
    
    /// Método que faz configurações adicionais na collectionView
    private func setupCollectionView(){
        
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        diffableDataSource = UICollectionViewDiffableDataSource<Section, HashtagSuggest>(collectionView: collectionView, cellProvider: { [self] (collectionView, indexPath, hashtag) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.exploreCellID, for: indexPath) as? ExploreCell else {
                return UICollectionViewCell()
            }
            for index in self.selectedIndexPaths{
                if index == indexPath{
                    cell.setupSelectedCell()
                }else{
                    cell.setupNotSelectedCell()
                }
            }
            cell.populate(with: hashtag)
            
            // MARK: -> Fetch Image
            
            if let img = presenter?.getImageOnCache(by: hashtag.urlImage){
                DispatchQueue.main.async {
                    cell.populate(with: img)
                }
            }else{
                presenter?.fetchImage(from: hashtag, index: indexPath)
            }
            return cell
            
        })

        collectionViewDelegate.didSelectItemAt = { [weak self] indexpath  in
            guard let self = self else {return}
            self.selectedHashtags.removeAll()
            self.selectedIndexPaths.removeAll()
            
            if let selectedIndexPath = self.selectedIndexPath {
                self.collectionView.deselectItem(at: selectedIndexPath, animated: true)
            }
            
            self.selectedHashtags.append(self.hashtags[indexpath.row])
            self.selectedIndexPaths.append(indexpath)
            self.selectedIndexPath = indexpath
        }
        
        collectionViewDelegate.didDeselectItemAt = { [weak self] indexpath  in
            guard let self = self else {return}
            self.selectedIndexPath = nil
            self.selectedHashtags = self.selectedHashtags.filter {$0 != self.hashtags[indexpath.row]}
        }
        
        collectionView.delegate = collectionViewDelegate
        
        collectionView.dataSource = diffableDataSource
    }
    
    
    
    private func buildAndApplySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, HashtagSuggest>()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(hashtags,toSection: Section.main)
        
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

extension FavoriteHashtagsViewController: ExploreViewToPresenter{
    func updateCell(from index: IndexPath, url: String, image: UIImage?) {
        
        DispatchQueue.main.async { [self] in
            guard self.hashtags.count-1 >= index.row else {
                return
            }
            self.hashtags[index.row].urlImage = url
            if let cell = self.collectionView
                .cellForItem(at: index) as? ExploreCell, let image = image {
                cell.populate(with: image)
            }else{
                self.presenter?.fetchImage(from: self.hashtags[index.row], index: index)
            }
        }
    }
    
    func showHashtags(hashtags: [HashtagSuggest]) {
        collectionView.isHidden = false
        collectionView.refreshControl?.endRefreshing()
        self.hashtags.removeAll()
        self.hashtags.append(contentsOf: hashtags)
        errorLabel.isHidden = true
        buildAndApplySnapshot()
    }
    
    func showErrorMsg(_ error: String) {
        showHashtags(hashtags: [HashtagSuggest]())
        errorLabel.text = error
        errorLabel.isHidden = false
        collectionView.isHidden = true
    }
}


/// Enum para representar as sections da collectionView
fileprivate enum Section{
    case main
}

