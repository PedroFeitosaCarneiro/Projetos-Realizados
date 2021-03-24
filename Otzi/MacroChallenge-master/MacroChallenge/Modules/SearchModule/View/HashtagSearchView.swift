//
//  NewHashtagSearchView.swift
//  MacroChallenge
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 29/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//


import Foundation
import UIKit

class HashtagSearchView: UIViewController, SearchViewToPresenter, UISearchBarDelegate{
    
    var presenter: SearchPresenterToView?
    
    var fileParser : FileReader?
    
    var flag = true
    var recentSearch: [String] = []
    
    var hashtagsParsed : [String] = []
    var hashtagsFiltered : [String] = []
    
    lazy var tableView : UITableView = {
        let tv = UITableView(frame: .zero)
        tv.allowsMultipleSelection = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    let searchBar : UISearchBar = {
        let sb = UISearchBar()
        sb.sizeToFit()
        sb.placeholder = ""
        sb.clipsToBounds = true
        sb.layer.cornerRadius = 2
        sb.tintColor = .black
        
        sb.setImage(UIImage(named: "lupa"), for: .search, state: .normal)
        let textFieldInsideUISearchBar = sb.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.borderStyle = .none
            textFieldInsideUISearchBar?.backgroundColor = UIColor.white
        
        return sb
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        
        presenter?.getRecentTags(completion: { (result) in
            
            if result.count != 0 {
                self.recentSearch = result.reversed()
                
                for i in 0...result.count-1 {
                    
                    
                    if i > 9 {
                        self.recentSearch.remove(at: i)
                    }
                    
                }
                
                self.flag = false
                self.tableView.reloadData()
            }
            
            
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.flag = true
        self.hashtagsFiltered.removeAll()
        searchBar.searchTextField.text = ""
        
    }
    
    override func viewDidLoad() {
        setupView()
        print("COFOI")
    }
    
    init(fileParser: FileReader) {
        self.fileParser = fileParser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) {
         self.searchBar.becomeFirstResponder()
        }
    }
    
}

//MARK:- ViewCoding
extension HashtagSearchView: ViewCoding{
    
    func buildViewHierarchy() {
        self.view.addSubview(tableView)
    }
    
    func setupConstraints() {
                NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
            
        ])
    }
    
    func setupAdditionalConfiguration() {
        
        setupNavBar()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HashtagSearchTableViewCell.self, forCellReuseIdentifier: "HashTagCellSearch")
        tableView.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        self.navigationItem.hidesBackButton = true
        do {
            try hashtagsParsed = fileParser!.loadFileFromBundle(name: "hashtags", fileExtension: "txt")
        } catch let FileReaderError {
            print(FileReaderError)
        }
        

        
    }
    
}

//MARK:- TableView
extension HashtagSearchView: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if flag == false {
            return recentSearch.count
        }
        
        return hashtagsFiltered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HashTagCellSearch", for: indexPath)

        if flag == false{
            if indexPath.row < 10{
                cell.textLabel?.text = recentSearch[indexPath.row]
            }
            cell.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
            
        } else {
            
            if hashtagsFiltered.count >= indexPath.row{
                cell.textLabel?.text = hashtagsFiltered[indexPath.row]
            }
            cell.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        presenter?.saveHashtagIntoDataBase(with: cell!.textLabel!.text!)
        presenter?.dataSentToPresenter(value: cell!.textLabel!.text!, from: self)
        cell!.isSelected = false
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            presenter?.deleteHashtagFromDataBase(with: recentSearch[indexPath.row])
            recentSearch.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func setupNavBar(){
        
         searchBar.delegate = self
         navigationItem.titleView = searchBar
         definesPresentationContext = true
        
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(customDismiss))
        cancelItem.tintColor = .black
        self.navigationItem.setRightBarButton(cancelItem, animated: false)
        
        }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        SearchService.doSearchOn(hashtagsParsed, text: searchText) { [self] (result, error) in
            self.hashtagsFiltered = result
            self.tableView.reloadData()
            flag = true
            
            if searchText == ""{
                flag = false
            }
            
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.text else {return}
        presenter?.saveHashtagIntoDataBase(with: text)
        presenter?.dataSentToPresenter(value: text, from: self)
    }
    
    @objc func customDismiss(){
        self.navigationController?.popViewController(animated: true)
    }
    
}

