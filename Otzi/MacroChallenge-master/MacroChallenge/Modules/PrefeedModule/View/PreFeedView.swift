//
//  PreFeedView.swift
//  MacroChallenge
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 08/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit

class PreFeedView : UIViewController, PreFeedViewToPresenter, SkeletonDisplayable{
    var hashtags: [HashtagSuggest]?
    
    
    var sections: [PreFeedSection] = []
    var presenter: PreFeedPresenterToView?
    
    var diffableDataSource : UICollectionViewDiffableDataSource<PreFeedSection,PreFeedData>!
    
    var connectionFlag = true
    var connectionToken = false
    
    var connectionView : UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    
    var snapShot = NSDiffableDataSourceSnapshot<PreFeedSection,PreFeedData>()
    
    //MARK: - Outlets
    var isRealData = false
    let feedCollectionView : UICollectionView = {
        
        let layout = PreFeedCustomLayout.createPreFeedLayout()
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsVerticalScrollIndicator = false
        collection.isScrollEnabled = true
        collection.showsHorizontalScrollIndicator = true
        collection.backgroundColor = .white
        collection.register(PreFeedCell.self, forCellWithReuseIdentifier: "cell")
        
        return collection
    }()
    
    
    var isPopulated = false
    //MARK: - Methods
    
    override func viewWillAppear(_ animated: Bool) {
        if !isRealData{
            presenter?.getPosts(with: hashtags!)
        }
        starMonitoringConnection()
        
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font : UIFont.init(name: "Coolvetica", size: 18) as Any]
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !isRealData{
            createLoadScreen()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        isPopulated = false
        stopMonitoringConnection()
    }
    
