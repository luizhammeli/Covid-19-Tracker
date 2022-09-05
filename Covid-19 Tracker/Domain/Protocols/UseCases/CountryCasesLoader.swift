//
//  LoadCountryCases.swift
//  Covid-19 Tracker
//
//  Created by Luiz Diniz Hammerli on 12/04/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import Foundation

protocol LoadCountryCases {
    typealias Result = Swift.Result<WorldCases, ErrorMessages>

    func load(_ completion: @escaping (Result) -> Void)
}
