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
        userViewController.tabBarItem.title = "Recent"
        userViewController.tabBarItem.image = UIImage(named: "recent")
        
        viewControllers = [userViewController, createTabControllerWithTitle("Calls", imageName: "calls"), createTabControllerWithTitle("Groups", imageName: "groups"), createTabControllerWithTitle("People", imageName: "people"), createTabControllerWithTitle("Settings", imageName: "settings")]
    }
    
    fileprivate func createTabControllerWithTitle(_ title: String, imageName: String) -> UINavigationController {
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
    
}