    override func viewDidLoad() {
        setupView()
        connectionStatusHasChange()
        createDataSource()
        feedCollectionView.delegate = self
        feedCollectionView.prefetchDataSource = self
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.willDismiss()
    }
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 3
        label.isHidden = true
        label.text = "Something goes wrong, try it again!"
        return label
    }()
    
    lazy var reloadButton: UIButton = {
        let rect = CGRect(origin: .zero, size: CGSize(width: 100, height: 38))
        let text = "Okay"
        let button = CustomExploreButton(frame: rect, text: text, tag: 1)
        button.isSelected = true
        button.addTarget(self, action: #selector(self.reloadData), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    func showErrorMessage() {
        hideSkeleton()
        self.feedCollectionView.isHidden = true
        errorLabel.isHidden = false
        reloadButton.isHidden = false
    }
    
    @objc func reloadData(){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func createDataSource(){
        diffableDataSource = UICollectionViewDiffableDataSource<PreFeedSection,PreFeedData>(collectionView: feedCollectionView, cellProvider: { (collectionView, indexPath, data) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PreFeedCell
            
            if !self.isPopulated{
                let animator = Animator(animation: .fromRight(duration: 0.3, delay: 0.3))
                animator.animate(cell, indexPath, collectionView)
            }
            
            
            
            if self.isRealData {
//                cell.titleLabel.text = "S\(indexPath.section),R:\(indexPath.row)"
                if let postDownloaded = Cache.getImageOnCache(index: indexPath){
                    DispatchQueue.main.async {
                        cell.loadView(with: postDownloaded.imageDownloaded.image)
                    }
                    cell.acticvityIndicator.isHidden = true
                    self.presenter?.pauseImageRequest(at: indexPath)
                }else{
//                    cell.loadView(with: nil)
//                    cell.showLoadingIndicator()
//                    self.presenter?.requestHashtagImages(with: data,from:title, at: indexPath)
                }
                
            }
            
            
            self.diffableDataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
                
                guard kind == UICollectionView.elementKindSectionHeader else {
                    return nil
                }
                
                let view = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier,
                    for: indexPath) as? SectionHeaderReusableView
                
                if let v = view, !self.isPopulated{
                    let animator = Animator(animation: .fromRight(duration: 0.3, delay: 0.3))
                    animator.animate(v, indexPath, collectionView)
                }
                
                let section = self.diffableDataSource.snapshot()
                    .sectionIdentifiers[indexPath.section]
                view?.titleLabel.text = "#\(section.hashtagTittle)"
                view?.presenter = self.presenter
                return view
            }
            
            return cell
            
        })
        
    }
    
    func createLoadScreen(){
        
        var datas : [PreFeedData] = []
        var dataOne : [PreFeedData] = []
        var dataTwo : [PreFeedData] = []
        
        
        for i in 0...19{
            
            let post = Post(node: NodePost(imageUrl: "\(i)", isVideo: false, descriptions: Descriptions(descriptions: [Description]()), shortcode: "\(i)"))
            datas.append(PreFeedData(postURL: "\(i)", post: post))
            
            
        }
        for i in 0...19{
            
            
            if i < 10{
                dataOne.append(datas[i])
            } else {
                dataTwo.append(datas[i])
            }
            
        }
        
        
        let sec1 = PreFeedSection(hashtagTittle: "tattootattoo", items: dataOne, endCursor: "")
        let sec2 = PreFeedSection(hashtagTittle: "Tattootattoo", items: dataTwo, endCursor: "")
        
        
        let loadData = [sec1,sec2]
        
        self.sections = loadData
       
       
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            
            if NetStatus.shared.isConnected{
                
                self.applyPreFeedSnapShot()
                self.showSkeleton()
                
            }
            
            
            
            
        }
    }
    

    func applyPreFeedSnapShot(){
        snapShot = NSDiffableDataSourceSnapshot<PreFeedSection,PreFeedData>()
        snapShot.appendSections(sections)
        var itens : [PreFeedData] = []
        for section in sections{
            let num = section.items.count > 15 ? 15 :  section.items.count
            for i in 0..<num{
                itens.append(section.items[i])
            }
            snapShot.appendItems(itens, toSection: section)
            itens.removeAll()
        }
        diffableDataSource?.apply(snapShot, animatingDifferences: false)
    }
    
    
    func getFetchedSections(with section: [PreFeedSection]) {
        self.sections.removeAll()
        hideSkeleton()
        isRealData = true
        isPopulated = true
        for item in section{
            sections.append(item)
        }
        //        sections.append(section)
        sections = uniq(source: section)
        
        
        
        applyPreFeedSnapShot()
    }
    
    func getFetchedImage(with image: UIImage, at indexPath: IndexPath,post: PreFeedData) {
        
        DispatchQueue.main.async { [self] in
            self.sections[indexPath.section].items[indexPath.row] = post
            
            if let cell = self.feedCollectionView.cellForItem(at: indexPath) as? PreFeedCell {
                if cell.imageDisplayed.image != nil{
                    cell.acticvityIndicator.isHidden = true
                    return
                }
                cell.loadView(with: image)
            } else {
                return
            }
        }
    }
    
    
    func displayConnectionScreen(){
        
        
        DispatchQueue.main.async { [self] in
            
        if !connectionToken{
            
            connectionToken = true
            
            let reloadButton: CustomExploreButton = {
            let rect = CGRect(origin: .zero, size: CGSize(width: 100, height: 38))
            let text = "Reload"
            let button = CustomExploreButton(frame: rect, text: text, tag: 1)
            button.isSelected = true
            button.addTarget(self, action: #selector(reload), for: .touchUpInside)
            button.isHidden = false
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
            
            let errorLabel: UILabel = {
                let label = UILabel()
                label.textAlignment = .center
                label.numberOfLines = 3
                label.isHidden = false
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = ServiceError.connectionError.localizedDescription
                return label
            }()
            
            self.view.addSubview(connectionView)
            self.connectionView.addSubview(reloadButton)
            self.connectionView.addSubview(errorLabel)
            
            NSLayoutConstraint.activate([
                connectionView.topAnchor.constraint(equalTo:  self.view.topAnchor, constant: 0),
                connectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
                connectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
                connectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
            ])
            
            NSLayoutConstraint.activate([errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                         errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                         errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                                         errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)])
            
            NSLayoutConstraint.activate([reloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                         reloadButton.centerYAnchor.constraint(equalTo: errorLabel.centerYAnchor,constant: 60),
                                         reloadButton.widthAnchor.constraint(equalToConstant: 80 ),
                                         reloadButton.heightAnchor.constraint(equalToConstant: 37 ),
            ])
            
            

            
        }
        }
        
            
        
        
        
        
    }
    
    func hideConnectionScreen(){
        
        DispatchQueue.main.async { [self] in
            connectionView.removeFromSuperview()
            connectionFlag = true
            connectionToken = false
        }
            
        
        
        
        
    }
    
   @objc func reload(){
        connectionStatusHasChange()
    }
}

