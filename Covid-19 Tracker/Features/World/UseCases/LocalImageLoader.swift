//
//  LocalImageLoader.swift
//  Covid-19 Tracker
//
//  Created by Luiz Hammerli on 18/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import Foundation

final class LocalImageLoader: ImageLoader {
    let cache: CacheManager
    
    init(cache: CacheManager = UserDefaultsCacheManager()) {
        self.cache = cache
    }
    
    @discardableResult
    func load(url: String, completion: @escaping (ImageLoader.Result) -> Void) -> ImageLoaderTask? {
        let data = self.cache.fetch(key: url.description)
        
        if let data = data {
            completion(.success(data))
        } else {
            completion(.failure(.invalidData))
        }

        return nil
    }
}


final class RemoteImageLoaderWithCache: ImageLoader {
    let imageLoader: ImageLoader
    let cache: CacheManager
    
    init(imageLoader: ImageLoader = RemoteImageLoader(), cache: CacheManager = UserDefaultsCacheManager()) {
        self.cache = cache
        self.imageLoader = imageLoader
    }
    
    @discardableResult
    func load(url: String, completion: @escaping (ImageLoader.Result) -> Void) -> ImageLoaderTask? {
        imageLoader.load(url: url) {  [weak self] result in
            switch result {
            case .success(let data):
                self?.cache.save(key: url, data: data)
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
