//
//  WorldCasesServices.swift
//  Covid-19 Tracker
//
//  Created by Luiz on 12/04/20.
//  Copyright © 2020 Luiz Hammerli. All rights reserved.
//

import Foundation

class WorldCasesServices {
    func fetchWorldCasesData(_ completion: @escaping(Result<WorldCases, ErrorMessages>)->Void) {
        URLSessionNetworkManager.shared.fetchData(endPoint: "all", type: WorldCases.self) { (result) in
            completion(result)
        }
    }

    func fetchAllCountriesCasesData(_ completion: @escaping(Result<[CountryCases], ErrorMessages>)->Void) {
        URLSessionNetworkManager.shared.fetchData(endPoint: "countries", type: [CountryCases].self) { (result) in
            completion(result)
        }
    }
}
