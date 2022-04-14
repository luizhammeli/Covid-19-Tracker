//
//  WeakRefVirtualProxy.swift
//  Covid-19 Tracker
//
//  Created by Luiz Hammerli on 13/04/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import Foundation

final class WeakRefVirtualProxy<T: AnyObject> {
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
