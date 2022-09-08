//
//  CountryCasesViewModelItem.swift
//  Covid-19 Tracker
//
//  Created by Luiz on 12/04/20.
//  Copyright © 2020 Luiz Hammerli. All rights reserved.
//

import UIKit

struct CountryCaseTypeViewModelItem: Equatable {
    let title: String
    let count: String
    let color: UIColor?
}

struct CountryCasesViewModelItem: Equatable {
    let countryCaseTypeViewModelItem: [CountryCaseTypeViewModelItem]
    let countryName: String
    let countryFlagUrl: String
    let totalCases: String
}

struct CountryCaseTypeViewModel: Equatable {
    let title: String
    let count: String
    let color: String?
}

struct CountryCasesViewModel: Equatable {
    let countryCaseTypeViewModelItem: [CountryCaseTypeViewModel]
    let countryName: String
    let countryFlagUrl: String
    let totalCases: String
}
