//
//  LoadAllCases.swift
//  Covid-19 Tracker
//
//  Created by Luiz Diniz Hammerli on 07/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import Foundation

final class LoadAllCases: WorldCasesWithCountriesLoader {    
    private let worldCasesLoader: WorldCasesLoader
    private let allCountriesLoader: AllCountriesLoader

    init(worldCasesLoader: WorldCasesLoader, allCountriesLoader: AllCountriesLoader) {
        self.worldCasesLoader = worldCasesLoader
        self.allCountriesLoader = allCountriesLoader
    }

    func load(completion: @escaping (LoadAllCases.Result) -> Void) {
        var worldCasesResult: WorldCasesLoader.Result?
        var allCountriesCases: AllCountriesLoader.Result?
        let group = DispatchGroup()
        
        group.enter()
        worldCasesLoader.load { result in
            worldCasesResult = result
            group.leave()
        }
        
        group.enter()
        allCountriesLoader.load { result in
            allCountriesCases = result
            group.leave()
        }
                
        group.notify(queue: .global()) { [weak self] in
            guard let self = self else { return }
            let result = self.mapToResult(worldCasesResult: worldCasesResult, allCountriesCases: allCountriesCases)
            completion(result)
        }
    }
    
    private func mapToResult(worldCasesResult: WorldCasesLoader.Result?, allCountriesCases: AllCountriesLoader.Result?) -> LoadAllCases.Result {
        let worldCases = try? worldCasesResult?.get()
        let allCountries = try? allCountriesCases?.get()
        
        guard worldCases != nil || allCountries != nil else { return .failure(.invalidData) }
        
        return .success(.init(worldCases: worldCases, countryCases: allCountries ?? []))
    }
}
