//
//  OnBoardViewController.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 25/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

class OnBoardViewController: UIViewController, OnboardingPage {
    
    private enum Section{
        case main
    }

    //MARK: -> View
    lazy var backgroundImage: UIImageView = {
       let img = UIImageView(image: UIImage(named: "backgrounOnBoarding"))
        img.contentMode = .scaleAspectFill
        img.backgroundColor = .lightGray
       return img
    }()
    
    lazy var layerView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.isHidden = false
        label.font = UIFont.init(name: "Coolvetica", size: 40)
        label.minimumScaleFactor = 0.5
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.text = pageModel.titleText
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.isHidden = false
        label.font = UIFont.init(name: "SourceSansPro-Regular", size: 18)
        label.minimumScaleFactor = 0.5
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
        label.text = pageModel.subTitleText
        return label
    }()
    
    
    ///CollectionView data source
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, HashtagSuggest>!
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: OnboardingLayout.create())
        collectionView.isDirectionalLockEnabled = true
        collectionView.alwaysBounceVertical = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.isPagingEnabled = false
        collectionView.isScrollEnabled = false
        collectionView.isUserInteractionEnabled = true
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        collectionView.register(OnboardingCell.self, forCellWithReuseIdentifier: OnboardingCell.reuseIdentifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    
    lazy var skipButton: UIButton = {
        let rect = CGRect(origin: .zero, size: CGSize(width: 80, height: 27))
        let text = "Skip"
        let button = OnboardingButton(text: text, fontSize: 16)
        button.addTarget(self, action: #selector(self.skipButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let text = "Next"
        let button = OnboardingButton(text: text, fontSize: 20)
        button.addTarget(self, action: #selector(self.nextButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
   
    let pageModel: PageModel

    
    
    var pageDelegate: WalkThroughOnBoardDelegate?

  
    
    var selectedItens: [HashtagSuggest] = []{
        didSet{
            let canContinue = !selectedItens.isEmpty
                nextButton.isEnabled = canContinue
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        buildAndApplySnapshot()
    }
    
    init(pageModel: PageModel) {
        self.pageModel = pageModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    /// Método chamando quando o skip de voltar é clicado
    @objc func skipButtonTapped(){
        pageDelegate?.skipOnboarding()
//        pageDelegate?.goNextPage(fowardTo: .loginPage)
    }
    /// Método chamando quando o botão de próximo é clicado
    @objc func nextButtonTapped(){
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        pageDelegate?.didFinishPage(with: selectedItens)
        pageDelegate?.goNextPage(fowardTo: pageModel.nextPage)
    }
    
}



extension OnBoardViewController: ViewCoding{
    func buildViewHierarchy() {
        view.addSubview(backgroundImage)
        view.addSubview(layerView)
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(skipButton)
        view.addSubview(collectionView)
        view.addSubview(nextButton)
    }
    
    func setupConstraints() {
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([backgroundImage.heightAnchor.constraint(equalTo: view.heightAnchor),
                                     backgroundImage.widthAnchor.constraint(equalTo: view.widthAnchor),
                                     backgroundImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        layerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([layerView.heightAnchor.constraint(equalTo: view.heightAnchor),
                                     layerView.widthAnchor.constraint(equalTo: view.widthAnchor),
                                     layerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     layerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([skipButton.heightAnchor.constraint(equalToConstant: 35),skipButton.widthAnchor.constraint(equalToConstant:55),
                                     skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),skipButton.topAnchor.constraint(equalTo: view.topAnchor,constant: 60)])
        
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([titleLabel.topAnchor.constraint(equalTo: skipButton.bottomAnchor,constant: 30),
                                     titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     titleLabel.heightAnchor.constraint(equalToConstant: 40),
                                     titleLabel.widthAnchor.constraint(equalToConstant: 330)])
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([subTitleLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor,constant: 35),
                                     subTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     subTitleLabel.heightAnchor.constraint(equalToConstant: 25),
                                     subTitleLabel.widthAnchor.constraint(equalToConstant: 330)])
    
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 45),
                                     collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 0),
                                     collectionView.bottomAnchor.constraint(equalTo: nextButton.topAnchor,constant: -40),
                                     collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: 0)])
        

        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([nextButton.heightAnchor.constraint(equalToConstant: 35),nextButton.widthAnchor.constraint(equalToConstant:110),
                                     nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -60)])
        
    }
    
    func setupAdditionalConfiguration() {
        skipButton.isHidden = true
        setupCollectionView()
    }
}

//MARK: -> DataSource
extension OnBoardViewController: UICollectionViewDelegate{
    
    /// Método que faz configurações adicionais na collectionView
    private func setupCollectionView(){
        
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        diffableDataSource = UICollectionViewDiffableDataSource<Section, HashtagSuggest>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, hashtag) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCell.reuseIdentifier, for: indexPath) as? OnboardingCell else {
                return UICollectionViewCell()
            }
            cell.populate(with: hashtag)
            return cell
            
        })
        
        collectionView.delegate = self

    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItens.append(pageModel.contents[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        selectedItens = selectedItens.filter {$0 != pageModel.contents[indexPath.row]}
    }
    private func buildAndApplySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, HashtagSuggest>()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(pageModel.contents,toSection: Section.main)
        
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
}
