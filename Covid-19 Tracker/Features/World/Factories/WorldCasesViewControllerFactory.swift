//
//  WorldCasesViewControllerFactory.swift
//  Covid-19 Tracker
//
//  Created by Luiz Diniz Hammerli on 09/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import Foundation

final class WorldCasesViewControllerFactory {
    private init() {}
    
    static func makeWorldCasesViewControllerFactory(loader: WorldCasesWithCountriesLoader = makeLoadAllCases()) -> WorldCasesCollectionViewController {
        let controller = WorldCasesCollectionViewController()
        let viewAdapter = WorldCasesViewAdapter(controller: controller)
        let presenter = WorldCasesPresenter(loader: MainQueueDispatchDecorator(instance: loader),
                                            alertView: WeakRefVirtualProxy(instance: controller),
                                            worldCasesView: viewAdapter,
                                            loadingView:  WeakRefVirtualProxy(instance: controller))
        controller.loadData = presenter.loadCases
        return controller
    }

    private static func makeLoadWorldCases(httpClient: HttpClient = URLSessionHttpClient(),
                                   url: URL = makeDefaultWorldCasesURL()) -> WorldCasesLoader {
        return LoadWorldCases(url: url, httpClient: httpClient)
    }
    
    private  static func makeLoadAllCountriesCases(httpClient: HttpClient = URLSessionHttpClient(),
                                   url: URL = makeDefaultCountryURL()) -> AllCountriesLoader {
        return LoadAllCountriesCases(url: url, httpClient: httpClient)
    }
    
    private  static func makeLoadAllCases(worldCasesLoader: WorldCasesLoader = makeLoadWorldCases(),
                                 allCountriesLoader: AllCountriesLoader = makeLoadAllCountriesCases()) -> WorldCasesWithCountriesLoader {
        return LoadAllCases(worldCasesLoader: worldCasesLoader, allCountriesLoader: allCountriesLoader)
    }
    
    static func makeDefaultWorldCasesURL() -> URL {
        guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            fatalError("No such url as BASE_URL in info.plist")
        }
        return URL(string: "\(baseUrl)all/")!
    }
    
    static func makeDefaultCountryURL() -> URL {
        guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            fatalError("No such url as BASE_URL in info.plist")
        }
        return URL(string: "\(baseUrl)countries/")!
    }
}

final class WorldCasesViewAdapter: WorldCasesView {
    private let controller: WorldCasesCollectionViewController
    
    init(controller: WorldCasesCollectionViewController) {
        self.controller = controller
    }
    
    func display(viewModel: WorldCasesViewModel) {
        guard let header = viewModel.header else { return }
                
        let headerCellController = ChartHeaderCellController(viewModel: header, country: "World")
        let cellControllers = viewModel.items.map { CountryCasesCellController(viewModel: $0) }
        
        controller.listSections = [.init(header: headerCellController, list: cellControllers)]
    }
}
