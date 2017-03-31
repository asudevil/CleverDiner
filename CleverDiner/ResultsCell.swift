//
//  ResultsCell.swift
//  CleverDiner
//
//  Created by admin on 3/28/17.
//  Copyright © 2017 CodeWithFelix. All rights reserved.
//

import UIKit

class ResultsCell: UICollectionViewCell {
    
    var meetingLocImage: String? {
        didSet {
            guard let imageName = meetingLocImage else {return }
            iconImageView.image = UIImage(named: imageName)
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Default"
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Default"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    let addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Default"
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.white
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(iconImageView)
        addSubview(nameLabel)
        addSubview(phoneLabel)
        addSubview(addressLabel)
        
        iconImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 20).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        phoneLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 20).isActive = true
        phoneLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        phoneLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        phoneLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addressLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 20).isActive = true
        addressLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 3).isActive = true
        addressLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        addressLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        backgroundColor = UIColor.white
    }
}
