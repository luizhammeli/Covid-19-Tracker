//
//  LoadWorldCases.swift
//  Covid-19 Tracker
//
//  Created by Luiz Diniz Hammerli on 06/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import Foundation

final class LoadWorldCases: WorldCasesLoader {
    private let httpClient: HttpClient
    private let url: URL

    init(url: URL, httpClient: HttpClient = URLSessionHttpClient()) {
        self.url = url
        self.httpClient = httpClient
    }

    func load(completion: @escaping (WorldCasesLoader.Result) -> Void) {
        httpClient.get(from: url) { (result) in
            switch result {
            case .success(let data):
                guard let worldCases = try? JSONDecoder().decode(WorldCases.self, from: data) else {
                    completion(.failure(.invalidData))
                    return
                }
                completion(.success(worldCases))
            case .failure:
                completion(.failure(.genericError))
            }
        }
    }
}
