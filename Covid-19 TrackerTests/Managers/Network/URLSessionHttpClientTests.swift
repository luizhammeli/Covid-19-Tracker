//
//  URLSessionHttpClient.swift
//  Covid-19 TrackerTests
//
//  Created by Luiz Diniz Hammerli on 08/04/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import XCTest
@testable import Covid_19_Tracker

final class URLSessionHttpClientTests: XCTestCase {
    override class func setUp() {
        URLProtocolStub.startIntercepting()
    }
    
    override class func tearDown() {
        URLProtocolStub.stopIntercepting()
    }
    
    func test_get_requestWithCorrectURL() {
        let url = makeURL()
        var receveivedRequest: URLRequest?
        let sut = makeSUT()
        
        let exp = expectation(description: #function)
        URLProtocolStub.observeRequest { receveivedRequest = $0 }
        sut.get(from: url, completion: { _ in exp.fulfill() })
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receveivedRequest?.url, url)
        XCTAssertEqual(receveivedRequest?.httpMethod?.lowercased(), "get")
    }
    
    func test_get_requestFailsWithError() {
        expect(.failure(.noConnectivity), with: makeNSError(), response: nil, data: nil)
    }
    
    func test_get_requestFailsWithAllInvalidCases() {
        expect(.failure(.noConnectivity), with: makeNSError(), response: makeURLResponse(), data: makeData())
        expect(.failure(.noConnectivity), with: makeNSError(), response: makeURLResponse(statusCode: 200), data: makeData())
        expect(.failure(.noConnectivity), with: makeNSError(), response: nil, data: makeData())
        expect(.failure(.noConnectivity), with: makeNSError(), response: makeURLResponse(statusCode: 200), data: nil)
        expect(.failure(.invalidResponse), with: nil, response: makeURLResponse(statusCode: 400), data: makeData())
        expect(.failure(.invalidResponse), with: nil, response: nil, data: makeData())
        expect(.failure(.invalidResponse), with: nil, response: nil, data: Data())
        expect(.failure(.invalidData), with: nil, response: makeURLResponse(statusCode: 200), data: nil)
        expect(.failure(.invalidData), with: nil, response: makeURLResponse(statusCode: 200), data: Data())
    }
    
    func test_get_succeedsWithReponseAndData() {
        let data = makeData()
        expect(.success(data), with: nil, response: makeURLResponse(statusCode: 200), data: makeData())
    }
}

// MARK: - Helpers
private extension URLSessionHttpClientTests {
    func makeSUT() -> URLSessionHttpClient {
        let sut = URLSessionHttpClient()
        return sut
    }
    
    func expect(_ expectedResult: URLSessionHttpClient.Result,
                with error: Error?,
                response: URLResponse?,
                data: Data?,
                file: StaticString = #filePath,
                line: UInt = #line) {
        var receivedResult: HttpClient.Result?
        let sut = makeSUT()
        URLProtocolStub.stub(error: error, response: response, data: data)
        
        let exp = expectation(description: #function)
        sut.get(from: makeURL(), completion: { result in
            receivedResult = result
            exp.fulfill()
        })
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(receivedResult,
                       expectedResult, "Expected \(expectedResult) got \(String(describing: receivedResult)) instead",
                       file: file,
                       line: line)
    }
    
    func makeURL() -> URL {
        return URL(string: "https://www.test.com")!
    }
    
    func makeNSError() -> NSError {
        NSError(domain: "", code: 10, userInfo: nil)
    }
    
    func makeURLResponse(statusCode: Int = 200) -> URLResponse {
        return HTTPURLResponse(url: makeURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
    
    func makeData() -> Data {
        return "New Test".data(using: .utf8)!
    }
}

struct Stub {
    let error: Error?
    let response: URLResponse?
    let data: Data?
}

final class URLProtocolStub: URLProtocol {
    private static var stub: Stub?
    private static var requestObserver: ((URLRequest) -> Void)?
    
    static func startIntercepting() {
        URLProtocol.registerClass(URLProtocolStub.self)
    }
    
    static func stopIntercepting() {
        URLProtocol.unregisterClass(URLProtocolStub.self)
    }
    
    static func observeRequest(with observer: @escaping ((URLRequest) -> Void)) {
        URLProtocolStub.requestObserver = observer
    }
    
    static func stub(error: Error?, response: URLResponse?, data: Data?) {
        URLProtocolStub.stub = Stub(error: error, response: response, data: data)
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let requestObserver = URLProtocolStub.requestObserver {
            client?.urlProtocolDidFinishLoading(self)
            return requestObserver(request)
        }
        
        if let response = URLProtocolStub.stub?.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        if let error = URLProtocolStub.stub?.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
        if let data = URLProtocolStub.stub?.data {
            client?.urlProtocol(self, didLoad: data)
        }

        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        URLProtocolStub.requestObserver = nil
        URLProtocolStub.stub = nil
    }
}
