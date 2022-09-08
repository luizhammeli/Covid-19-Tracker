//
//  WorldCasesPresenterTests.swift
//  Covid-19 TrackerTests
//
//  Created by Luiz Diniz Hammerli on 08/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import XCTest

@testable import Covid_19_Tracker

final class WorldCasesPresenterTests: XCTestCase {
    func test_init_shouldNotLoadData() {
        let (_, spy, _) = makeSUT()
        
        XCTAssertTrue(spy.messages.isEmpty)
    }
    
    func test_loadCases_shouldCallAlertViewDelegateIfLoadFails() {
        let (sut, spy, viewSpy) = makeSUT()
        
        sut.loadCases()
        spy.complete(with: .failure(.invalidData))
        
        XCTAssertEqual(viewSpy.receivedAlertMessages, [AlertViewModel(description: "The data received from the server was invalid. Please try again.")])
    }
    
    func test_loadCases_shouldNotDeliverDataIfLoadFails() {
        let (sut, spy, viewSpy) = makeSUT()
        
        sut.loadCases()
        spy.complete(with: .failure(.invalidData))
        
        XCTAssertTrue(viewSpy.receivedViewMessages.isEmpty)    }
    
    func test_loadCases_shouldNotCallAlertDelegateIfLoadSucceed() {
        let (sut, spy, viewSpy) = makeSUT()
        
        sut.loadCases()
        spy.complete(with: .success(makeAllCases()))
        
        XCTAssertTrue(viewSpy.receivedAlertMessages.isEmpty)
    }
    
    func test_loadCases_shouldDeliverDataIfLoadSucceed() {
        let (sut, spy, viewSpy) = makeSUT()
        
        sut.loadCases()
        spy.complete(with: .success(makeAllCases()))
        
        XCTAssertFalse(viewSpy.receivedViewMessages.isEmpty)
    }
    
    func test_loadCases_shouldDeliverDataIfLoadSucceedWithEmptyData() {
        let (sut, spy, viewSpy) = makeSUT()
        
        sut.loadCases()
        spy.complete(with: .success(AllCases(worldCases: nil, countryCases: [])))
        
        XCTAssertEqual(viewSpy.receivedViewMessages, [.init(header: nil, items: [])])
    }
    
    func test_loadCases_shouldNotCompleteIfInstanceHasBeenDealocated() {
        let useCaseSpy = LoadAllCasesSpy()
        let viewSpy = AlertViewSpy()
        var sut: WorldCasesPresenter? = WorldCasesPresenter(loader: useCaseSpy, alertView: viewSpy, worldCasesView: viewSpy)
        
        sut?.loadCases()
        sut = nil
        useCaseSpy.complete(with: .success(makeAllCases()))
        
        XCTAssertTrue(viewSpy.receivedViewMessages.isEmpty)
        XCTAssertTrue(viewSpy.receivedAlertMessages.isEmpty)
    }
}

private extension WorldCasesPresenterTests {
    func makeSUT() -> (WorldCasesPresenter, LoadAllCasesSpy, AlertViewSpy) {
        let useCaseSpy = LoadAllCasesSpy()
        let alertViewSpy = AlertViewSpy()
        let sut = WorldCasesPresenter(loader: useCaseSpy, alertView: alertViewSpy, worldCasesView: alertViewSpy)
        
        trackForMemoryLeaks(instance: useCaseSpy)
        trackForMemoryLeaks(instance: alertViewSpy)
        trackForMemoryLeaks(instance: sut)
        
        return (sut, useCaseSpy, alertViewSpy)
    }
}

final class AlertViewSpy: AlertView, WorldCasesView {
    var receivedAlertMessages: [AlertViewModel] = []
    var receivedViewMessages: [WorldCasesViewModelItem] = []

    func display(message: AlertViewModel) {
        receivedAlertMessages.append(message)
    }
    
    func display(viewModel: WorldCasesViewModelItem) {
        receivedViewMessages.append(viewModel)
    }
}

final class LoadAllCasesSpy: WorldCasesWithCountriesLoader {
    var messages: [(WorldCasesWithCountriesLoader.Result) -> Void] = []

    func load(completion: @escaping (WorldCasesWithCountriesLoader.Result) -> Void) {
        messages.append(completion)
    }
    
    func complete(with result: WorldCasesWithCountriesLoader.Result, at index: Int = 0) {
        messages[index](result)
    }
}
