//
//  BusinessHeaderCell.swift
//  CleverDiner
//
//  Created by admin on 4/11/17.
//  Copyright © 2017 CodeWithFelix. All rights reserved.
//

class BusinessHeaderCell: UICollectionViewCell {
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.gray
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "profileImage")
        return imageView
    }()
    let name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.text = "FirstName LastName"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        backgroundColor = UIColor(r: 223, g: 233, b: 238, a: 1)
        
        addSubview(profileImageView)
        addSubview(name)
        
        profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        name.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        name.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 5).isActive = true
        name.heightAnchor.constraint(equalToConstant: 30).isActive = true
        name.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
    }
}

