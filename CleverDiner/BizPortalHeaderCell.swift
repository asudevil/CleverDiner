//
//  BizPortalHeaderCell.swift
//  CleverDiner
//
//  Created by admin on 4/24/17.
//  Copyright © 2017 CodeWithFelix. All rights reserved.
//

import UIKit

class BizPortalHeaderCell: UICollectionViewCell {
    
    var bizHeader: CellStruct? {
        didSet {
            guard let task = bizHeader else {
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
        tv.font = UIFont.boldSystemFont(ofSize: 20)
        tv.isEditable = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textAlignment = .center
        return tv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func setupViews() {
        
        backgroundColor = .white
        
        addSubview(imageView)
        addSubview(titleTextView)
        
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        titleTextView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleTextView.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        titleTextView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleTextView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
