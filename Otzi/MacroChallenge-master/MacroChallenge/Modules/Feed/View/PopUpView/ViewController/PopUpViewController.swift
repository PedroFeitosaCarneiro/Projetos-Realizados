//
//  PopupViewController.swift
//  MacroChallenge
//
//  Created by Lelio Jorge Junior on 23/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit

/// PopUpViewController gerencia a PopUpView.
class PopUpViewController: UIViewController {
    
    lazy var popUpView: PopUpView = {
        let view = PopUpView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.delegate = self
        return view
    }()
    
    private let alertTableViewCellID = "AlerTableViewtCell"
    
    var post: Post!
    
    var feed: AnimationProtocol?
    
    var presenter: PopUpPresenterToViewProtocol?
    
    var image: UIImage? {
        didSet {
            
            popUpView.add(image: image!)
          
            let descriptions = post.node.descriptions.descriptions
            var description: String = String()
            descriptions.forEach{description.append($0.node.descriptionText)}
            let newDescription = self.presenter?.setup(description: description)
            popUpView.add(description: newDescription ?? "")
            
        }
    }
    
    private var folders: [String]? {
        didSet{
            alertTableView?.reloadData()
        }
    }
    
    private var folderSelected: String?
    
    private var alertTableView: AlertTableView?
    
    public var owner: String? {
        didSet{
            guard let owner = owner else {
                return
            }
            popUpView.add(owner: owner)
        }
    }
    
    init(post: Post) {
        super.init(nibName: nil, bundle: nil)
        self.post = post
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard owner == nil else {
            return
        }
        if post.isPostInstagram {
            self.getOwner()
        } else {
            owner = " "
        }
    }
    
    /// Anima a popView.
    func animated() {
        popUpView.isAnimated = popUpView.isAnimated ? false : true
    }
    
    /// Soliciata o nome dono do post.
    func getOwner() {
        
        self.presenter?.owner(post: &post, { [weak self] (owner, error) in
            switch error {
                
            case .none:
                self?.owner = owner
            case .some(_):
                self?.owner = "Unknowned"
            }
        })
    }
    
    /// Cria botões  do tipo cancel para o alerta.
    /// - Parameter title: String
    /// - Parameter completion: ((UIAlertAction) -> Void)?
    /// - Returns: UIAlertAction
    func createCancelButtonAction(title: String, completion: ((UIAlertAction) -> Void)?) -> UIAlertAction {
        
        let cancel = UIAlertAction(title: title, style: .cancel, handler: completion)
        cancel.setValue(UIColor.init(red: 106/255, green: 106/255, blue: 106/255, alpha: 1), forKey: "titleTextColor")
        
        return cancel

    }
    
    /// Criar botões do tipo default para o alerta
    /// - Parameters:
    ///   - title: Titúlo do botão.
    ///   - completion: ((UIAlertAction) -> Void)?
    /// - Returns: UIAlertAction
    func createButtonAction(title: String, completion: ((UIAlertAction) -> Void)?) -> UIAlertAction {
        
        let action = UIAlertAction(title: title, style: .default, handler: completion)
        action.setValue(UIColor.init(red: 101/255, green: 101/255, blue: 101/255, alpha: 1), forKey: "titleTextColor")
        
        return action

    }
    
    /// Apresenta um alerta para colocar o nome de uma pasta.
    /// - Parameter completion: @escaping (String) -> Void
    private func showAlertFolder(_ completion: @escaping (String) -> Void) {
        
        let alert = UIAlertController(title: "New Folder", message: nil, preferredStyle: .alert)
        
        let cancel = createCancelButtonAction(title: "Cancel", completion: {_ in
            alert.dismiss(animated: true, completion: nil)
        })
        
        let ok = createButtonAction(title: "OK") { [weak alert] _ in
            if let textField = alert?.textFields![0] {
                completion(textField.text!)
            }
        }
                
        let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "SourceSansPro-Bold", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.init(red: 101/255, green: 101/255, blue: 101/255, alpha: 1)]
        let titleString = NSAttributedString(string: "Folder Name", attributes: titleAttributes)
        
        alert.setValue(titleString, forKey: "attributedTitle")
        
