//
//  ResultsListVC.swift
//  CleverDiner
//
//  Created by admin on 5/2/17.
//  Copyright © 2017 CodeWithFelix. All rights reserved.
//

import UIKit
import Firebase

class ResultsListVC: UIViewController, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var locationManager = CLLocationManager()
    var searchAddressInput = String()
    var searchKeyword = "restaurant"
    var restaurants: [MKMapItem]?
    
    let searchTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Location City or Zip Code"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.masksToBounds = true
        tf.layer.cornerRadius = 5
        tf.backgroundColor = .white
        return tf
    }()
    lazy var mapSearchBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "map"), for: .normal)
        btn.layer.masksToBounds = true
        btn.contentMode = .scaleAspectFill
        btn.addTarget(self, action: #selector(mapSearchLocation), for: .touchUpInside)
        return btn
    }()
    
    lazy var searchListBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "search_small"), for: .normal)
        btn.layer.masksToBounds = true
        btn.contentMode = .scaleAspectFit
        btn.addTarget(self, action: #selector(listSearchLocation), for: .touchUpInside)
        return btn
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 30, left: 0, bottom: 10, right: 0)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationAuthStatus()
        
        collectionView.register(ResultsCell.self, forCellWithReuseIdentifier: cellId)

        //Firebase notifications
        FIRMessaging.messaging().subscribe(toTopic: "/topics/news")
        
        setupViews()
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func getGeoCodeAddress(searchLoc: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(searchLoc, completionHandler: { (placemarks, error) -> Void in
            if error == nil {
                
                if placemarks!.count != 0 {
                    guard let firstAddressResult = placemarks?.first?.location else {
                        return
                    }
                    Services.sharedInstance.performSearch(searchLocation: firstAddressResult, searchString: self.searchKeyword, completion: { (placesCompletion) in
                        self.restaurants = placesCompletion
                        self.collectionView.reloadData()
                    })
                }
            } else {
                print("Search value invalid!!!!!")
            }
        })
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {

        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let number = restaurants?.count else {
            return 1
        }
        
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ResultsCell
        
        cell.nameLabel.text = restaurants?[indexPath.item].name
        cell.phoneLabel.text = restaurants?[indexPath.item].phoneNumber
        
        let address = restaurants?[indexPath.item].placemark.addressDictionary?["FormattedAddressLines"] as? [String]
        
        let fullAddress = address?.joined(separator: " ")
        
        cell.addressLabel.text = fullAddress
        
        cell.meetingLocImage = "CleverDiner_App_Icon"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Selected Cell: ", indexPath.row)
        
        
    }
    
    func mapSearchLocation() {
        guard let searchLoc =  searchTextField.text else {
            print("City or zip entered is invalid")
            return
        }
        let mapVCsearch = MapViewController()
        mapVCsearch.searchAddressInput = searchLoc
        navigationController?.pushViewController(mapVCsearch, animated: true)
    }
    func listSearchLocation() {
        
        guard let searchLoc =  searchTextField.text else {
            print("City or zip entered is invalid")
            return
        }
        getGeoCodeAddress(searchLoc: searchLoc)
        
        
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
        }
        self.present(loginVC, animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchTextField.resignFirstResponder()
    }
    
    func setupViews() {
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(searchTextField)
        view.addSubview(mapSearchBtn)
        view.addSubview(collectionView)
        view.addSubview(searchListBtn)
        
        //Set anchor using the anchor extention
        
        searchTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 80).isActive = true
        searchTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -80).isActive = true
        searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        mapSearchBtn.topAnchor.constraint(equalTo: searchTextField.topAnchor, constant: 5).isActive = true
        mapSearchBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mapSearchBtn.rightAnchor.constraint(equalTo: searchTextField.leftAnchor, constant: -10).isActive = true
        mapSearchBtn.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        searchListBtn.topAnchor.constraint(equalTo: searchTextField.topAnchor).isActive = true
        searchListBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchListBtn.leftAnchor.constraint(equalTo: searchTextField.rightAnchor, constant: 5).isActive = true
        searchListBtn.widthAnchor.constraint(equalToConstant: 100)
        
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
    }
}
