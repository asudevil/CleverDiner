//
//  Extensions.swift
//  CleverDiner
//
//  Created by admin on 4/1/17.
//  Copyright © 2017 CodeWithFelix. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a:CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
