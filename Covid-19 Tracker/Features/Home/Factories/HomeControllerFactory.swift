//
//  HomeControllerFactory.swift
//  Covid-19 Tracker
//
//  Created by Luiz Hammerli on 13/04/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import Foundation

class HomeControllerFactory {
    private init() {}
    
    static func makeHomeController(loader: CountryCasesLoader = HomeControllerFactory.makeLoadRemoteBrazialianCases()) -> HomeViewController {
        let homeController = HomeViewController()
        let presenter = HomePresenter(loader: MainQueueDispatchDecorator(instance: loader),
                                      loadingView: WeakRefVirtualProxy(instance: homeController),
                                      homeView: WeakRefVirtualProxy(instance: homeController),
                                      alertView: WeakRefVirtualProxy(instance: homeController))
        homeController.loadData = presenter.loadBrazilianCases
        return homeController
    }
    
    static func makeLoadRemoteBrazialianCases(httpClient: HttpClient = URLSessionHttpClient(),
                                              url: URL = makeDefaultBrazilianCountryURL()) -> LoadRemoteBrazilianCases {
        return LoadRemoteBrazilianCases(url: url, httpClient: httpClient)
    }
    
    static func makeDefaultBrazilianCountryURL() -> URL {
        guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            fatalError("No such url as BASE_URL in info.plist")
        }
        return URL(string: "\(baseUrl)countries/\(Labels.brazil)")!
    }
}
