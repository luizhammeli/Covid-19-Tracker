//
//  CountryCasesHeaderViewModelItem.swift
//  Covid-19 Tracker
//
//  Created by Luiz on 12/04/20.
//  Copyright © 2020 Luiz Hammerli. All rights reserved.
//

import Foundation

struct CountryCasesHeaderViewModelItem: Codable, Equatable {
    let strTotalCount: String
    let strActiveCount: String
    let strRecoveredCount: String
    let strDeathsCount: String

    let activeCount: Double
    let recoveredCount: Double
    let deathsCount: Double
}

struct CountryCasesHeaderViewModel: Codable, Equatable {
    let strTotalCount: String
    let strActiveCount: String
    let strRecoveredCount: String
    let strDeathsCount: String

    let activeCount: Double
    let recoveredCount: Double
    let deathsCount: Double
}