        alert.addTextField { (textField) in
            
            textField.superview?.backgroundColor = .white
            textField.useUnderLine()
            textField.borderRect(forBounds: CGRect(x: 0, y: 0, width: 0, height: 0))
            textField.textAlignment = .center
            textField.borderStyle = .none
            textField.autocorrectionType = .no
            textField.keyboardType = .default
            textField.returnKeyType = UIReturnKeyType.done
            textField.clearButtonMode = UITextField.ViewMode.whileEditing
            textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
            textField.backgroundColor = .clear
            
        }
    
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /// Apresenta um alerta de Error.
    private func showAlertErrorFetch(completion: @escaping () -> Void) {
        
        let alert = UIAlertController(title: "Save Post", message: "\n\nYou still don't have any folders.\n\nCreate a new folder to save posts.\n\n", preferredStyle: .alert)
        
        let createFolder = createButtonAction(title: "Create Folder") { _ in
            completion()
        }
        
        let cancel = createCancelButtonAction(title: "Cancel", completion: {_ in
            alert.dismiss(animated: true, completion: nil)
        })
        
        let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "SourceSansPro-Bold", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.init(red: 101/255, green: 101/255, blue: 101/255, alpha: 1)]
        let titleString = NSAttributedString(string: "Save Post", attributes: titleAttributes)
        let messageAttributes = [NSAttributedString.Key.font: UIFont(name: "SourceSansPro-Regular", size: 16)!, NSAttributedString.Key.foregroundColor: UIColor.init(red: 101/255, green: 101/255, blue: 101/255, alpha: 1)]
        
        let messageString = NSAttributedString(string: "\n\nYou still don't have any folders.\n\nCreate a new folder to save posts.\n\n", attributes: messageAttributes)
        alert.setValue(titleString, forKey: "attributedTitle")
        alert.setValue(messageString, forKey: "attributedMessage")
        alert.view.subviews.first?.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.29)
        alert.view.layer.cornerRadius = 5
        alert.view.layer.masksToBounds = true
        
        
        alert.addAction(createFolder)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAlertTableView(completion: @escaping (String?) -> Void) {
        
        let alert = UIAlertController(title: "Save Post", message: nil, preferredStyle: .alert)
        
        let createFolder = createButtonAction(title: "Create Folder") { _ in
            completion(nil)
        }
            
        let cancel = createCancelButtonAction(title: "Cancel", completion: {_ in
            alert.dismiss(animated: true, completion: nil)
        })
        
        let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "SourceSansPro-Bold", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.init(red: 101/255, green: 101/255, blue: 101/255, alpha: 1)]
        let titleString = NSAttributedString(string: "Save Post", attributes: titleAttributes)
        alert.setValue(titleString, forKey: "attributedTitle")
        
        alert.view.layer.cornerRadius = 5
        alert.view.layer.masksToBounds = true
                    
        let customView = UIView()
        alert.view.addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 45).isActive = true
        customView.rightAnchor.constraint(equalTo: alert.view.rightAnchor, constant: -10).isActive = true
        customView.leftAnchor.constraint(equalTo: alert.view.leftAnchor, constant: 10).isActive = true
        customView.heightAnchor.constraint(equalToConstant: 230).isActive = true
        customView.alpha = 0
        customView.superview?.alpha = 0
        customView.superview?.backgroundColor = .clear
        alert.view.translatesAutoresizingMaskIntoConstraints = false
        alert.view.heightAnchor.constraint(equalToConstant: 340).isActive = true
        
        alertTableView = AlertTableView()
        alertTableView?.register(AlertTableViewCell.self, forCellReuseIdentifier: alertTableViewCellID)
        alertTableView?.dataSource = self
        alertTableView?.delegate = self
        alertTableView?.reloadData()
        alertTableView?.separatorStyle = .singleLine
        alertTableView?.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        alertTableView?.separatorColor = UIColor(red: 101/255, green: 101/255, blue: 101/255, alpha: 0.25)
        alertTableView?.superview?.backgroundColor = .clear
        alertTableView?.superview?.alpha = 0
        alertTableView?.backgroundColor = .clear
        
        alertTableView?.myDimiss = { [weak self] in
            completion(self?.folderSelected)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self?.alertTableView?.removeFromSuperview()
                alert.dismiss(animated: true, completion: nil)
                
            }
        }
        alert.view.addSubview(alertTableView!)
        
        alertTableView?.translatesAutoresizingMaskIntoConstraints = false
        alertTableView?.topAnchor.constraint(equalTo: customView.topAnchor).isActive = true
        alertTableView?.rightAnchor.constraint(equalTo: customView.rightAnchor).isActive = true
        alertTableView?.leftAnchor.constraint(equalTo: customView.leftAnchor).isActive = true
        alertTableView?.bottomAnchor.constraint(equalTo: customView.bottomAnchor).isActive = true
        
        alert.addAction(cancel)
        alert.addAction(createFolder)

        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAlerts() {
        
        guard let onwer = self.owner , var post = self.post else {
            print("NAO TINHA OWNERR e POST")
            return
        }
        self.presenter?.getFolders(handler: { [weak self] results in
            
            self?.folders = results.map{ $0.name }
            
            self?.showAlertTableView { [weak self] folder in
                guard let folder = folder else {
                    self?.showAlertFolder { folder in
                        if !folder.isEmpty {
                            self?.saveFoldersAndImages(folderName: folder, post: post, onwer: onwer, complition: { error in
                                guard error != nil else {
                                    self?.popUpView.changerFavoriteButton(to: .favoriteGray)
                                    return
                                }
                                
                            })
                        }
                    }
                    
                    return
                }
                self?.presenter?.favoriteAddImage(post: &post, owner: onwer, folderName: folder, completion: { error in
                    guard error != nil else {
                        self?.popUpView.changerFavoriteButton(to: .favoriteGray)
                        return
                    }
                    
                })
            }
            
        }, completion: { [weak self] (_) in
            self?.showAlertErrorFetch {
                self?.showAlertFolder {  folder in
                    if !folder.isEmpty {
                        self?.saveFoldersAndImages(folderName: folder, post: post, onwer: onwer, complition: { error in
                            guard error != nil else {
                                self?.popUpView.changerFavoriteButton(to: .favoriteGray)
                                return
                            }
                            
                        })
                    }
                }
            }
        })
    }
    
    private func saveFoldersAndImages(folderName: String, post: Post, onwer: String, complition: @escaping ((DataControllerError?) -> Void)) {
        self.presenter?.favoriteFolder(folderName: folderName, completion: nil)
        self.presenter?.favoriteAddImage(post: &self.post, owner: onwer, folderName: folderName, completion: complition)
    }
    
    func presentBing(url: String) {
        let webViewController = WebViewController(url: url)
        webViewController.view.frame = self.view.frame
        super.present(webViewController, animated: true, completion: nil)
    }
    
    
}


