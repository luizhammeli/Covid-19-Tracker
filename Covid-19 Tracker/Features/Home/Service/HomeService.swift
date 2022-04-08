//
//  HomeService.swift
//  Covid-19 Tracker
//
//  Created by Luiz on 11/04/20.
//  Copyright © 2020 Luiz Hammerli. All rights reserved.
//

import Foundation

class HomeService {
    func fetchBrazilCasesData(_ completion: @escaping(Result<CountryCases, ErrorMessages>)->Void) {
        URLSessionNetworkManager.shared.fetchData(endPoint: "countries/\(Labels.brazil)", type: CountryCases.self) { (result) in
            completion(result)
        }
    }
}
