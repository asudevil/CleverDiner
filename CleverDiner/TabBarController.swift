//
//  TabBarController.swift
//  CleverDiner
//
//  Created by admin on 4/19/17.
//  Copyright © 2017 CodeWithFelix. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup our custom view controllers
        let userViewController = UserViewController()
        userViewController.tabBarItem.title = "Diners"
        userViewController.tabBarItem.image = UIImage(named: "diner_small")
        
        viewControllers = [userViewController, createTabControllerWithTitle("Restaurant Owners", imageName: "restaurant_small"), createTabControllerWithTitle("Settings", imageName: "settings_small")]
    }
    
    fileprivate func createTabControllerWithTitle(_ title: String, imageName: String) -> UINavigationController {
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
    
}
