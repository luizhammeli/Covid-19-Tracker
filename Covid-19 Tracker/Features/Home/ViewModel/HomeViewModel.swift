//
//  HomeViewModel.swift
//  Covid-19 Tracker
//
//  Created by Luiz on 11/04/20.
//  Copyright © 2020 Luiz Hammerli. All rights reserved.
//

import UIKit

struct HomeViewModel {
    let header: CountryCasesHeaderViewModel
    let cases: [CountryCaseTypeViewModel]
}

//class HomeViewModel {
//    var countryCasesHeaderViewModelItem: CountryCasesHeaderViewModelItem?
//    var countryCasesViewModelItems = [CountryCaseTypeViewModelItem]()
//
//    let service: HomeService
//
//    init(service: HomeService){
//        self.service = service
//    }
//
//    func getBrazilCasesData(_ completion: @escaping (Bool, String?) -> Void) {
//        service.fetchBrazilCasesData { [weak self] (result) in
//            switch result {
//            case .success(let countryData):
//                self?.mapViewModelItems(countryData: countryData)
//                completion(true, nil)
//            case .failure(let error):
//                completion(false, error.rawValue)
//            }
//        }
//    }
//
//    func mapViewModelItems(countryData: CountryCases) {
//        countryCasesViewModelItems.removeAll()
//
//        countryCasesHeaderViewModelItem = CountryCasesHeaderViewModelItem(strTotalCount: formatNumber(countryData.cases),
//                                                                          strActiveCount: formatNumber(countryData.active),
//                                                                          strRecoveredCount: formatNumber(countryData.recovered),
//                                                                          strDeathsCount: formatNumber(countryData.deaths),
//                                                                          activeCount: Double(countryData.active),
//                                                                          recoveredCount: Double(countryData.recovered),
//                                                                          deathsCount: Double(countryData.deaths))
//
//        countryCasesViewModelItems.append(CountryCaseTypeViewModelItem(title: Labels.todayCases,
//                                                                    count: formatNumber(countryData.todayCases),
//                                                                    color: UIColor(named: "CustomLightGreen")))
//
//        countryCasesViewModelItems.append(CountryCaseTypeViewModelItem(title: Labels.casesOneMillion,
//                                                                    count: formatNumber(Int(countryData.casesPerOneMillion)),
//                                                                    color: UIColor(named: "CustomPink")))
//
//        countryCasesViewModelItems.append(CountryCaseTypeViewModelItem(title: Labels.deathsToday,
//                                                                    count: formatNumber(countryData.todayDeaths),
//                                                                    color: UIColor(named: "CustomPurple")))
//
//        countryCasesViewModelItems.append(CountryCaseTypeViewModelItem(title: Labels.deathsOneMillion,
//                                                                    count: formatNumber(Int(countryData.deathsPerOneMillion)),
//                                                                    color: UIColor(named: "CustomPink2")))
//
//        countryCasesViewModelItems.append(CountryCaseTypeViewModelItem(title: Labels.totalTests,
//                                                                    count: formatNumber(countryData.tests),
//                                                                    color: UIColor(named: "CustomBrown")))
//
//        countryCasesViewModelItems.append(CountryCaseTypeViewModelItem(title: Labels.testsOneMillion,
//                                                                    count: formatNumber(Int(countryData.testsPerOneMillion)),
//                                                                    color: UIColor(named: "CustomDarkPurple")))
//    }
//
//    func formatNumber(_ number: Int) -> String {
//        let formater = NumberFormatter()
//        formater.groupingSeparator = "."
//        formater.numberStyle = .decimal
//        guard let formattedNumber = formater.string(from: NSNumber(value: number)) else { return "0" }
//        return formattedNumber
//    }
//
//    func getViewModelItem(indexPath: IndexPath) -> CountryCaseTypeViewModelItem{
//        return countryCasesViewModelItems[indexPath.item]
//    }
//
//    func getViewModelHeaderItem() -> CountryCasesHeaderViewModelItem? {
//        return countryCasesHeaderViewModelItem
//    }
//
//    func getNumberOfItems() -> Int{
//        return countryCasesViewModelItems.count
//    }
//}
//
