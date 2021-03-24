//import UIKit
//import MapKit
//import CoreLocation
//
//class MapView: UIViewController, MapViewToPresenter, UISearchBarDelegate{
//    // MARK: - Properties
//    var presenter: MapPresenterToView?
//    
//    var mapController : MapController
//    
//    var currentLocation : CLLocation? = nil
//    
//    let mapView : MKMapView = {
//        var mapv = MKMapView(frame: .zero)
//        mapv.translatesAutoresizingMaskIntoConstraints = false
//        mapv.layer.zPosition = 10
//        return mapv
//    }()
//    
//    let mapPin : MKPointAnnotation = {
//        let annotation = MKPointAnnotation()
//        return annotation
//    }()
//    
//    var sendButton : UIButton? = {
//        let button = UIButton(frame: .zero)
//        button.titleLabel?.text = "SEARCH"
//        button.setImage(UIImage(named: "enterIcon"), for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(sendToPresenter), for: .touchDown)
//        button.isHidden = true
//        button.isUserInteractionEnabled = false
//        return button
//    }()
//    
//    
//    let searchBar : UISearchBar = {
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
//    let searchTouch = UIView(frame: .zero)
//    
//    
//
//    let locationManager = CLLocationManager()
//    
//    
//    
//    
//    var array : [String] = []
//    
//    
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.isHidden = false
//        self.navigationItem.hidesBackButton = true
//
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupLocationManager()
//        DispatchQueue.main.async { [self] in
//            self.setupView()
//        }
//        
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.navigationBar.isHidden = true
//    }
//    
//    
//    
//    // MARK: - Init
//    init() {
//        mapController = MapController(mapReference: mapView, pin: mapPin)
//        super.init(nibName: nil, bundle: nil)
//        mapController.setDelegate(delegate: self)
//        
//    }
//        
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    @objc func sendToPresenter() {
//        hideUI()
//        let place = MKPlacemark(coordinate: mapPin.coordinate)
//        presenter?.informPlaceToInteractor(place, from: self)
//    }
//    
//}
//
//
//
//// MARK: - VIEW CODE SETUP
//extension MapView: ViewCoding{
//    func setupAdditionalConfiguration() {
//        setupNavBar()
//        
//        
//        
//        searchBar.delegate = self
//        navigationItem.titleView = searchBar
//        definesPresentationContext = true
//        
//        navigationController?.navigationBar.barTintColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
//        
//    }
//    
//    func buildViewHierarchy() {
//        self.view.addSubview(mapView)
//        self.mapView.addAnnotation(mapPin)
//        self.mapView.addSubview(sendButton!)
//        
//           searchBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(searchButtonTapped)))
//        searchTouch.frame = searchBar.frame
//         searchBar.addSubview(searchTouch)
//    }
//    
//    func setupConstraints() {
//        NSLayoutConstraint.activate([
//            
//            mapView.topAnchor.constraint(equalTo:  self.view.topAnchor, constant: 0),
//            mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
//            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
//            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
//            
//            
//            sendButton!.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 706),
//            sendButton!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40),
//            sendButton!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 160),
//            sendButton!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -155)
//        ])
//        
//    }
//    
//    func setupNavBar(){
//        
//        
//        navigationItem.titleView = searchBar
//
//        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
//        cancelItem.tintColor = .black
//        self.navigationItem.setRightBarButton(cancelItem, animated: false)
//        
//        
//    }
//    @objc func cancelButtonTapped(){
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    
//    @objc func searchButtonTapped(){
//        let searchView = SearchViewController(map: self.mapView)
//        searchView.setDelegate(reference: self.mapController, referenceUI: self)
//        
//        
//        presenter?.callRouterToShowSearch(from: self, to: searchView)
//    }
//    
//    
//}
//
//extension MapView: UpdateUIMap {
//    func hideUI() {
//        self.sendButton!.isHidden = true
//        self.sendButton!.isUserInteractionEnabled = false
//    }
//    
//    func updateUI() {
//        self.sendButton!.isHidden = false
//        self.sendButton!.isUserInteractionEnabled = true
//    }
//    
//    
//}
//
//
////MARK: - CORE LOCATION
//
//extension MapView: CLLocationManagerDelegate{
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        
//        if let location = locations.first{
//            manager.stopUpdatingLocation()
//            
//            currentLocation = location
//            render()
//            
//        }
//        
//        
//    }
//    
//    
//    func render(){
//        
//        
//        if CLLocationManager.locationServicesEnabled(){
//            let coordinate = CLLocationCoordinate2D(latitude: currentLocation!.coordinate.latitude, longitude: currentLocation!.coordinate.longitude)
//            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//            let region = MKCoordinateRegion(center: coordinate, span: span)
//            
//            mapView.setRegion(region, animated: true)
//            mapController.dropPin(placemark: MKPlacemark(coordinate: coordinate))
//            sendButton!.isHidden = false
//            sendButton!.isUserInteractionEnabled = true
//        }
//        
//    }
//    
//    
//    func setupLocationManager(){
//        self.locationManager.requestWhenInUseAuthorization()
//        if CLLocationManager.locationServicesEnabled(){
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
//            mapView.showsUserLocation = true
//        }
//        
//    }
//    
//    
//}
