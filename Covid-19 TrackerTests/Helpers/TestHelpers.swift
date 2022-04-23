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

func makeCountryCase() -> (model: CountryCases, header: CountryCasesHeaderViewModel, viewModel: [CountryCaseTypeViewModel]) {
    return (CountryCases(country: "Test",
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
                 countryInfo: .init(_id: 1, flag: "Test")),
            CountryCasesHeaderViewModel(strTotalCount: "Total Cases\n10.000",
                                        strActiveCount: "14.000",
                                        strRecoveredCount: "13.000",
                                        strDeathsCount: "",
                                        activeCount: 2,
                                        recoveredCount: 3,
                                        deathsCount: 4),
    [CountryCaseTypeViewModel(title: "Cases Today", count: "70.000", color: "CustomLightGreen")])
}

func makeData() -> Data {
    return "New Test".data(using: .utf8)!
}
