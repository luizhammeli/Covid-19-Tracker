//
//  RemoteImageLoader.swift
//  Covid-19 Tracker
//
//  Created by Luiz Diniz Hammerli on 12/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import Foundation

final class RemoteImageLoader: ImageLoader {
    let httpClient: HttpClient
    
    init(httpClient: HttpClient = URLSessionHttpClient()) {
        self.httpClient = httpClient
    }
    
    @discardableResult
    func load(url: String, completion: @escaping (ImageLoader.Result) -> Void) -> ImageLoaderTask? {
        guard let url = URL(string: url) else {
            completion(.failure(ErrorMessages.invalidURL))
            return nil
        }
        
        httpClient.get(from: url) { result in
            if let data = try? result.get() {
                completion(.success(data))
            } else {
                completion(.failure(ErrorMessages.invalidData))
            }
        }

        return URLSessionImageLoaderTask()
    }
}
