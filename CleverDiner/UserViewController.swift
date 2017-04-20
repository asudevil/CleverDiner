//
//  UserViewController.swift
//  CleverDiner
//
//  Created by admin on 4/19/17.
//  Copyright © 2017 CodeWithFelix. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    private let cellId = "cellId"
    
    let topBackgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dessert_background")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let searchTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Location City or Zip Code"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.masksToBounds = true
        tf.backgroundColor = .white
        return tf
    }()
    lazy var searchBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "search_small"), for: .normal)
        btn.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        return btn
    }()
    
    let searchBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1.0, alpha: 0.9)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
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
    
    let mealTypes: [MealType] = {
        let item1 = MealType(title: "Breakfast", imageName: "breakfast")
        let item5 = MealType(title: "Dessert", imageName: "dessert")
        let item2 = MealType(title: "Lunch", imageName: "lunch")
        let item4 = MealType(title: "Coffee & Tea", imageName: "coffee")
        let item3 = MealType(title: "Dinner", imageName: "dinner")
        let item6 = MealType(title: "Happy Hour", imageName: "happyhour")

        
        return [item1,item2,item3,item4,item5,item6]
        
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(MealTypeCell.self, forCellWithReuseIdentifier: cellId)
        
        searchTextField.delegate = self
        
        view.backgroundColor = .white
        
        view.addSubview(topBackgroundImage)
        view.addSubview(collectionView)
        view.addSubview(searchBackgroundView)
        view.addSubview(searchTextField)
        view.addSubview(searchBtn)
        
        
        //Set anchor using the anchor extention
        _ = topBackgroundImage.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 360)
        
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 260).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        searchTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 80).isActive = true
        searchTextField.bottomAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        
        searchBtn.topAnchor.constraint(equalTo: searchTextField.topAnchor).isActive = true
        searchBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchBtn.rightAnchor.constraint(equalTo: searchTextField.leftAnchor, constant: -10).isActive = true
        searchBtn.widthAnchor.constraint(equalToConstant: 100)
        
        searchBackgroundView.bottomAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true
        searchBackgroundView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        searchBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true


    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return mealTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MealTypeCell
        
        cell.mealType = mealTypes[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/3.1, height: 100)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchTextField.resignFirstResponder()
    }
    
    func handleSearch() {
        
        guard let searchLoc =  searchTextField.text else {
            print("City or zip entered is invalid")
            return
        }
        var mapVCsearch = MapViewController()
        
        navigationController?.pushViewController(mapVCsearch, animated: true)

        
        
    }
}
