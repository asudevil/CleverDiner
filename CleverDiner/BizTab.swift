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
        label.text = "Signup or edit your business Info!!"
        label.font = UIFont(name: "Verdana", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("Business Info", for: .normal)        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.layer.cornerRadius = 5
        
        button.backgroundColor = UIColor(r: 230, g: 80, b: 0, a: 1)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(signupLabel)
        view.addSubview(signupButton)
        
        signupLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        signupLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50).isActive = true
        signupButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        signupButton.widthAnchor.constraint(equalToConstant: 200).isActive = true

    }
    
    
    
}
