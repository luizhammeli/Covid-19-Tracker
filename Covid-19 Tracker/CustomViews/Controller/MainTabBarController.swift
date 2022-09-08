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
        let navController = CustomNavigationController(rootViewController: HomeControllerFactory.makeHomeController())
        navController.tabBarItem.title = Labels.home
        navController.tabBarItem.image = UIImage(systemName: "house.fill")

        //let worldController = WorldCasesCollectionViewController(viewModel: WorldCasesViewModel(service: WorldCasesServices()))
        let navController1 = CustomNavigationController(rootViewController: UIViewController())
        navController1.tabBarItem.title = Labels.world
        navController1.tabBarItem.image = UIImage(systemName: "globe")

        viewControllers = [navController, navController1]
    }

    func setupLayout() {
        tabBar.barTintColor = UIColor(named: Colors.foreground)
        tabBar.isTranslucent = false
        tabBar.tintColor = .white
    }
}
