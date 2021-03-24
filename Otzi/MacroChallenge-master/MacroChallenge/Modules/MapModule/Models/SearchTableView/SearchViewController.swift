//
//import UIKit
//import MapKit
//
//
//class SearchViewController: UIViewController, UISearchBarDelegate {
//    
//    // MARK: - Properties
//    
//    weak var mapHandlerDelegate: HandleMapSearch?
//    weak var uiDelegate : UpdateUIMap?
//    
//    lazy var tableView : UITableView = {
//        let tv = UITableView(frame: .zero)
//        tv.allowsMultipleSelection = false
//        tv.translatesAutoresizingMaskIntoConstraints = false
//        return tv
//    }()
//    
//    let searchBar : UISearchBar = {
//        
//        let sb = UISearchBar()
//        sb.sizeToFit()
//        sb.placeholder = "   Search for HashTags"
//        sb.setImage(UIImage(named: "MapButton"), for: .search, state: .normal)
//        let textFieldInsideUISearchBar = sb.value(forKey: "searchField") as? UITextField
//        textFieldInsideUISearchBar?.borderStyle = .none
//            textFieldInsideUISearchBar?.backgroundColor = UIColor.white
//        return sb
//        
//    }()
//    
//    
//     var matchingItens: [MKMapItem] = []
//    weak var mapView: MKMapView? = nil
//    
//    
//    // MARK: - Init and others
//    init(map: MKMapView) {
//        super.init(nibName: nil, bundle: nil)
//        self.mapView = map
//    }
//    
//    deinit {
//        print("SAIU")
//    }
//    
//    func setDelegate(reference: HandleMapSearch, referenceUI: UpdateUIMap){
//        self.mapHandlerDelegate = reference
//        self.uiDelegate = referenceUI
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        DispatchQueue.main.async {
//            self.setupView()
//        }
//        
//        self.navigationItem.hidesBackButton = true
//        
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) {
//         self.searchBar.becomeFirstResponder()
//        }
//        
//        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01 ) {
//         self.navigationController?.navigationBar.isHidden = false
//        }
//    }
//    
//    func didPresentSearchController(_ searchController: UISearchController) {
//        self.searchBar.becomeFirstResponder()
//    }
//    
//    
//}
//// MARK: - ViewCoding
//extension SearchViewController : ViewCoding{
//    
//    func buildViewHierarchy() {
//        self.view.addSubview(tableView)
//    }
//    
//    func setupConstraints() {
//        NSLayoutConstraint.activate([
//            
//            tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
//            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
//            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
//            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
//            
//        ])
//    }
//    
//    func setupAdditionalConfiguration() {
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchCell")
//        setupNavBar()
//        
//        searchBar.delegate = self
//        self.view.backgroundColor = .white
//    }
//    
//    
//
//    
//    func setupNavBar(){
//        
//        navigationItem.titleView = searchBar
//        definesPresentationContext = true
//        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(customDismiss))
//        cancelItem.tintColor = .black
//        self.navigationItem.setRightBarButton(cancelItem, animated: false)
//
//        
//        
//        }
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = searchText
//
//        request.pointOfInterestFilter = MKPointOfInterestFilter.init(excluding: [.airport, .amusementPark, .aquarium, .atm, .bakery, .bank, .beach, .brewery, .cafe, .campground, .carRental, .evCharger, .fireStation, .fitnessCenter, .foodMarket, .gasStation, .hospital, .hotel, .laundry, .library, .marina, .movieTheater, .museum, .nationalPark, .nightlife, .park, .parking, .pharmacy, .police, .postOffice, .publicTransport, .restaurant, .restroom, .school, .store, .theater, .university, .winery, .zoo])
//
//        let search = MKLocalSearch(request: request)
//
//
//        search.start { [weak self] (response, error) in
//
//            guard let response = response else {return}
//
//            self?.matchingItens = response.mapItems
//            self?.tableView.reloadData()
//            self?.uiDelegate?.updateUI()
//
//        }
//        
//        
//        
//    }
//    
//    @objc func customDismiss(){
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    
//}
//
//
//// MARK: - TableView Setup
//extension SearchViewController : UITableViewDelegate, UITableViewDataSource{
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return matchingItens.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell")
//        let name = matchingItens[indexPath.row].placemark
//        cell?.textLabel?.text = name.name
//        return cell!
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedItem = matchingItens[indexPath.row].placemark
//        mapHandlerDelegate?.dropPin(placemark: selectedItem)
//        uiDelegate?.updateUI()
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    
//}
//
//
