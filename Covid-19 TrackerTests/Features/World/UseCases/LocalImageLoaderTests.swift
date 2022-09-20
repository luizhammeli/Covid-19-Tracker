//
//  LocalImageLoaderTests.swift
//  Covid-19 TrackerTests
//
//  Created by Luiz Diniz Hammerli on 20/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import XCTest

@testable import Covid_19_Tracker

final class LocalImageLoaderTests: XCTestCase {
    
    func test_load_shouldSendCorrectURL() {
        let fakeURL = makeURL().description
        let (sut, spy) = makeSUT()
        
        sut.load(url: fakeURL, completion: { _ in })
        
        XCTAssertEqual(spy.fetchedData, [fakeURL])
    }
    
    func test_load_shouldCompleteWithSuccess() {
        let fakeURL = makeURL().description
        let (sut, spy) = makeSUT()
        let fakeData = makeData()
        var receivedResult: LocalImageLoader.Result?
        
        spy.fakeData = fakeData
        sut.load(url: fakeURL, completion: { receivedResult = $0 })
        
        XCTAssertEqual(receivedResult, .success(fakeData))
    }
    
    func test_load_shouldCompleteWithFailureWithInvalidData() {
        let fakeURL = makeURL().description
        let (sut, _) = makeSUT()
        var receivedResult: LocalImageLoader.Result?

        sut.load(url: fakeURL, completion: { receivedResult = $0 })

        XCTAssertEqual(receivedResult, .failure(.invalidData))
    }
}

private extension LocalImageLoaderTests {
    
    func makeSUT() -> (LocalImageLoader, CacheSpy) {
        let cacheSpy = CacheSpy()
        let sut = LocalImageLoader(cache: cacheSpy)
        
        trackForMemoryLeaks(instance: sut)
        trackForMemoryLeaks(instance: cacheSpy)
        
        return (sut, cacheSpy)
    }

}
