//
//  UserInfoCollectionVC.swift
//  CleverDiner
//
//  Created by admin on 5/3/17.
//  Copyright © 2017 CodeWithFelix. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class UserInfoCollectionVC: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }



    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        
    
        return cell
    }

   
}
