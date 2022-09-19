//
//  RemoteImageLoaderWithFallback.swift
//  Covid-19 Tracker
//
//  Created by Luiz Hammerli on 18/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import Foundation

final class RemoteImageLoaderWithFallback: ImageLoader {
    let primary: ImageLoader
    let fallback: ImageLoader
    
    init(primary: ImageLoader, fallback: ImageLoader) {
        self.primary = primary
        self.fallback = fallback
    }

    @discardableResult
    func load(url: String, completion: @escaping (ImageLoader.Result) -> Void) -> ImageLoaderTask? {
        primary.load(url: url) { [weak self] result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure:
                self?.fallback.load(url: url, completion: completion)
            }
        }

        return URLSessionImageLoaderTask()
    }
}
