//
//  RemoteImageLoaderTests.swift
//  Covid-19 TrackerTests
//
//  Created by Luiz Diniz Hammerli on 12/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import XCTest

@testable import Covid_19_Tracker

final class RemoteImageLoaderTests: XCTestCase {
    func test_init_shouldNotMakeRequest() {
        let (_, spy) = makeSUT()

        XCTAssertTrue(spy.messages.isEmpty)
    }
    
    func test_load_shouldFailWithInvalidURL() {
        let (sut, _) = makeSUT()
        var receivedResult: RemoteImageLoader.Result?
        
        sut.load(url: "", completion: { receivedResult = $0 })

        XCTAssertEqual(receivedResult, .failure(.invalidURL))
    }
    
    func test_load_() {
        let (sut, spy) = makeSUT()
        var receivedResult: RemoteImageLoader.Result?
        
        sut.load(url: makeURL().description, completion: { receivedResult = $0 })
        spy.complete(with: .failure(.invalidData), at: 0)

        XCTAssertEqual(receivedResult, .failure(.invalidData))
    }
    
    func test_load__() {
        let (sut, spy) = makeSUT()
        let fakeData = makeData()
        var receivedResult: RemoteImageLoader.Result?
        
        sut.load(url: makeURL().description, completion: { receivedResult = $0 })
        spy.complete(with: .success(fakeData), at: 0)

        XCTAssertEqual(receivedResult, .success(fakeData))
    }
}

private extension RemoteImageLoaderTests {
    func makeSUT() -> (RemoteImageLoader, HttpClientSpy) {
        let spy = HttpClientSpy()
        let sut = RemoteImageLoader(httpClient: spy)
        
        trackForMemoryLeaks(instance: sut)
        trackForMemoryLeaks(instance: spy)
        
        return (sut, spy)
    }
}
