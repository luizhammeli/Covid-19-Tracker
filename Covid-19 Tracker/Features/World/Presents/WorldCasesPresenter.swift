//
//  WorldCasesPresenter.swift
//  Covid-19 Tracker
//
//  Created by Luiz Hammerli on 07/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import Foundation

final class WorldCasesPresenter {
    private let loader: LoadAllCases
    private let alertView: AlertView
    private let worldCasesView: WorldCasesView

    init(loader: LoadAllCases, alertView: AlertView, worldCasesView: WorldCasesView){
        self.worldCasesView = worldCasesView
        self.loader = loader
        self.alertView = alertView
    }
    
    func loadCases() {
        loader.load { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let cases):
                let viewModel = self.mapToViewModel(allCases: cases)
                self.worldCasesView.display(viewModel: viewModel)
            case .failure(let error):
                self.alertView.display(message: .init(description: error.rawValue))
            }
        }
    }
    
    private func mapToViewModel(allCases: AllCases) -> WorldCasesViewModelItem {
        return WorldCasesViewModelItem(header: mapViewModelHeaderItem(data: allCases.worldCases),
                                       items: mapViewModelListItems(data: allCases.countryCases))
    }
    
    private func mapViewModelHeaderItem(data: WorldCases?) -> CountryCasesHeaderViewModelItem? {
        guard let data = data else { return nil }
        
        return CountryCasesHeaderViewModelItem(strTotalCount: data.cases.formatNumber(),
                                               strActiveCount: data.active.formatNumber(),
                                               strRecoveredCount: data.recovered.formatNumber(),
                                               strDeathsCount: data.deaths.formatNumber(),
                                               activeCount: Double(data.active),
                                               recoveredCount: Double(data.recovered),
                                               deathsCount: Double(data.deaths))
    }

    private func mapViewModelListItems(data: [CountryCases]) -> [CountryCasesViewModelItem] {
        data.map { countryCase in
            CountryCasesViewModelItem(countryCaseTypeViewModelItem: [],
                                      countryName: countryCase.country,
                                      countryFlagUrl: countryCase.countryInfo.flag,
                                      totalCases: "\(Labels.totalCases): \(countryCase.cases)")
        }
    }
}


protocol WorldCasesView {
    func display(viewModel: WorldCasesViewModelItem)
}
