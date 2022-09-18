//
//  LocalImageLoader.swift
//  Covid-19 Tracker
//
//  Created by Luiz Hammerli on 18/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import Foundation

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

final class ImageLoaderDecorator<T> {
    let instance: T
    let cache: CacheManager
    
    init(instance: T, cache: CacheManager = UserDefaultsCacheManager()) {
        self.instance = instance
        self.cache = cache
    }
}

extension ImageLoaderDecorator: ImageLoader where T == ImageLoader {
    func load(url: String, completion: @escaping (ImageLoader.Result) -> Void) -> ImageLoaderTask? {
        instance.load(url: url) {  [weak self] result in
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
