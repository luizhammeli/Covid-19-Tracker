//
//  LoadWorldCasesTests.swift
//  Covid-19 TrackerTests
//
//  Created by Luiz Diniz Hammerli on 06/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import XCTest

@testable import Covid_19_Tracker

final class LoadWorldCasesTests: XCTestCase {
    func test_load_shouldSendCorrectURL() {
        let url = makeURL()
        let (sut, spy) = makeSUT(url: url)
        
        sut.load(completion: { _ in })
        
        XCTAssertEqual(spy.urls, [url])
    }
    
    func test_load_shouldFailIfClientCompletesWithFailure() {
        let (sut, spy) = makeSUT()
        
        expect(sut: sut, with: .failure(.genericError)) {
            spy.complete(with: .failure(.badRequest))
        }
    }
    
    func test_load_shouldFailIfClientCompletesSuccessWithInvalidData() {
        let (sut, spy) = makeSUT()
        
        expect(sut: sut, with: .failure(.invalidData)) {
            spy.complete(with: .success(makeData()))
        }
    }
    
    func test_load_shouldFailIfClientCompletesSuccessWithEmptyData() {
        let (sut, spy) = makeSUT()
        
        expect(sut: sut, with: .failure(.invalidData)) {
            spy.complete(with: .success(makeData()))
        }
    }
    
    func test_load_shouldSucceedIfClientCompletesSuccess() {
        let expectedData = makeWorldCases()
        let (sut, spy) = makeSUT()
        
        expect(sut: sut, with: .success(expectedData)) {
            spy.complete(with: .success(try! JSONEncoder().encode(expectedData)))
        }
    }
}

private extension LoadWorldCasesTests {
    func makeSUT(url: URL = makeURL()) -> (LoadWorldCases, HttpClientSpy) {
        let spy = HttpClientSpy()
        let sut = LoadWorldCases(url: url, httpClient: spy)
        
        trackForMemoryLeaks(instance: spy)
        trackForMemoryLeaks(instance: sut)
        
        return (sut, spy)
    }
    
    func expect(sut: LoadWorldCases, with expectedResult: LoadWorldCases.Result, when action: @escaping () -> Void) {
        var receivedData: LoadWorldCases.Result?
        
        sut.load(completion: { receivedData = $0 })
        action()
        
        XCTAssertEqual(receivedData, expectedResult)
    }
}
