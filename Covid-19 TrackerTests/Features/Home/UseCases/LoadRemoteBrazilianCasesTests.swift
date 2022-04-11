//
//  LoadBrazilianCasesTests.swift
//  Covid-19 TrackerTests
//
//  Created by Luiz Hammerli on 10/04/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import XCTest
@testable import Covid_19_Tracker

protocol LoadCountryCases {
    typealias Result = Swift.Result<CountryCases, ErrorMessages>
    
    func load(completion: @escaping (Result) -> Void)
}

final class LoadRemoteBrazilianCases: LoadCountryCases {
    let url: URL
    let httpClient: HttpClient
    
    init(url: URL, httpClient: HttpClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    func load(completion: @escaping (LoadCountryCases.Result) -> Void) {
        httpClient.get(from: url) { _ in
            
        }
    }
}

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
    
    func test_load_() {
        
    }
}

// MARK: - Helpers
extension LoadRemoteBrazilianCasesTests {
    func makeSUT(url: URL = URL(string: "https://www.init.com")!) -> (LoadRemoteBrazilianCases, HttpClientSpy) {
        let spy = HttpClientSpy()
        let sut = LoadRemoteBrazilianCases(url: url, httpClient: spy)
        return (sut, spy)
    }
    
    func makeURL(stringURL: String = "https://www.test.com") -> URL {
        return URL(string: stringURL)!
    }
}

final class HttpClientSpy: HttpClient {
    var messages = [(url: URL, completion: (HttpClient.Result) -> Void)]()
    
    var urls: [URL] { messages.map { $0.url } }
    
    func get(from url: URL, completion: @escaping (HttpClient.Result) -> Void) {
        messages.append((url, completion))
    }
}
