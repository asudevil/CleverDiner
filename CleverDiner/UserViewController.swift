//
//  UserViewController.swift
//  CleverDiner
//
//  Created by admin on 4/19/17.
//  Copyright © 2017 CodeWithFelix. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    
    let topBackgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dessert_background")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        cv.translatesAutoresizingMaskIntoConstraints = false

        return cv
    }()
    
    let menus: [Menu] = {
        let item1 = Menu(title: "Breakfast", imageName: "breakfast")
        let item2 = Menu(title: "Lunch", imageName: "lunch")
        let item3 = Menu(title: "Dinner", imageName: "dinner")
        let item4 = Menu(title: "Coffee & Tea", imageName: "coffee")
        let item5 = Menu(title: "Dessert", imageName: "dessert")
        let item6 = Menu(title: "Happy Hour", imageName: "happyhour")

        
        return [item1,item2,item3,item4,item5,item6]
        
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: cellId)
        
        view.backgroundColor = .white
        
        view.addSubview(topBackgroundImage)
        view.addSubview(collectionView)
        
        _ = topBackgroundImage.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 400)
        
  //      
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topBackgroundImage.bottomAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCell
        
        cell.menu = menus[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/3, height: 100)
    }
}
