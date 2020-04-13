//
//  CountryCasesViewModelItem.swift
//  Covid-19 Tracker
//
//  Created by Luiz on 12/04/20.
//  Copyright © 2020 Luiz Hammerli. All rights reserved.
//

import UIKit

struct CountryCaseTypeViewModelItem {
    let title: String
    let count: String
    let color: UIColor?
}

struct CountryCasesViewModelItem {
    let countryCaseTypeViewModelItem: [CountryCaseTypeViewModelItem]
    let countryName: String
    let countryFlagUrl: String
    let totalCases: String
}
