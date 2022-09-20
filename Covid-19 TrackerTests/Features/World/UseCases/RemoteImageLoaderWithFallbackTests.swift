//
//  RemoteImageLoaderWithFallbackTests.swift
//  Covid-19 TrackerTests
//
//  Created by Luiz Hammerli on 18/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import XCTest

@testable import Covid_19_Tracker

final class RemoteImageLoaderWithFallbackTests: XCTestCase {
    
    func test_load_shouldSendCorrectURLForPrimaryLoader() {
        let fakeURL = makeURL().description
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
        
        sut.load(url: fakeURL, completion: { _ in })
                
        XCTAssertEqual(primaryLoader.urls, [fakeURL])
        XCTAssertTrue(fallbackLoader.urls.isEmpty)
    }
    
    func test_load_shouldSendCorrectURLForFallbackLoader() {
        let fakeURL = makeURL().description
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
        
        sut.load(url: fakeURL, completion: { _ in })
        primaryLoader.complete(with: .failure(.genericError))
                        
        XCTAssertEqual(fallbackLoader.urls, [fakeURL])
        XCTAssertFalse(fallbackLoader.messages.isEmpty)
    }
    
    func test_load_shouldSucceedWithFallbackIfPrimaryLoaderFails() {
        var receivedResult: ImageLoader.Result?
        let fakeData = makeData()
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
        
        sut.load(url: makeURL().description, completion: { receivedResult = $0 })
        primaryLoader.complete(with: .failure(.genericError))
        fallbackLoader.complete(with: .success(fakeData))
                                
        XCTAssertEqual(receivedResult, .success(fakeData))
    }
    
    func test_load_shouldFailWithFallbackIfPrimaryLoaderFails() {
        var receivedResult: ImageLoader.Result?
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
        
        sut.load(url: makeURL().description, completion: { receivedResult = $0 })
        primaryLoader.complete(with: .failure(.genericError))
        fallbackLoader.complete(with: .failure(.invalidData))
                                
        XCTAssertEqual(receivedResult, .failure(.invalidData))
    }
    
    func test_load_shouldSucceedWithPrimaryLoader() {
        let fakeData = makeData()
        var receivedResult: ImageLoader.Result?
        let (sut, primaryLoader, _) = makeSUT()
        
        sut.load(url: makeURL().description, completion: { receivedResult = $0 })
        primaryLoader.complete(with: .success(fakeData))
                                
        XCTAssertEqual(receivedResult, .success(fakeData))
    }
}

private extension RemoteImageLoaderWithFallbackTests {
    func makeSUT() -> (RemoteImageLoaderWithFallback, ImageLoaderSpy, ImageLoaderSpy) {
        let primaryLoader = ImageLoaderSpy()
        let fallbackLoader = ImageLoaderSpy()
        let sut = RemoteImageLoaderWithFallback(primary: primaryLoader, fallback: fallbackLoader)
        
        trackForMemoryLeaks(instance: sut)
        trackForMemoryLeaks(instance: primaryLoader)
        trackForMemoryLeaks(instance: fallbackLoader)
        
        return (sut, primaryLoader, fallbackLoader)
    }
}
