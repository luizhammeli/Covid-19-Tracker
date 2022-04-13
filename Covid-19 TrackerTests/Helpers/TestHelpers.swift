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

func makeCountryCase() -> CountryCases {
    return CountryCases(country: "",
                 cases: 0,
                 todayCases: 0,
                 deaths: 0,
                 todayDeaths: 0,
                 recovered: 0,
                 active: 0,
                 critical: 0,
                 casesPerOneMillion: 0,
                 deathsPerOneMillion: 0,
                 tests: 0,
                 testsPerOneMillion: 0,
                 countryInfo: .init(_id: 0, flag: ""))
}


func makeData() -> Data {
    return "New Test".data(using: .utf8)!
}
