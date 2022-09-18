//
//  WorldCasesViewControllerFactory.swift
//  Covid-19 Tracker
//
//  Created by Luiz Diniz Hammerli on 09/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import Foundation
import UIKit

final class WorldCasesViewControllerFactory {
    private init() {}
    
    static func makeWorldCasesViewControllerFactory(loader: WorldCasesWithCountriesLoader = makeLoadAllCases(),
                                                    imageLoader: ImageLoader = makeImageLoaderComposer()) -> WorldCasesCollectionViewController {
        let controller = WorldCasesCollectionViewController()
        let viewAdapter = WorldCasesViewAdapter(controller: controller, imageLoader: MainQueueDispatchDecorator(instance: imageLoader))
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
    
    private static func makeLoadAllCountriesCases(httpClient: HttpClient = URLSessionHttpClient(),
                                   url: URL = makeDefaultCountryURL()) -> AllCountriesLoader {
        return LoadAllCountriesCases(url: url, httpClient: httpClient)
    }
    
    private static func makeImageLoaderComposer(primary: ImageLoader = makeLocalImageLoader(),
                                                fallback: ImageLoader = makeImageLoaderDecorator()) -> ImageLoader {
        return RemoteImageLoaderWithFallback(primary: primary, fallback: fallback)
    }
    
    private static func makeImageLoaderDecorator(imageLoader: ImageLoader = makeImageLoader()) -> ImageLoader {
        return ImageLoaderDecorator(instance: imageLoader)
    }
    
    private static func makeLocalImageLoader(cache: CacheManager = UserDefaultsCacheManager()) -> ImageLoader {
        return LocalImageLoader(cache: cache)
    }
    
    private static func makeImageLoader(httpClient: HttpClient = URLSessionHttpClient()) -> ImageLoader {
        return RemoteImageLoader(httpClient: httpClient)
    }
    
    private static func makeLoadAllCases(worldCasesLoader: WorldCasesLoader = makeLoadWorldCases(),
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
    private weak var controller: WorldCasesCollectionViewController?
    private var imageLoader: ImageLoader
    
    init(controller: WorldCasesCollectionViewController, imageLoader: ImageLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(viewModel: WorldCasesViewModel) {
        guard let header = viewModel.header else { return }
        let headerCellController = ChartHeaderCellController(viewModel: header, country: "World")
        let cellControllers = viewModel.items.map { viewModel -> CountryCasesCellController in
            let controller = CountryCasesCellController(viewModel: viewModel)
            let presenter = CountryCasesCellPresenter(loader: imageLoader,
                                                      imageView: WeakRefVirtualProxy(instance: controller),
                                                      imageTransformer: UIImage.init)
            controller.loadImage = presenter.loadImage
            return controller
        }
        
        controller?.listSections = [.init(header: headerCellController, list: cellControllers)]
    }
}
