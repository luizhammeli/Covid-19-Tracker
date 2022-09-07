//
//  HomePresenter.swift
//  Covid-19 Tracker
//
//  Created by Luiz Diniz Hammerli on 13/04/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import Foundation

final class HomePresenter {
    private let loader: CountryCasesLoader
    private let loadingView: LoadingView
    private let homeView: HomeView
    private let alertView: AlertView
    
    init(loader: CountryCasesLoader, loadingView: LoadingView, homeView: HomeView, alertView: AlertView) {
        self.loader = loader
        self.loadingView = loadingView
        self.homeView = homeView
        self.alertView = alertView
    }
    
    func loadBrazilianCases() {
        loadingView.isLoading(viewModel: .init(isLoading: true))
        loader.load(completion: { [weak self] result in
            guard let self = self else { return }

            self.loadingView.isLoading(viewModel: .init(isLoading: false))
            switch result {
            case .success(let cases):
                let viewModel = self.toHomeViewModel(with: cases)
                self.homeView.display(viewModel: viewModel)
            case .failure(let message):
                self.alertView.display(message: .init(description: message.rawValue))
            }
        })
    }
    
    private func toHomeViewModel(with countryData: CountryCases) -> HomeViewModel {
        return HomeViewModel(header: CountryCasesViewModelMapper.toHeaderViewModel(countryData: countryData),
                             cases: CountryCasesViewModelMapper.toCaseTypeViewModel(countryData: countryData))
    }
}
