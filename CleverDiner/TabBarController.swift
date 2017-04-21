//
//  TabBarController.swift
//  CleverDiner
//
//  Created by admin on 4/19/17.
//  Copyright © 2017 CodeWithFelix. All rights reserved.
//

import UIKit
import FirebaseAuth

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "profile"), style: .plain, target: self, action: #selector(setProfileDetails))
        
        //setup our custom view controllers
        let userViewController = UserViewController()
        userViewController.tabBarItem.title = "Diners"
        userViewController.tabBarItem.image = UIImage(named: "diner_small")
        
        let settingsVC = SettingsVC()
        settingsVC.tabBarItem.title = "Settings"
        settingsVC.tabBarItem.image = UIImage(named: "settings_small")
        
        let bizVC = BizTab()
        bizVC.tabBarItem.title = "Business"
        bizVC.tabBarItem.image = UIImage(named: "restaurant_small")
        
        viewControllers = [userViewController, bizVC, settingsVC]
    }
    
    fileprivate func createTabControllerWithTitle(_ title: String, imageName: String) -> UINavigationController {
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
    
    func handleLogout() {
        print("Logout clicked")
        do { try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginVC = LoginController()
        
        if UserDefaults.standard.isReturningUser() {
            
            loginVC.skip()
            loginVC.nextPage()
            print("Returning User.  Page number: ", loginVC.pageControl.currentPage)
        }
        
        present(loginVC, animated: true, completion: nil)
    }
    
    func setProfileDetails() {
        
        let editProfile = EditProfileVC()
        
        navigationController?.pushViewController(editProfile, animated: true)
    }
    
}
