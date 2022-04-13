//
//  TestHelpers.swift
//  Covid-19 TrackerTests
//
//  Created by Luiz Diniz Hammerli on 12/04/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import Foundation
@testable import Covid_19_Tracker

func makeURL(stringURL: String = "https://www.test.com") -> URL {
    return URL(string: stringURL)!
}

func makeCountryCase() -> (CountryCases) {
    return CountryCases(country: "Test",
                 cases: 10000,
                 todayCases: 70000,
                 deaths: 12500,
                 todayDeaths: 0,
                 recovered: 13000,
                 active: 14000,
                 critical: 10000,
                 casesPerOneMillion: 15000,
                 deathsPerOneMillion: 16000,
                 tests: 170000,
                 testsPerOneMillion: 180000,
                 countryInfo: .init(_id: 1, flag: "Test"))
    
//    CountryCasesHeaderViewModel(strTotalCount: "10.000",
//                                strActiveCount: "14.000",
//                                strRecoveredCount: "13.000",
//                                strDeathsCount: "12.500",
//                                activeCount: 14000,
//                                recoveredCount: 13000,
//                                deathsCount: 12500)
}


func makeData() -> Data {
    return "New Test".data(using: .utf8)!
}
