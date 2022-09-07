//
//  HomePresenterTests.swift
//  Covid-19 TrackerTests
//
//  Created by Luiz Diniz Hammerli on 12/04/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import XCTest
@testable import Covid_19_Tracker

final class HomePresenterTests: XCTestCase {
    func test_init_shouldNotLoadAnyCaseData() {
        let (_, spy) = makeSUT()
        
        XCTAssertTrue(spy.completions.isEmpty)
    }
    
    func test_didStartLoading_shouldReturnCorrectViewModelMessage() {
        let (sut, spy) = makeSUT()
        sut.loadBrazilianCases()
        
        XCTAssertEqual(spy.messages, [.load(isLoading: true)])
    }
    
    func test_didFinishLoadingWithSuccess_shouldReturnCorrectViewModelMessage() {
        let (sut, spy) = makeSUT()
        sut.loadBrazilianCases()
        
        spy.complete(with: .success(makeCountryCase().model), at: 0)
        
        XCTAssertEqual(spy.messages, [.load(isLoading: true), .load(isLoading: false), .display])
    }
    
    func test_didFinishLoadingWithError_shouldReturnCorrectViewModelMessage() {
        let (sut, spy) = makeSUT()
        sut.loadBrazilianCases()
        
        spy.complete(with: .failure(.genericError), at: 0)
        
        XCTAssertEqual(spy.messages, [.load(isLoading: true), .load(isLoading: false), .alert(description: ErrorMessages.genericError.rawValue)])
    }
    
    func test_loadBrazilianCases_shouldNotCompleteIfInstanceHasBeenDealocated() {
        let spy = LoadCountryCasesSpy()
        var sut: HomePresenter? = HomePresenter(loader: spy, loadingView: spy, homeView: spy, alertView: spy)
        
        sut?.loadBrazilianCases()
        sut = nil
        spy.complete(with: .success(makeCountryCase().model), at: 0)
        
        XCTAssertEqual(spy.messages, [.load(isLoading: true)])
    }
}

private extension HomePresenterTests {
    func makeSUT() -> (HomePresenter, LoadCountryCasesSpy) {
        let spy = LoadCountryCasesSpy()
        let sut = HomePresenter(loader: spy, loadingView: spy, homeView: spy, alertView: spy)

        trackForMemoryLeaks(instance: spy)
        trackForMemoryLeaks(instance: sut)

        return (sut, spy)
    }
}
