//
//  LoadBrazilianCasesTests.swift
//  Covid-19 TrackerTests
//
//  Created by Luiz Hammerli on 10/04/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import XCTest
@testable import Covid_19_Tracker

final class LoadRemoteBrazilianCasesTests: XCTestCase {
    func test_init_shouldNotStartRequest() {
        let (_, clientSpy) = makeSUT()
        XCTAssertTrue(clientSpy.urls.isEmpty)
    }
    
    func test_load_deliversCorrectURL() {
        let url = makeURL()
        let (sut, clientSpy) = makeSUT(url: url)
        sut.load(completion: { _ in })
        XCTAssertEqual(clientSpy.urls, [url])
    }
    
    func test_load_deliversGenericErrorIfClientCompletesWithFailure() {
        let (sut, clientSpy) = makeSUT()
        expect(sut: sut, with: .failure(.genericError), when: { clientSpy.complete(with: .failure(.invalidData)) })
    }
    
    func test_load_deliversCorrectDataIfClientCompletesWithSuccess() {
        let countryData = makeCountryCase().model
        let (sut, clientSpy) = makeSUT()
        expect(sut: sut, with: .success(countryData), when: { clientSpy.complete(with: .success(countryData.toData())) })
    }
    
    func test_load_deliversInvalidDataErrorIfClientCompletesWithInvalidData() {
        let (sut, clientSpy) = makeSUT()
        expect(sut: sut, with: .failure(.invalidData), when: { clientSpy.complete(with: .success("Data".data(using: .utf8)!)) })
    }
}

// MARK: - Helpers
private extension LoadRemoteBrazilianCasesTests {
    func makeSUT(url: URL = URL(string: "https://www.init.com")!) -> (LoadRemoteBrazilianCases, HttpClientSpy) {
        let spy = HttpClientSpy()
        let sut = LoadRemoteBrazilianCases(url: url, httpClient: spy)
        trackForMemoryLeaks(instance: sut)
        trackForMemoryLeaks(instance: spy)
        return (sut, spy)
    }
    
    func expect(sut: LoadRemoteBrazilianCases, with expectedResult: CountryCasesLoader.Result, when action: () -> Void) {
        var receivedResult: CountryCasesLoader.Result?
        sut.load(completion: { receivedResult = $0 })
        action()
        XCTAssertEqual(receivedResult, expectedResult)
    }
}
