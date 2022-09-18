//
//  NetworkManager.swift
//  Covid-19 Tracker
//
//  Created by Luiz on 11/04/20.
//  Copyright © 2020 Luiz Hammerli. All rights reserved.
//

import UIKit

protocol HttpClient {
    typealias Result = Swift.Result<Data, HttpError>
    func get(from url: URL, completion: @escaping (HttpClient.Result) -> Void)
}

final class URLSessionImageLoaderTask: ImageLoaderTask {
    func cancel() {}
}

final class URLSessionHttpClient: HttpClient {
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (Result<Data, HttpError>) -> Void) {
        session.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completion(.failure(.noConnectivity))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }

            guard let data = data, !data.isEmpty else {
                completion(.failure(.invalidData))
                return
            }

            completion(.success(data))
        }.resume()
    }
}
