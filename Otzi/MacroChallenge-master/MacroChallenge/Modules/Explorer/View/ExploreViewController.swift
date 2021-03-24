//
//  ExploreViewController.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 22/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit
import WebKit

fileprivate enum ExploreButtons: Int{
    case searchByText = 1
    case searchBySuggest = 2
    case searchByMap = 3
    case searchByFavorite = 4
}
public enum HashtagsType{
    case Suggest
    case Favorites
}

class ExploreViewController: UIViewController{
    
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
    
    lazy var acticvityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .black
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    var searchItem : UIBarButtonItem!
    
    var mapItem : UIBarButtonItem!
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 3
        label.font = UIFont.init(name: "Coolvetica", size: 25)
        label.isHidden = true
        return label
    }()
    
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "Coolvetica", size: 28)//UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        label.minimumScaleFactor = 0.5
        label.textColor = ViewColor.ExploreView.CustomButtonTintColor.color
        label.text = "Explore"
        return label
    }()
    
    ///CollectionView data source
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, HashtagSuggest>!
    ///CollectionView delegate
    private let collectionViewDelegate = ExploreViewDelegate(numberMaxOfSelectedItens: 5)
    ///CollectionView cell id
    private let exploreCellID = "exploreCellID"
    ///Coleção com as hashtags sugeridas
    private var hashtags: [HashtagSuggest] = [HashtagSuggest]()
    ///Coleção com as hashtags selecionadas
    private var selectedHashtags: [HashtagSuggest] = [HashtagSuggest](){
        didSet{
            if selectedHashtags.isEmpty{
                self.navigationItem.setRightBarButton(seachButton, animated: true)
                self.navigationItem.leftBarButtonItem = nil//setLeftBarButton(mapButton, animated: true)
                self.navigationItem.title = "Explore"
            }else{
                self.navigationItem.title = "\(selectedHashtags.count) Selected(s)"
                self.navigationItem.setLeftBarButton(cancelSeletedsButton, animated: true)
                self.navigationItem.setRightBarButton(confirmButton, animated: true)
            }
        }
    }
    
    lazy var confirmButton: UIBarButtonItem = {
        let confirmButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(confirmedButtonTapped))
        confirmButton.imageInsets = UIEdgeInsets(top: 0, left: 0.5, bottom: 0, right: 0)
        confirmButton.isEnabled = true
        confirmButton.tintColor = UIColor(red: 185/255, green: 139/255, blue: 14/255, alpha: 1.0)
        return confirmButton
    }()
    
    lazy var seachButton: UIBarButtonItem = {
        let imgSearch = UIImage(named: "LupaSearch")?.withRenderingMode(.alwaysOriginal)
        let searchItem = UIBarButtonItem(image: imgSearch, style: .plain, target: self, action: #selector(buttonTapped))
        searchItem.isEnabled = true
        searchItem.tag = ExploreButtons.searchByText.rawValue
        return searchItem
    }()
    
    lazy var mapButton: UIBarButtonItem = {
        let imgMap = UIImage(named: "MapSearch")?.withRenderingMode(.alwaysOriginal)
        let mapItem = UIBarButtonItem(image: imgMap, style: .plain, target:self, action: #selector(buttonTapped))
        mapItem.imageInsets = UIEdgeInsets(top: 0, left: 0.5, bottom: 0, right: 0)
        mapItem.isEnabled = true
        mapItem.tag = ExploreButtons.searchByMap.rawValue
        
        return mapItem
    }()
    
    
    
    lazy var cancelSeletedsButton: UIBarButtonItem = {
        let cancel = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelSelection))
        cancel.isEnabled = true
        cancel.title = "Cancel"
        cancel.tintColor = UIColor(red: 62/255, green: 61/255, blue: 61/255, alpha: 1.0)
        return cancel
    }()
    var presenter: ExplorePresenterToView? = nil
    
    var selectedIndexPaths = [IndexPath]()
    
    var hashtagsType: HashtagsType = .Suggest
    
    //MARK: -> View LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Explore"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font : UIFont.init(name: "Coolvetica", size: 18) as Any]
        self.collectionView.deselectAllItems(animated: false)
        if hashtagsType == .Favorites{
            self.presenter?.fetchHashtags(hashtagsType, reloadContent: false)
        }
        
        
    }
    
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.resetView()
    }
    
//    let web = WKWebView()
    override func viewDidLoad() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")

        setupView()
        setupCollectionView()
        presenter?.fetchHashtags(hashtagsType, reloadContent: false)
        
//        
//        let url = URL(string:"https://www.instagram.com/accounts/login/")!
//
//        view = web
//
//        web.load(URLRequest(url: url))
    }
    

    
    
    /// Método chamado quando usuário clica em uns do botão de navegação da explore view
    /// Irá identificar o botão através do sender.tag
    /// - Parameter sender: UIButton - Botão que foi clicado
    @objc func buttonTapped(sender: UIButton){
        switch sender.tag {
        case ExploreButtons.searchByMap.rawValue:
            resetView()
            presenter?.goToMapView(from: self)
        case ExploreButtons.searchByText.rawValue:
            presenter?.goToSearchView(from: self)
            resetView()
        default:
            print("")
        }
        
    }
    
    
    
    /// Método chamado quando usuário clicar no botão confirmar seleção
    @objc private func confirmedButtonTapped(){
        guard !selectedHashtags.isEmpty else {return}
        presenter?.goToPreFeed(hashtags: selectedHashtags, from: self)
        resetView()
    }
    
    
    @objc private func cancelSelection(){
        selectedHashtags.removeAll()
        collectionView.deselectAllItems(animated: true)
    }
    
    /// Método auxiliar para resetar o estado inicial da view
    private func resetView(){
        //tabBarDelegate?.changeTabBarState(tabBar: .showNormalTabBar)
        collectionView.deselectAllItems(animated: false)
        selectedHashtags.removeAll()
    }
    

    @objc func reloadColletionView(){
        presenter?.fetchHashtags(hashtagsType, reloadContent: true)
    }
    
}

//MARK: -> ViewCoding
extension ExploreViewController: ViewCoding{
    
    func buildViewHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(acticvityIndicator)
        view.addSubview(errorLabel)
    }
    
    func setupConstraints() {
        
        acticvityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([acticvityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     acticvityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 15)])
    
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 0),
            collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,constant: 0)
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
        acticvityIndicator.isHidden = false
        acticvityIndicator.startAnimating()
        setupNaviBar()
        
    }
    
    func setupNaviBar(){
        self.selectedHashtags = []
    }
}


//MARK: -> DataSource
extension ExploreViewController: UICollectionViewDelegate{
    
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
            self.selectedHashtags.append(self.hashtags[indexpath.row])
            self.selectedIndexPaths.append(indexpath)
        }
        
        collectionViewDelegate.didDeselectItemAt = { [weak self] indexpath  in
            guard let self = self else {return}
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

extension ExploreViewController: ExploreViewToPresenter{
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
        self.acticvityIndicator.stopAnimating()
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
