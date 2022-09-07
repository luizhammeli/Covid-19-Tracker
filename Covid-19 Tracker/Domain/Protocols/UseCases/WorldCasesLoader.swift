//
//  WorldCasesLoader.swift
//  Covid-19 Tracker
//
//  Created by Luiz Hammerli on 04/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import Foundation

protocol WorldCasesLoader {
    typealias Result = Swift.Result<WorldCases, ErrorMessages>

    func load(completion: @escaping (Result) -> Void)
}
