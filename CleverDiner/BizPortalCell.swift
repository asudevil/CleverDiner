//
//  BizPortalCell.swift
//  CleverDiner
//
//  Created by admin on 4/24/17.
//  Copyright © 2017 CodeWithFelix. All rights reserved.
//

import UIKit

class BizPortalCell: UICollectionViewCell {
    
    var bizTask: CellStruct? {
        didSet {
            guard let task = bizTask else {
                return
            }
            
            imageView.image = UIImage(named: task.imageName)
            titleTextView.text = task.title
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        iv.image = UIImage(named: "25_percent_discount")
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let titleTextView: UITextView = {
        let tv = UITextView()
        tv.text = "Title"
        tv.isEditable = false
        tv.font = UIFont.boldSystemFont(ofSize: 15)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textAlignment = .center
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(imageView)
        addSubview(titleTextView)
        
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        titleTextView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleTextView.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        titleTextView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        titleTextView.widthAnchor.constraint(equalToConstant: 140).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
