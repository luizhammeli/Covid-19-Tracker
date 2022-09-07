//
//  LoadAllCountriesCases.swift
//  Covid-19 Tracker
//
//  Created by Luiz Diniz Hammerli on 06/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import Foundation

final class LoadAllCountriesCases: AllCountriesLoader {
    private let httpClient: HttpClient
    private let url: URL

    init(url: URL, httpClient: HttpClient = URLSessionHttpClient()) {
        self.url = url
        self.httpClient = httpClient
    }

    func load(completion: @escaping (AllCountriesLoader.Result) -> Void) {
        httpClient.get(from: url) { (result) in
            switch result {
            case .success(let data):
                guard let cases = try? JSONDecoder().decode([CountryCases].self, from: data) else {
                    completion(.failure(.invalidData))
                    return
                }
                completion(.success(cases))
            case .failure:
                completion(.failure(.genericError))
            }
        }
    }
}
