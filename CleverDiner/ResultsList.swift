//
//  ResultsList.swift
//  CleverDiner
//
//  Created by admin on 3/29/17.
//  Copyright © 2017 CodeWithFelix. All rights reserved.
//

import UIKit
import MapKit
import AddressBookUI
import ContactsUI

class ResultsList: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var restaurantName = [String]()
    var restaurantImages = ["logo"]
    let cellId = "cellId"
    let cellHeight: CGFloat = 120
    
    var selectedProduct: String!
    var restaurants: [MKMapItem]?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(ResultsCell.self, forCellWithReuseIdentifier: cellId)
        
        view.backgroundColor = UIColor.white
        self.collectionView?.backgroundColor = .lightGray
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let number = restaurants?.count else {
            return 1
        }
        
        return number
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ResultsCell
        
        cell.nameLabel.text = restaurants?[indexPath.item].name
        cell.phoneLabel.text = restaurants?[indexPath.item].phoneNumber
        

        let address = restaurants?[indexPath.item].placemark.addressDictionary?["FormattedAddressLines"] as? [String]
        
        let fullAddress = address?.joined(separator: " ")
        
        cell.addressLabel.text = fullAddress
        
        cell.meetingLocImage = "CleverDiner_App_Icon"
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Restaurant selected is \(restaurants?[indexPath.item].name)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }


}