extension PopUpViewController: PopUpViewControllerDelegate {
    
    
    func touch(status: TouchStatus) {
        switch status {
        case .instagram:
            if (!Logger.isLogged) {
                self.presentBing(url: post.node.shortcode)
            }else{
                self.presenter?.instagram(owner: owner)
            }
        case .favorite:
            self.showAlerts()
        case .favoriteDelete:
            self.presenter?.deleteImage(post: &post, completion: { [weak self] state, error in
                guard error != nil else {
                    if state {
                        self?.feed?.didRemoveOnlyPost()
                    } else {
                        self?.feed?.didRemoveFolder()
                    }
                    self?.popUpView.changerFavoriteButton(to: .favoriteBlank)
                    return
                }
            })
        }
    }
    
    func checkWasFavorite() -> Bool {
        guard let owner = owner else { return false }
        return (self.presenter?.wasFavorited(post: &post, owner: owner)) ?? false
    }
    
    
    func hashtags() -> [String]? {
        return self.presenter?.hashtags(of: &post)
    }
}

extension PopUpViewController: ViewCoding {
    
    func buildViewHierarchy() {
        self.view.addSubview(popUpView)
    }
    
    func setupConstraints() {
        
    }
    
}



extension PopUpViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = folders?.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: alertTableViewCellID ) as? AlertTableViewCell, let folders = folders else {return UITableViewCell()}
        cell.folderName = folders[indexPath.row]
        cell.backgroundColor = .clear
        
        return cell
    }
    
    
}

extension PopUpViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? AlertTableViewCell, let tableView = tableView as? AlertTableView else { return }
        
        self.folderSelected = cell.folderName
        
        tableView.myDimiss?()
        
        cell.backgroundColor = UIColor(red: 101/255, green: 101/255, blue: 101/255, alpha: 0.2)
    }
    
}

extension UITextField {
    
    func useUnderLine() {
        
        superview?.backgroundColor = .clear
        
        let view = superview?.superview
        view?.subviews.first?.alpha = 0
        view?.backgroundColor = .clear
        
    }
    
}

