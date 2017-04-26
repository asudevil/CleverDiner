//
//  BizTab.swift
//  CleverDiner
//
//  Created by admin on 4/21/17.
//  Copyright © 2017 CodeWithFelix. All rights reserved.
//

import UIKit

class BizTab: UIViewController {
    
    let signupLabel: UILabel = {
        let label = UILabel()
        label.text = "Signin or signup to enter business portal!"
        label.font = UIFont(name: "Verdana", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("Business Portal", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(r: 230, g: 80, b: 0, a: 1)
        button.addTarget(self, action: #selector(signIntoBusinessPortal), for: .touchUpInside)
        
        return button
    }()
    
    let businessImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "RestaurantBusiness")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(businessImage)
        view.addSubview(signupLabel)
        view.addSubview(signupButton)
        
        businessImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        businessImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        businessImage.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        businessImage.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        signupLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupLabel.topAnchor.constraint(equalTo: businessImage.bottomAnchor, constant: 5).isActive = true
        signupLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupButton.topAnchor.constraint(equalTo: signupLabel.bottomAnchor, constant: 10).isActive = true
        signupButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        signupButton.widthAnchor.constraint(equalToConstant: 200).isActive = true

    }
    
    func signIntoBusinessPortal(){
        
        print("Enter Business Portal")
        let layout = UICollectionViewFlowLayout()
        let businessPortal = BizPortal(collectionViewLayout: layout)
        navigationController?.pushViewController(businessPortal, animated: true)
    }
    
}
