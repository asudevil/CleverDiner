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
    
    let titleViewImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "the_clever_diner")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.frame = CGRect(x: 70, y: 0, width: 200, height: 44)
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "profile"), style: .plain, target: self, action: #selector(setProfileDetails))
        
        navigationItem.titleView = titleViewImage
            
        view.backgroundColor = UIColor.white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkIfUserIsLoggedIn()
        setupTabViews()
    }
    
    func setupTabViews() {
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
        
        let bizPortalLayout = UICollectionViewFlowLayout()
        let bizPortal = BizPortal(collectionViewLayout: bizPortalLayout)
        bizPortal.tabBarItem.title = "Business Portal"
        bizPortal.tabBarItem.image = UIImage(named: "restaurant_small")
        
        print("Checking to see if its biz or user")
        if UserDefaults.standard.isBusinessUser() {
            viewControllers = [bizPortal, settingsVC]
            
        } else {
            viewControllers = [userViewController, bizVC, settingsVC]
        }
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

        let loginVC = LoginController()
        
        if UserDefaults.standard.isReturningUser() {
            
            loginVC.skip()
            loginVC.nextPage()
        }
        
        present(loginVC, animated: true, completion: nil)
        
        do { try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
    }
    
    func checkIfUserIsLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            print("User is logged In:  UserView")
        }
    }
    
    func setProfileDetails() {
        
        let editProfile = EditProfileVC()
        
        navigationController?.pushViewController(editProfile, animated: true)
    }
}
