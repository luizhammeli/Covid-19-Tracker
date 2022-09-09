//
//  WorldCasesViewModel.swift
//  Covid-19 Tracker
//
//  Created by Luiz on 12/04/20.
//  Copyright © 2020 Luiz Hammerli. All rights reserved.
//

import Foundation

struct WorldCasesViewModel: Equatable {
    let header: CountryCasesHeaderViewModel?
    let items: [CountryCasesViewModel]
}
