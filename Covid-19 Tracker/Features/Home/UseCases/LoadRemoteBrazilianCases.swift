//
//  LoadRemoteBrazilianCases.swift
//  Covid-19 Tracker
//
//  Created by Luiz Diniz Hammerli on 12/04/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import Foundation

final class LoadRemoteBrazilianCases: CountryCasesLoader {
    let url: URL
    let httpClient: HttpClient
    
    init(url: URL, httpClient: HttpClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    func load(completion: @escaping (CountryCasesLoader.Result) -> Void) {
        httpClient.get(from: url) { result in
            switch result {
            case .failure:
                completion(.failure(.genericError))
            case .success(let data):
                guard let cases = try? JSONDecoder().decode(CountryCases.self, from: data) else { return completion(.failure(.invalidData)) }
                completion(.success(cases))
            }
        }
    }
}
