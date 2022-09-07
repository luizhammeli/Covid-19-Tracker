//
//  AllCases.swift
//  Covid-19 Tracker
//
//  Created by Luiz Diniz Hammerli on 07/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import Foundation

struct AllCases: Codable, Equatable {
    let worldCases: WorldCases
    let countryCases: [CountryCases]
}
