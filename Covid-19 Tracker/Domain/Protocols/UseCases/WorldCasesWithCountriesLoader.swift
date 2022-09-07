//
//  WorldCasesWithCountriesLoader.swift
//  Covid-19 Tracker
//
//  Created by Luiz Diniz Hammerli on 07/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import Foundation

protocol WorldCasesWithCountriesLoader {
    typealias Result = Swift.Result<AllCases, ErrorMessages>

    func load(completion: @escaping (Result) -> Void)
}
