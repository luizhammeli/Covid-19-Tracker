//
//  WorldCasesViewModel.swift
//  Covid-19 Tracker
//
//  Created by Luiz on 12/04/20.
//  Copyright © 2020 Luiz Hammerli. All rights reserved.
//

import Foundation

final class WorldCasesViewModel {
    let service: WorldCasesServices
    var countryCasesHeaderViewModelItem: CountryCasesHeaderViewModelItem?
    var countryCasesViewModelItems = [CountryCasesViewModelItem]()

    init(service: WorldCasesServices){
        self.service = service
    }

    func getWorldCasesData(_ completion: @escaping (Bool, String?) -> Void) {
        countryCasesViewModelItems.removeAll()
        service.fetchWorldCasesData { [weak self] (result) in
            switch result {
            case .success(let worldCasesData):
                self?.mapViewModelHeaderItem(data: worldCasesData)
                self?.getCountriesCasesData(completion)
            case .failure(let error):
                completion(false, error.rawValue)
            }
        }
    }

    func getCountriesCasesData(_ completion: @escaping (Bool, String?) -> Void) {
        service.fetchAllCountriesCasesData { [weak self] (result) in
            switch result {
            case .success(let casesData):
                self?.mapViewModelItem(data: casesData)
                completion(true, nil)
            case .failure(let error):
                completion(false, error.rawValue)
            }
        }
    }

    func mapViewModelHeaderItem(data: WorldCases) {
        countryCasesHeaderViewModelItem = CountryCasesHeaderViewModelItem(strTotalCount: data.cases.formatNumber(),
                                                                          strActiveCount: data.active.formatNumber(),
                                                                          strRecoveredCount: data.recovered.formatNumber(),
                                                                          strDeathsCount: data.deaths.formatNumber(),
                                                                          activeCount: Double(data.active),
                                                                          recoveredCount: Double(data.recovered),
                                                                          deathsCount: Double(data.deaths))
    }

    func mapViewModelItem(data: [CountryCases]) {
        data.forEach { (countryCase) in
            let viewModelItem = CountryCasesViewModelItem(countryCaseTypeViewModelItem: [],
                                      countryName: countryCase.country,
                                      countryFlagUrl: countryCase.countryInfo.flag,
                                      totalCases: "\(Labels.totalCases): \(countryCase.cases)")
            countryCasesViewModelItems.append(viewModelItem)
        }
    }

    func getNumberOfItems() -> Int{
        return countryCasesViewModelItems.count
    }

    func getViewModelItem(with indexPath: IndexPath) -> CountryCasesViewModelItem {
        return countryCasesViewModelItems[indexPath.item]
    }

    func getViewModelHeaderItem() -> CountryCasesHeaderViewModelItem? {
        return countryCasesHeaderViewModelItem
    }
}
