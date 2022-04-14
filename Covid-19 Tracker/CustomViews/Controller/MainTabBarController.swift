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
        guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            fatalError("No such url as BASE_URL in info.plist")
        }
        let homeController = HomeViewController()
        let url = URL(string: "\(baseUrl)countries/\(Labels.brazil)")!
        let loader = LoadRemoteBrazilianCases(url: url, httpClient: URLSessionHttpClient())
        let presenter = HomePresenter(loader: MainQueueDispatchDecorator(instance: loader), loadingView: WeakRefVirtualProxy(instance: homeController), homeView: WeakRefVirtualProxy(instance: homeController), alertView: WeakRefVirtualProxy(instance: homeController))
        homeController.loadData = presenter.loadBrazilianCases
        let navController = CustomNavigationController(rootViewController: homeController)
        navController.tabBarItem.title = Labels.home
        navController.tabBarItem.image = UIImage(systemName: "house.fill")

        let worldController = WorldCasesCollectionViewController(viewModel: WorldCasesViewModel(service: WorldCasesServices()))
        let navController1 = CustomNavigationController(rootViewController: worldController)
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

private final class MainQueueDispatchDecorator<T> {
    let instance: T
    
    init(instance: T) {
        self.instance = instance
    }
    
    private func dispatch(completion: @escaping () -> Void) {
        guard !Thread.isMainThread else { return completion() }
        
        DispatchQueue.main.async {
            completion()
        }
    }
}

extension MainQueueDispatchDecorator: CountryCasesLoader where T: CountryCasesLoader {
    func load(completion: @escaping (CountryCasesLoader.Result) -> Void) {
        instance.load { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }
}

private final class WeakRefVirtualProxy<T: AnyObject> {
    weak var instance: T?
    
    init(instance: T) {
        self.instance = instance
    }
}

extension WeakRefVirtualProxy: AlertView where T: AlertView {
    func display(message: AlertViewModel) {
        instance?.display(message: message)
    }
    
    
}

extension WeakRefVirtualProxy: LoadingView where T: LoadingView {
    func isLoading(viewModel: LoadingViewModel) {
        instance?.isLoading(viewModel: viewModel)
    }
}


extension WeakRefVirtualProxy: HomeView where T: HomeView {
    func display(viewModel: HomeViewModel) {
        instance?.display(viewModel: viewModel)
    }
}
