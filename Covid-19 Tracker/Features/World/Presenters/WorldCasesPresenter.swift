//
//  WorldCasesPresenter.swift
//  Covid-19 Tracker
//
//  Created by Luiz Hammerli on 07/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import Foundation

final class WorldCasesPresenter {
    private let loader: WorldCasesWithCountriesLoader
    private let alertView: AlertView
    private let loadingView: LoadingView
    private let worldCasesView: WorldCasesView
    
    init(loader: WorldCasesWithCountriesLoader, alertView: AlertView, worldCasesView: WorldCasesView, loadingView: LoadingView){
        self.worldCasesView = worldCasesView
        self.loader = loader
        self.alertView = alertView
        self.loadingView = loadingView
    }
    
    func loadCases() {
        loadingView.isLoading(viewModel: .init(isLoading: true))
        loader.load { [weak self] result in
            guard let self = self else { return }
            self.loadingView.isLoading(viewModel: .init(isLoading: false))
            
            switch result {
            case .success(let cases):
                let viewModel = self.mapToViewModel(allCases: cases)
                self.worldCasesView.display(viewModel: viewModel)
            case .failure(let error):
                self.alertView.display(message: .init(description: error.rawValue))
            }
        }
    }
    
    private func mapToViewModel(allCases: AllCases) -> WorldCasesViewModel {
        return WorldCasesViewModel(header: mapViewModelHeaderItem(data: allCases.worldCases),
                                   items: mapViewModelListItems(data: allCases.countryCases))
    }
    
    private func mapViewModelHeaderItem(data: WorldCases?) -> CountryCasesHeaderViewModel? {
        guard let data = data else { return nil }
        
        return CountryCasesHeaderViewModel(strTotalCount: data.cases.formatNumber(),
                                               strActiveCount: data.active.formatNumber(),
                                               strRecoveredCount: data.recovered.formatNumber(),
                                               strDeathsCount: data.deaths.formatNumber(),
                                               activeCount: Double(data.active),
                                               recoveredCount: Double(data.recovered),
                                               deathsCount: Double(data.deaths))
    }
    
    private func mapViewModelListItems(data: [CountryCases]) -> [CountryCasesViewModel] {
        data.map { countryCase in
            CountryCasesViewModel(countryCaseTypeViewModelItem: [],
                                  countryName: countryCase.country,
                                  countryFlagUrl: countryCase.countryInfo.flag,
                                  totalCases: "\(Labels.totalCases): \(countryCase.cases)")
        }
    }
}

protocol WorldCasesView {
    func display(viewModel: WorldCasesViewModel)
}
