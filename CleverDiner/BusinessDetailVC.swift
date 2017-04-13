//
//  BusinessDetailVC.swift
//  CleverDiner
//
//  Created by admin on 4/11/17.
//  Copyright © 2017 CodeWithFelix. All rights reserved.
//

import UIKit

private let cellId = "Cell"
private let headerId = "HeaderId"

class BusinessDetailVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var titleLabelMessage: String?
    var titleTextMessage: String?
    var headerText: String?


    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = UIColor.white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        self.collectionView!.register(BusinessProfileCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView?.register(BusinessHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BusinessProfileCell
        
        cell.titleLabel.text = titleLabelMessage
        cell.title.text = titleTextMessage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 30)
    }
    
    //Header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! BusinessHeaderCell
        
 //       let userPicUrl = contactInfoArray[0]
 //       header.profileImageView.loadImageUsingCacheWithUrlString(urlString: userPicUrl)
        header.name.text = headerText
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 210)
    }

}
