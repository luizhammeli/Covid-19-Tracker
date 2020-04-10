//
//  CustomNavigationController.swift
//  Covid-19 Tracker
//
//  Created by Luiz on 10/04/20.
//  Copyright © 2020 Luiz Hammerli. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    func setupLayout() {
        navigationBar.barTintColor = UIColor(named: "Foreground")
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationBar.layer.shadowOffset = CGSize(width: 0, height: 3)
        navigationBar.layer.shadowRadius = 10
        navigationBar.layer.shadowOpacity = 0.3
        self.navigationBar.isTranslucent = false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
