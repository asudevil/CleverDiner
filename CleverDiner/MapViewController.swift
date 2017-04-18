//
//  MapViewController.swift
//  CleverDiner
//
//  Created by admin on 3/28/17.
//  Copyright © 2017 CodeWithFelix. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

class MapViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    private var searchKeyword = "restaurant"
    
    var geoFire: GeoFire!
    var geoFireRef: FIRDatabaseReference!
    
    let locationManager = CLLocationManager()
        
    var midpointRegion = MKCoordinateRegion()
        
    var places = [MKMapItem]()
    
    var selectedRestaurant: MKAnnotation!
    
    
    let mapView: MKMapView = {
        let mp = MKMapView()
        mp.backgroundColor = UIColor.brown
        mp.translatesAutoresizingMaskIntoConstraints = false
        return mp
    }()
    let restaurantListBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.text = "Show Restaurants"
        btn.setTitleColor(.white, for: .normal)
        btn.setImage(UIImage(named: "list-icon"), for: .normal)
        btn.layer.masksToBounds = true
        btn.contentMode = .scaleAspectFill
        btn.addTarget(self, action: #selector(showMeetingLocationTable), for: .touchUpInside)
        return btn
    }()
    
    let searchTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Location City or Zip Code"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.masksToBounds = true
        tf.addTarget(self, action: #selector(handleSearchText), for: .touchUpInside)
        return tf
    }()
    let searchBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Search", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.addTarget(self, action: #selector(handleSearchText), for: .touchUpInside)
        return btn
    }()
    
    let annoContainer: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.white
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.masksToBounds = true
        return container
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Clever Dinner"
        
        searchTextField.delegate = self
        
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.follow
        
        geoFireRef = FIRDatabase.database().reference()
        geoFire = GeoFire(firebaseRef: geoFireRef)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        FIRMessaging.messaging().subscribe(toTopic: "/topics/news")
        
        setupMapViews()
        
        view.backgroundColor = .white
        
    }
    override func viewDidAppear(_ animated: Bool) {
        checkIfUserIsLoggedIn()
        locationAuthStatus()
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 4000, 4000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let loc = userLocation.location {
            centerMapOnLocation(location: loc)
            performSearch(searchLocation: loc)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        selectedRestaurant = view.annotation
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annoIdentifier = "Profile"
        var annotationView: MKAnnotationView?
        
        if annotation.isKind(of: MKUserLocation.self) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
        } else if let deqAnno = mapView.dequeueReusableAnnotationView(withIdentifier: annoIdentifier) {
            annotationView = deqAnno
            annotationView?.annotation = annotation
        } else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annoIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = av
        }
        
        if let annotationView = annotationView /*, let anno = annotation as? UserAnnotation */ {
            annotationView.canShowCallout = true
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.cornerRadius = 10
            imageView.layer.masksToBounds = true
            imageView.contentMode = .scaleAspectFill
            
            imageView.image = UIImage(named: "Clever_Diner_Large")

            UIGraphicsBeginImageContext(imageView.bounds.size)
            imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            annotationView.image = resizedImage
            
            let mapBtn = UIButton()
            mapBtn.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            mapBtn.setImage(UIImage(named: "map"), for: .normal)
            annotationView.rightCalloutAccessoryView = mapBtn
            
            let infoBtn = UIButton()
            infoBtn.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            infoBtn.setImage(UIImage(named: "info"), for: .normal)
            infoBtn.addTarget(self, action: #selector(profileDetailsTap), for: .touchUpInside)
            
            let discountBtn = UIButton()
            discountBtn.frame = CGRect(x: 30, y: 0, width: 40, height: 40)
            discountBtn.setImage(UIImage(named: "25_percent_discount"), for: .normal)
            discountBtn.addTarget(self, action: #selector(showDiscountDetails), for: .touchUpInside)
            
            annoContainer.frame = CGRect(x: 0, y: 0, width: 70, height: 40)
            annoContainer.addSubview(discountBtn)
            annoContainer.addSubview(infoBtn)
            annotationView.leftCalloutAccessoryView = annoContainer
        
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let selectedBusiness = view.annotation {
            
            let place = MKPlacemark(coordinate: selectedBusiness.coordinate)
            let destination = MKMapItem(placemark: place)
            destination.name = "User sighting"
            let regionDistance: CLLocationDistance = 1000
            let regionSpan = MKCoordinateRegionMakeWithDistance(selectedBusiness.coordinate, regionDistance, regionDistance)
            let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving] as [String : Any]
            MKMapItem.openMaps(with: [destination], launchOptions: options)
        }
    }
    
    func performSearch(searchLocation: CLLocation) {
        
        places.removeAll()
        
        let midpointCoord = CLLocationCoordinate2D(latitude: searchLocation.coordinate.latitude, longitude: searchLocation.coordinate.longitude)
        
        // set search region to be a square with an area of half the distance between the 2 users
        let midpointRegionSpan = MKCoordinateSpanMake(2000, 2000)
        let midpointRegion = MKCoordinateRegionMakeWithDistance(midpointCoord, midpointRegionSpan.latitudeDelta, midpointRegionSpan.longitudeDelta)
        
        // use MKLocalSearch API to find places
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchKeyword
        request.region = midpointRegion
        let search = MKLocalSearch(request: request)
        
        search.start { (response, error) in
            guard let response = response else {
                print("Search error: \(String(describing: error))")
                return
            }
            
            // add place to map and list
            for place in response.mapItems {
                
                self.places.append(place)
                
                print("SEARCH OUTPUT: ", place)
                
                let placeAnno = MKPointAnnotation()
                placeAnno.coordinate = place.placemark.coordinate
                placeAnno.title = place.name
                self.mapView.addAnnotation(placeAnno)
            }
        }
    } 
    
    func showMeetingLocationTable() {
        //restaurantSelector.showLocations()
        let layout = UICollectionViewFlowLayout()
        let resultsList = ResultsList(collectionViewLayout: layout)
        resultsList.restaurants = places
        navigationController?.pushViewController(resultsList, animated: true)
    }
    
    func checkIfUserIsLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            print("User is logged In")
        }
    }
    
    func handleLogout() {
        
        do { try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
//        let loginController = LoginController()
//        loginController.mainVC = self
//        present(loginController, animated: true, completion: nil)
        
        let introVC = IntroViewController()
  //      introVC.mainVC = self
        
        present(introVC, animated: true, completion: nil)
    }
    
    func handleSearchText() {
        
        guard let searchLoc =  searchTextField.text else {
            print("City or zip entered is invalid")
            return
        }
        
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(searchLoc, completionHandler: { (placemarks, error) -> Void in
            if error == nil {

                if placemarks!.count != 0 {
                    guard let firstResult = placemarks?.first?.location else {
                        return
                    }
                    self.performSearch(searchLocation: firstResult)
                    self.centerMapOnLocation(location: firstResult)
                }
            } else {
                print("Search value invalid!!!!!")
            }
        })
        
    }
    
    func showDiscountDetails() {
        print("Show discount details Button clicked")
        
    // This is temporary.  Need to create a seperate class for discount details VC
        let layout = UICollectionViewFlowLayout()
        let profileDetailsController = BusinessDetailVC(collectionViewLayout: layout)
        profileDetailsController.titleLabelMessage = "Discount:"
        profileDetailsController.titleTextMessage = "Discount Details Goes Here"
        profileDetailsController.headerText = "Discount for ...Name"
        
        navigationController?.pushViewController(profileDetailsController, animated: true)
        
    }
    
    func profileDetailsTap() {
        
        print("Show Profile Details Tapped")
        let layout = UICollectionViewFlowLayout()

        let profileDetailsController = BusinessDetailVC(collectionViewLayout: layout)
        
        profileDetailsController.titleLabelMessage = "Business Name:"
        profileDetailsController.titleTextMessage = "Business Name Goes Here"
        profileDetailsController.headerText = "Restaurant Name"
        
        navigationController?.pushViewController(profileDetailsController, animated: true)
    
    }
    
    func setupMapViews() {
        
        view.addSubview(mapView)
        view.addSubview(restaurantListBtn)
        view.addSubview(searchTextField)
        view.addSubview(searchBtn)
        
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 110).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        
        restaurantListBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        restaurantListBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        restaurantListBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        restaurantListBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        searchTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 60).isActive = true
        searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -100).isActive = true
        
        searchBtn.leftAnchor.constraint(equalTo: searchTextField.rightAnchor, constant: 5).isActive = true
        searchBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        searchBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchTextField.resignFirstResponder()
    }
}