extension PreFeedView: ViewCoding{
    func setupAdditionalConfiguration() {
        self.view.backgroundColor = .white
        
        feedCollectionView.register(
            SectionHeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier
        )
    }
    
    func buildViewHierarchy() {
        self.view.addSubview(feedCollectionView)
        self.view.addSubview(errorLabel)
        self.view.addSubview(reloadButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            feedCollectionView.topAnchor.constraint(equalTo:  self.view.topAnchor, constant: 0),
            feedCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            feedCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            feedCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        ])
        
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                                     errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)])
        
        NSLayoutConstraint.activate([reloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     reloadButton.centerYAnchor.constraint(equalTo: errorLabel.centerYAnchor,constant: 60),
                                     reloadButton.widthAnchor.constraint(equalToConstant: 110 ),
                                     reloadButton.heightAnchor.constraint(equalToConstant: 37 ),
        ])
    }
    
    
}


extension PreFeedView : UICollectionViewDelegate, UICollectionViewDataSourcePrefetching{
   
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if isRealData{
            self.presenter?.requestHashtagImages(with: sections[indexPath.section].items[indexPath.row],from:sections[indexPath.section].hashtagTittle, at: indexPath)
            (cell as? PreFeedCell)?.showLoadingIndicator()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hashtag = HashtagSuggest(text: sections[indexPath.section].hashtagTittle)
        hashtag.text = hashtag.text.replacingOccurrences(of: "#", with: "")
        let itens = presenter?.getPostsCache(from: sections[indexPath.section].hashtagTittle)
        if let datas = itens{
            sections[indexPath.section].items.append(contentsOf: datas)
        }
        presenter?.goToFeed(with: [hashtag], with: sections[indexPath.section])
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if isRealData{
            for indexPath in indexPaths {
                let model = sections[indexPath.section].items[indexPath.row]
                let title = self.sections[indexPath.section].hashtagTittle
                presenter?.requestHashtagImages(with: model, from: title, at: indexPath)
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        if isRealData{
            for indexPath in indexPaths {
                presenter?.pauseImageRequest(at: indexPath)
            }
        }
    }
    
}

extension PreFeedView{


    func starMonitoringConnection() {
        NetStatus.shared.startMonitoring()
    }

    func stopMonitoringConnection() {
        NetStatus.shared.stopMonitoring()
    }

    func connectionStatusHasChange(){
        NetStatus.shared.netStatusChangeHandler = { [self] in
            
            if NetStatus.shared.isConnected{
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    if !connectionFlag {
                        hideConnectionScreen()
                        createLoadScreen()
                        self.presenter?.getPosts(with: hashtags!)
                    }
                }
                
            }else{
                presenter?.internetFailed()
                connectionFlag = false
                displayConnectionScreen()
                hideSkeleton()
            }
            
        }
    }

    func deviceIsConnected() -> Bool{
        return Connectivity.isConnectedToInternet
    }

}
