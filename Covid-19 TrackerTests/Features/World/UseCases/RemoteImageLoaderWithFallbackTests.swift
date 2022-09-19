//
//  RemoteImageLoaderWithFallbackTests.swift
//  Covid-19 TrackerTests
//
//  Created by Luiz Hammerli on 18/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import Foundation

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
    }
}

private extension RemoteImageLoaderWithFallbackTests {
    func makeSUT() -> (RemoteImageLoaderWithFallback, ImageLoaderSpy, ImageLoaderSpy) {
        let primaryLoader = ImageLoaderSpy()
        let fallbackLoader = ImageLoaderSpy()
        let sut = RemoteImageLoaderWithFallback(primary: primaryLoader, fallback: fallbackLoader)

        return (sut, primaryLoader, fallbackLoader)
    }
}
