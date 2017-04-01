//
//  SearchRestaurants.swift
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

class SearchRestaurants: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var geoFire: GeoFire!
    var geoFireRef: FIRDatabaseReference!
    
    let locationManager = CLLocationManager()
    
    var userPin = CLLocation(latitude: 37.3580262, longitude: -122.0266397)
    
 //   var contactPin = CLLocation(latitude: 37.3253554, longitude: -122.0141182)
    
    var midpointRegion = MKCoordinateRegion()
        
    var places = [MKMapItem]()
    
    
    let mapView: MKMapView = {
        let mp = MKMapView()
        mp.backgroundColor = UIColor.brown
        mp.translatesAutoresizingMaskIntoConstraints = false
        return mp
    }()
    let RestaurantListBtn: UIButton = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Clever Dinner"
        
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.follow
        
        geoFireRef = FIRDatabase.database().reference()
        geoFire = GeoFire(firebaseRef: geoFireRef)
        
        FIRMessaging.messaging().subscribe(toTopic: "/topics/news")
        
        setupMapViews()
        
        print("Adding User to Map")

        view.backgroundColor = .white
        
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
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let loc = userLocation.location {
            centerMapOnLocation(location: loc)
            userPin = loc
            performSearch()
        }
    }
    
    func createSighting(forLocation location: CLLocation, withRestaurant restaurantId: Int) {
        geoFire.setLocation(location, forKey: "\(restaurantId)")
    }
    
    func performSearch() {
        // use MKLocalSearch API to find coffee places
        
        print("Performing Search")
        
        let midpointCoord = CLLocationCoordinate2D(latitude: userPin.coordinate.latitude, longitude: userPin.coordinate.longitude)
        
        // set search region to be a square with an area of half the distance between the 2 users
        let midpointRegionSpan = MKCoordinateSpanMake(1000, 800)
        let midpointRegion = MKCoordinateRegionMakeWithDistance(midpointCoord, midpointRegionSpan.latitudeDelta, midpointRegionSpan.longitudeDelta)
        
        // use MKLocalSearch API to find coffee places
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "restaurant"
        request.region = midpointRegion
        let search = MKLocalSearch(request: request)
        
        search.start { (response, error) in
            guard let response = response else {
                print("Search error: \(String(describing: error))")
                return
            }
            
            // add coffee shops to map
            for place in response.mapItems {
                
                self.places.append(place)
                
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
    func setupMapViews() {
        
        view.addSubview(mapView)
        view.addSubview(RestaurantListBtn)
        
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        
        RestaurantListBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        RestaurantListBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        RestaurantListBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        RestaurantListBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
