//
//  RemoteImageLoaderWithCacheTests.swift
//  Covid-19 TrackerTests
//
//  Created by Luiz Diniz Hammerli on 18/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import XCTest

@testable import Covid_19_Tracker

final class RemoteImageLoaderWithCacheTests: XCTestCase {
    func test_load_shouldSendCorrectURL() {
        let url = makeURL()
        let (sut, loaderSpy) = makeSUT()
        
        sut.load(url: url.description) { _ in }
        
        XCTAssertEqual(loaderSpy.urls, [url.description])
    }
    
    func test_load_shouldNotSaveCahceIfCompletioFailure() {
        let url = makeURL()
        let cacheSpy = CacheSpy()
        var receivedResult: ImageLoader.Result?
        let (sut, loaderSpy) = makeSUT(cache: cacheSpy)
        
        sut.load(url: url.description) { receivedResult = $0 }
        loaderSpy.complete(with: .failure(.genericError))
        
        XCTAssertEqual(receivedResult, .failure(.genericError))
        XCTAssertTrue(cacheSpy.savedData.isEmpty)
    }
    
    func test_load_shouldSucceedAndSaveCache() {
        let fakeURL = makeURL().description
        let fakeData = makeData()
        let cacheSpy = CacheSpy()
        var receivedResult: ImageLoader.Result?
        let (sut, loaderSpy) = makeSUT(cache: cacheSpy)
        
        sut.load(url: fakeURL) { receivedResult = $0 }
        loaderSpy.complete(with: .success(fakeData))
        
        XCTAssertEqual(receivedResult, .success(fakeData))
        XCTAssertEqual(cacheSpy.savedData.count, 1)
        XCTAssertEqual(cacheSpy.savedData.first?.key, fakeURL)
        XCTAssertEqual(cacheSpy.savedData.first?.data, fakeData)
    }
}

private extension RemoteImageLoaderWithCacheTests {
    func makeSUT(cache: CacheManager = CacheSpy()) -> (RemoteImageLoaderWithCache, ImageLoaderSpy) {
        let imageLoader = ImageLoaderSpy()
        let sut = RemoteImageLoaderWithCache(imageLoader: imageLoader, cache: cache)

        trackForMemoryLeaks(instance: sut)
        trackForMemoryLeaks(instance: imageLoader)
        
        return (sut, imageLoader)
    }
}

final class CacheSpy: CacheManager {
    var savedData: [(key: String, data: Data)] = []
    var fetchedData: [String] = []
    var fakeData: Data?
    
    func save(key: String, data: Data) {
        savedData.append((key: key, data: data))
    }
    
    func fetch(key: String) -> Data? {
        fetchedData.append(key)
        return fakeData
    }
    
    func delete(key: String) {

    }
}
