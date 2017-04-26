//
//  MealTypeCell.swift
//  CleverDiner
//
//  Created by admin on 4/19/17.
//  Copyright © 2017 CodeWithFelix. All rights reserved.
//

import UIKit

class MealTypeCell: UICollectionViewCell {
    
    var mealType: CellStruct? {
        didSet {
            guard let mealType = mealType else {
                return
            }
            
            imageView.image = UIImage(named: mealType.imageName)
            textView.text = mealType.title
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
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "Breakfast"
        tv.isEditable = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textAlignment = .center
        return tv
    }()
    
    let lineSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func setupViews() {
        addSubview(imageView)
        addSubview(textView)
        addSubview(lineSeparatorView)
                
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        textView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        lineSeparatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        lineSeparatorView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        lineSeparatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
