//
//  MainTabBarController.swift
//  Covid-19 Tracker
//
//  Created by Luiz on 10/04/20.
//  Copyright © 2020 Luiz Hammerli. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupControllers()
        setupLayout()
    }

    func setupControllers() {
        let homeController = HomeViewController()
        let navController = CustomNavigationController(rootViewController: homeController)
        navController.tabBarItem.title = "Home"
        navController.tabBarItem.image = UIImage(systemName: "house.fill")

        let worldController = UIViewController()
        let navController1 = CustomNavigationController(rootViewController: worldController)
        navController1.tabBarItem.title = "World"
        navController1.tabBarItem.image = UIImage(systemName: "globe")

        viewControllers = [navController, navController1]
    }

    func setupLayout() {
        tabBar.barTintColor = UIColor(named: "Foreground")
        tabBar.isTranslucent = false
        tabBar.tintColor = .white
    }
}
