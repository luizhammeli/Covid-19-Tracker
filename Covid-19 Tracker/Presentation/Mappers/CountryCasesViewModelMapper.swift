//
//  CountryCasesViewModelMapper.swift
//  Covid-19 Tracker
//
//  Created by Luiz Hammerli on 12/04/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import Foundation

final class CountryCasesViewModelMapper {
    static func toHeaderViewModel(countryData: CountryCases) -> CountryCasesHeaderViewModel {
        return CountryCasesHeaderViewModel(strTotalCount: countryData.cases.formatNumber(),
                                           strActiveCount: countryData.active.formatNumber(),
                                           strRecoveredCount: countryData.recovered.formatNumber(),
                                           strDeathsCount: countryData.deaths.formatNumber(),
                                           activeCount: Double(countryData.active),
                                           recoveredCount: Double(countryData.recovered),
                                           deathsCount: Double(countryData.deaths))
    }
    
    static func toCaseTypeViewModel(countryData: CountryCases) -> [CountryCaseTypeViewModel] {
        return [
            CountryCaseTypeViewModel(title: Labels.todayCases,
                                     count: countryData.todayCases.formatNumber(),
                                     color: "CustomLightGreen"),
            
            CountryCaseTypeViewModel(title: Labels.casesOneMillion,
                                     count: Int(countryData.casesPerOneMillion).formatNumber(),
                                     color: "CustomPink"),
            
            CountryCaseTypeViewModel(title: Labels.deathsToday,
                                     count: countryData.todayDeaths.formatNumber(),
                                     color: "CustomPurple"),
            
            CountryCaseTypeViewModel(title: Labels.deathsOneMillion,
                                     count: Int(countryData.deathsPerOneMillion).formatNumber(),
                                     color: "CustomPink2"),
            
            CountryCaseTypeViewModel(title: Labels.totalTests,
                                     count: countryData.tests.formatNumber(),
                                     color: "CustomBrown"),
            
            CountryCaseTypeViewModel(title: Labels.testsOneMillion,
                                     count: Int(countryData.testsPerOneMillion).formatNumber(),
                                     color: "CustomDarkPurple")
        ]
    }
}
