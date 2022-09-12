//
//  LoadAllCasesTests.swift
//  Covid-19 TrackerTests
//
//  Created by Luiz Diniz Hammerli on 07/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import XCTest

@testable import Covid_19_Tracker

final class LoadAllCasesTests: XCTestCase {
    var receivedResultData: LoadAllCases.Result?
    
    override func setUp() async throws {
        receivedResultData = nil
    }
    
    func test_load_shouldFailIfDatasourceComplesWithFailure() {
        let testData = makeSUT()
        
        expect(sut: testData.sut, with: .failure(.invalidData)) {
            testData.allCountriesSpy.complete(with: .failure(.invalidURL), at: 0)
            testData.loadWorldSpy.complete(with: .failure(.invalidURL), at: 0)
        }
    }
    
    func test_load_should_() {
        let testData = makeSUT()
        
        expect(sut: testData.sut, with: .success(.init(worldCases: nil, countryCases: []))) {
            testData.allCountriesSpy.complete(with: .success([]), at: 0)
            testData.loadWorldSpy.complete(with: .failure(.invalidURL), at: 0)
        }
    }
    
    func test_load_should__() {
        let worldCasesFake = makeWorldCases()
        let fakeAllCases = AllCases(worldCases: worldCasesFake, countryCases: [])
        let testData = makeSUT()
        
        expect(sut: testData.sut, with: .success(fakeAllCases)) {
            testData.allCountriesSpy.complete(with: .failure(.invalidURL), at: 0)
            testData.loadWorldSpy.complete(with: .success(worldCasesFake), at: 0)
        }
    }
    
    func test_load_should___() {
        let worldCasesFake = makeWorldCases()
        let countryCasesFake = makeCountryCase().model
        let fakeAllCases = AllCases(worldCases: worldCasesFake, countryCases: [countryCasesFake])
        let testData = makeSUT()
        
        expect(sut: testData.sut, with: .success(fakeAllCases)) {
            testData.allCountriesSpy.complete(with: .success([countryCasesFake]), at: 0)
            testData.loadWorldSpy.complete(with: .success(worldCasesFake), at: 0)
        }
    }
    
    func test_load_should____() {
        let loadWorldSpy = LoadWorldCasesSpy()
        let allCountriesSpy = AllCountriesLoaderSpy()
        let sut = LoadAllCases(worldCasesLoader: loadWorldSpy, allCountriesLoader: allCountriesSpy)
        
        let exp = expectation(description: "Dealocated Instance Test")
        
        sut.load(completion: { result in
            XCTAssertFalse(Thread.isMainThread)
            exp.fulfill()
        })

        allCountriesSpy.complete(with: .success([]), at: 0)
        loadWorldSpy.complete(with: .failure(.invalidData), at: 0)
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_load_shouldNotCompleteIfInstanceHasBeenDealocated() {
        let loadWorldSpy = LoadWorldCasesSpy()
        let allCountriesSpy = AllCountriesLoaderSpy()
        var sut: LoadAllCases? = LoadAllCases(worldCasesLoader: loadWorldSpy, allCountriesLoader: allCountriesSpy)
        
        let exp = expectation(description: "Dealocated Instance Test")
        
        sut?.load(completion: { [weak self] result in
            self?.receivedResultData = result
            XCTFail("Expect not complete if instance has been dealocated")
            exp.fulfill()
        })

        sut = nil
        allCountriesSpy.complete(with: .success([]), at: 0)
        loadWorldSpy.complete(with: .failure(.invalidData), at: 0)
        
        wait(for: [exp], timeout: 1)
    }
    
    override func waiter(_ waiter: XCTWaiter, didTimeoutWithUnfulfilledExpectations unfulfilledExpectations: [XCTestExpectation]) {
        guard !unfulfilledExpectations.isEmpty else {  super.waiter(waiter, didTimeoutWithUnfulfilledExpectations: unfulfilledExpectations); return }

        if unfulfilledExpectations.first?.description == "Dealocated Instance Test" {
            XCTAssertNil(receivedResultData)
        } else {
            super.waiter(waiter, didTimeoutWithUnfulfilledExpectations: unfulfilledExpectations)
        }
    }
}

private extension LoadAllCasesTests {
    struct TestModel {
        let sut: LoadAllCases
        let loadWorldSpy: LoadWorldCasesSpy
        let allCountriesSpy: AllCountriesLoaderSpy
    }
    
    func makeSUT(url: URL = makeURL()) -> TestModel {
        let loadWorldSpy = LoadWorldCasesSpy()
        let allCountriesSpy = AllCountriesLoaderSpy()
        let sut = LoadAllCases(worldCasesLoader: loadWorldSpy, allCountriesLoader: allCountriesSpy)
        
        trackForMemoryLeaks(instance: allCountriesSpy)
        trackForMemoryLeaks(instance: loadWorldSpy)
        trackForMemoryLeaks(instance: sut)
        
        return TestModel(sut: sut, loadWorldSpy: loadWorldSpy, allCountriesSpy: allCountriesSpy)
    }
    
    func expect(sut: LoadAllCases,
                with expectedResult: LoadAllCases.Result,
                when action: @escaping () -> Void) {
        var receivedData: LoadAllCases.Result?
        let exp = expectation(description: #function)
        
        sut.load(completion: { result in
            receivedData = result
            exp.fulfill()
        })

        action()
        
        wait(for: [exp], timeout: 1)

        XCTAssertEqual(receivedData, expectedResult)
    }
}

final class LoadWorldCasesSpy: WorldCasesLoader {
    var completions = [(WorldCasesLoader.Result) -> Void]()
    
    func load(completion: @escaping (WorldCasesLoader.Result) -> Void) {
        self.completions.append(completion)
    }
    
    func complete(with result: WorldCasesLoader.Result, at index: Int) {
        completions[index](result)
    }
}

final class AllCountriesLoaderSpy: AllCountriesLoader {
    var completions = [(AllCountriesLoader.Result) -> Void]()
    
    func load(completion: @escaping (AllCountriesLoader.Result) -> Void) {
        self.completions.append(completion)
    }
    
    func complete(with result: AllCountriesLoader.Result, at index: Int) {
        completions[index](result)
    }
}

