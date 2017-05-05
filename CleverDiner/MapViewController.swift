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

class MapViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var searchKeyword = "restaurant"
    var searchAddressInput = String()
    
    let locationManager = CLLocationManager()
    
    var places = [MKMapItem]()
    
    var selectedRestaurant: MKAnnotation!
    
    let titleViewImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "the_clever_diner")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.frame = CGRect(x: 70, y: 0, width: 200, height: 44)
        return imageView
    }()
    
    var mapView: MKMapView = {
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
    //    tf.backgroundColor = UIColor(r: 224, g: 224, b: 224, a: 0.7)
        tf.backgroundColor = UIColor.white
        tf.addTarget(self, action: #selector(handleSearchMap), for: .touchUpInside)
        return tf
    }()
    let searchBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Search", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
   //     btn.backgroundColor = UIColor(r: 224, g: 224, b: 224, a: 0.7)
        btn.backgroundColor = UIColor.white

        btn.addTarget(self, action: #selector(handleSearchMap), for: .touchUpInside)
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
        
        navigationItem.titleView = titleViewImage
        
        searchTextField.delegate = self
        
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.follow
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(showUserView))
        
        setupMapViews()
        
        view.backgroundColor = UIColor.white

        
    }
    override func viewDidAppear(_ animated: Bool) {
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
        
        if searchAddressInput.characters.count > 1 {
            
            getGeoCodeAddress(searchLoc: searchAddressInput)
        } else {
            
            if let loc = userLocation.location {
                
                Services.sharedInstance.performSearchWithMap(searchLocation: loc, searchString: searchKeyword, mapView: self.mapView, completion: { (mapViewCompletion, placesCompletion) in
                    self.mapView = mapViewCompletion
                    self.places = placesCompletion
                })
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        selectedRestaurant = view.annotation
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annoIdentifier = "Profile"
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annoIdentifier)
        
        annotationView.canShowCallout = true
        
        let mapBtn = UIButton()
        mapBtn.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        mapBtn.setImage(UIImage(named: "map"), for: .normal)
        annotationView.rightCalloutAccessoryView = mapBtn
        
        let infoBtn = UIButton()
        infoBtn.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        infoBtn.setImage(UIImage(named: "info"), for: .normal)
        infoBtn.addTarget(self, action: #selector(businessDetailsTap), for: .touchUpInside)
        
        let discountBtn = UIButton()
        discountBtn.frame = CGRect(x: 30, y: 0, width: 40, height: 40)
        discountBtn.setImage(UIImage(named: "MapDiscount"), for: .normal)
        discountBtn.addTarget(self, action: #selector(showDiscountDetails), for: .touchUpInside)
        
        annoContainer.frame = CGRect(x: 0, y: 0, width: 70, height: 40)
        annoContainer.addSubview(discountBtn)
        annoContainer.addSubview(infoBtn)
        annotationView.leftCalloutAccessoryView = annoContainer
        
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
    
    func showUserView() {
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    func showMeetingLocationTable() {
        let resultList = ResultsListVC()
        resultList.restaurants = places
        navigationController?.pushViewController(resultList, animated: true)
    }
    
    func handleLogout() {
        
        do { try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginVC = LoginController()
        
        if UserDefaults.standard.isReturningUser() {
            
            loginVC.skip()
            loginVC.nextPage()
            print("Returning User.  Page number: ", loginVC.pageControl.currentPage)
        }
        
        present(loginVC, animated: true, completion: nil)
    }
    
    func handleSearchMap() {
        
        guard let searchText =  searchTextField.text else {
            print("City or zip entered is invalid")
            return
        }
        getGeoCodeAddress(searchLoc: searchText)
        
    }
    func getGeoCodeAddress(searchLoc: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(searchLoc, completionHandler: { (placemarks, error) -> Void in
            if error == nil {
                
                if placemarks!.count != 0 {
                    guard let firstAddressResult = placemarks?.first?.location else {
                        return
                    }
                    Services.sharedInstance.performSearchWithMap(searchLocation: firstAddressResult, searchString: self.searchKeyword, mapView: self.mapView, completion: { (mapViewCompletion, placesCompletion) in
                        self.mapView = mapViewCompletion
                        self.places = placesCompletion
                    })
                    self.centerMapOnLocation(location: firstAddressResult)
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
    
    func businessDetailsTap() {
        
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
